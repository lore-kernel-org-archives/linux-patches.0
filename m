Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F33F1E0083;
	Wed,  6 Nov 2024 13:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898089; cv=none; b=nD3cOHl7mXF0GXgF2tVckIVr4y67i49fM9rXZmKhL03OHdGkNpbuhfA2oVs4+PkAGi0DPsCnhbZeyNyrv4FWI49fep76qwA2M0JDh0O1RQ4+iGxJftgJJLsTJm8z0mtGy5XKCjvMAAOWphNQYc+SnyU8R+AkkcmRTM/ow25+1J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898089; c=relaxed/simple;
	bh=0MsFEKkxnV3aHbBWwnM/EanU+JoetEDLE+QR+TdlnSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcUZN17+p8wzxwDqmMNlB1PTXCPyGlMCQt9shsFgqPaNJN7ZKqdk+JLN3wcg0YWRxKlqZASvwXwOH7klCj6ziO0adcjVM8Io7Yt3A8ih/0hTn8S9pleRuG51oGf3CXkkWOg1Jc1F3IdAIgl0gi3Moqd/dKMLRnJMwho6gtQc/L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbtT4Hwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbtT4Hwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882A4C4CECD;
	Wed,  6 Nov 2024 13:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898088;
	bh=0MsFEKkxnV3aHbBWwnM/EanU+JoetEDLE+QR+TdlnSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbtT4Hwl1A4sS84nn4Uvetu6SbgPGGzPD3e6VjINOri7l5M5fPzIg+K5AEmanZQ4z
	 VT8X7ACM1JqnorekTkJIh/0OuQ8gfUlpgQK6tuQlKP+fS2A5K0Gm52Ev+V1Lxkvn3O
	 3NZCp58G/jHLqE21TPSnkzLvrr8NnCCAGNjRjkIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/462] RDMA/cxgb4: Added NULL check for lookup_atid
Date: Wed,  6 Nov 2024 13:00:14 +0100
Message-ID: <20241106120334.495964977@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Lobanov <m.lobanov@rosalinux.ru>

[ Upstream commit e766e6a92410ca269161de059fff0843b8ddd65f ]

The lookup_atid() function can return NULL if the ATID is
invalid or does not exist in the identifier table, which
could lead to dereferencing a null pointer without a
check in the `act_establish()` and `act_open_rpl()` functions.
Add a NULL check to prevent null pointer dereferencing.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: cfdda9d76436 ("RDMA/cxgb4: Add driver for Chelsio T4 RNIC")
Signed-off-by: Mikhail Lobanov <m.lobanov@rosalinux.ru>
Link: https://patch.msgid.link/20240912145844.77516-1-m.lobanov@rosalinux.ru
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index c7214c49f202f..01750eb5458e0 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1222,6 +1222,8 @@ static int act_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 	int ret;
 
 	ep = lookup_atid(t, atid);
+	if (!ep)
+		return -EINVAL;
 
 	pr_debug("ep %p tid %u snd_isn %u rcv_isn %u\n", ep, tid,
 		 be32_to_cpu(req->snd_isn), be32_to_cpu(req->rcv_isn));
@@ -2279,6 +2281,9 @@ static int act_open_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	int ret = 0;
 
 	ep = lookup_atid(t, atid);
+	if (!ep)
+		return -EINVAL;
+
 	la = (struct sockaddr_in *)&ep->com.local_addr;
 	ra = (struct sockaddr_in *)&ep->com.remote_addr;
 	la6 = (struct sockaddr_in6 *)&ep->com.local_addr;
-- 
2.43.0



