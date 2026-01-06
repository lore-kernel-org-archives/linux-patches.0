Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9346E35F8D3;
	Tue,  6 Jan 2026 17:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721712; cv=none; b=OAzkWJvad5WGLUAxAiNLLFrfdhBD4yO548slsro4w3KaDunQmE2QceRgvj1hx7Vg1XCk/kpwpyb96hou8YJXofD3Z20/nlyHVCr2uUt5PkzLEWTw9Z2J2SHv3n7p+hFjah8kr7/JDwZjHMVP1p/0rIvSrgZuxQnqAVYbPilLsRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721712; c=relaxed/simple;
	bh=rKm3ELVF+T9csxG6Svcba3i3W6mYHsrPkD0aRAhIZeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfJsKxOlTfpSCbbzcE9ioZZcfTvlmj3cuXIoRAEAPiCXVQVqEl2w1OzFAvYqWCo9yk4LAP4b5kybqnEWOjMzsEJCA7TvkyUVJ8Jt9I2RF7udGUNOcfK2+7uRWOmlgBqNwQWS7FTy6TxJb/CtbZHbI58MOeDNDQyLSbbD+CCv32w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vARrdjvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vARrdjvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04760C116C6;
	Tue,  6 Jan 2026 17:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721712;
	bh=rKm3ELVF+T9csxG6Svcba3i3W6mYHsrPkD0aRAhIZeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vARrdjvKyAZYICJMOut3nl6FURp0L5MQcX0YMozhG5koOaEkS9fJJ9a+152hR4eql
	 yI+0dGkpQ2+DSBi8IDhUEHilEQ6+r39aCRyxkt5/fk9RkKuEgpmRtGbVBg4vaCc5gW
	 G2rhomhzx+VHPxo1Er1TJyP3pSagUnZOkijnbaNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/312] net: dsa: b53: skip multicast entries for fdb_dump()
Date: Tue,  6 Jan 2026 18:02:02 +0100
Message-ID: <20260106170549.593349415@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit d42bce414d1c5c0b536758466a1f63ac358e613c ]

port_fdb_dump() is supposed to only add fdb entries, but we iterate over
the full ARL table, which also includes multicast entries.

So check if the entry is a multicast entry before passing it on to the
callback().

Additionally, the port of those entries is a bitmask, not a port number,
so any included entries would have even be for the wrong port.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251217205756.172123-1-jonas.gorski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 62cafced758e..7d6ec2eb7c75 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2155,6 +2155,9 @@ static int b53_fdb_copy(int port, const struct b53_arl_entry *ent,
 	if (!ent->is_valid)
 		return 0;
 
+	if (is_multicast_ether_addr(ent->mac))
+		return 0;
+
 	if (port != ent->port)
 		return 0;
 
-- 
2.51.0



