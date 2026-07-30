Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C926402444;
	Thu, 30 Jul 2026 14:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421908; cv=none; b=hvpgdftHEL9zr1W6LHJnMuZERdA+mCo6VJiuf/ujt4BP/Gp/AM3OkjK88wN/fEflHD9tX1Hr1ZmmhEXNjkf0kwkIQK9b6Ak3sjJ/wh0MBXFit6ljbN+xvqn1gCwRvuAmd29ckLuvpZwwOzxbw+yx/jVqfjIdF8rQq4Wyr9tJMzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421908; c=relaxed/simple;
	bh=5yaJ2e5XpyG9fxsqU1TcD/gXldELvxgwtptjQGjFvUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbWBlta4vzPfZu/AKS9HfvsqS1WM3iqiJk+RCw/IBhGslSt6ZE5WEC3iI/S48tuQ8Ooml+kzMl5/ZQbI0SXb3+lQoRl8tMOBN8KjoDI5Xk3L03zlCHNxNe0DgdYR8frokipP9qW2+U6V0mzgu1b1kJ9GRQiFy0JnYe3hpsDzj0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lq79AfPY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lq79AfPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A738B1F000E9;
	Thu, 30 Jul 2026 14:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421907;
	bh=M7NBlHOb9B3ye8HwJHmYs5GIJlb3oZXFJNH3SIPS5mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lq79AfPY2MZTgufPOW2v5ixQMSP8pYGZzjU5DoUNXBXyrXzQR52aWE64+YpX7Lpv8
	 dJqjfwBv6/JeJGTa37Utz8APUA6Baqd3eLGFzh+ZLsvVsVmErG+m6pEyQtDxotJXrY
	 3vWN0V534PPQfm4hKpDfnHOp7h+IlAZ2KRIUGTCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 259/744] geneve: fix hint header definition wrt endianness
Date: Thu, 30 Jul 2026 16:08:52 +0200
Message-ID: <20260730141449.799400168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 751bfa982b4a6de8275a552804f6971adcf08473 ]

Bitfields are packed differently depending on the endianness, take it into
account in the GRO hint header definition.

Fixes: e0a12cbf262b ("geneve: add GRO hint output path")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260529144713.780938-1-atenart%40kernel.org
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260709124801.140632-1-atenart@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index c55bdb805a644f..e9102548ac438d 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -43,8 +43,17 @@ MODULE_PARM_DESC(log_ecn_error, "Log packets received with corrupted ECN");
 #define GENEVE_OPT_GRO_HINT_LEN		1
 
 struct geneve_opt_gro_hint {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
 	u8	inner_proto_id:2,
-		nested_is_v6:1;
+		nested_is_v6:1,
+		rsvd:5;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	u8	rsvd:5,
+		nested_is_v6:1,
+		inner_proto_id:2;
+#else
+#error "Please fix <asm/byteorder.h>"
+#endif
 	u8	nested_nh_offset;
 	u8	nested_tp_offset;
 	u8	nested_hdr_len;
-- 
2.53.0



