Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B3AA95E;
	Mon, 16 Sep 2024 12:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488066; cv=none; b=HETKLt96b1zebCMABD+EU5pPjWr7Uu/x1GoCnpzcXZ9lJG9sOLB+1pMh/2kA23pyA1SG3vTMKsco3SVo7B+eEBCkw89lccQIy7YBTGWujexVDDTW1GjGLTgn+u7mUuafeL1zfuwybNCRo/2LaqmbE4eY58f3taqMtT4xx42HRIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488066; c=relaxed/simple;
	bh=bwxYMgo0tIDzprL9l1ThnPqL3D63Flv/3cuH2CpZ4Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pk/MT08CoubjXQZHlQgCtgFpXplsUgayVcfHYCxvpyEobGkPSfQlPJ5BQkUKhkJrVJ6xxkg6wJQXaxXtmi4ZI8/YW5otBBlldXbJE4HNOLROXwVkNkVgSYn/sjhWtIlo0lUv3QdWhM+agaeGCohDlYOO27taNuWxGhXSKcaTf+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQ+/5eZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQ+/5eZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE01C4CEC4;
	Mon, 16 Sep 2024 12:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488065;
	bh=bwxYMgo0tIDzprL9l1ThnPqL3D63Flv/3cuH2CpZ4Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQ+/5eZCXmRWHoQfdackeEvji8gsIDjT7vApSwx3CypHG2GSeLW233Cuot/vaRXV+
	 W6WPKjGkX64AFwTLppw9WUmxjDpAMQZcCRgW/ukVTJGNZ32VejkHd9KWqspY3HjkQE
	 aPsBa0YWhBBMtm+WTRFzD3RSZjf9uWoiHQZ4QHQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 47/63] fou: fix initialization of grc
Date: Mon, 16 Sep 2024 13:44:26 +0200
Message-ID: <20240916114222.731712597@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

[ Upstream commit 4c8002277167125078e6b9b90137bdf443ebaa08 ]

The grc must be initialize first. There can be a condition where if
fou is NULL, goto out will be executed and grc would be used
uninitialized.

Fixes: 7e4196935069 ("fou: Fix null-ptr-deref in GRO.")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20240906102839.202798-1-usama.anjum@collabora.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fou.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index 7bcc933103e2..c29c976a2596 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -334,11 +334,11 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 	struct gro_remcsum grc;
 	u8 proto;
 
+	skb_gro_remcsum_init(&grc);
+
 	if (!fou)
 		goto out;
 
-	skb_gro_remcsum_init(&grc);
-
 	off = skb_gro_offset(skb);
 	len = off + sizeof(*guehdr);
 
-- 
2.43.0



