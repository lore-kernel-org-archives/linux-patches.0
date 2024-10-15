Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097CE1EABAB;
	Tue, 15 Oct 2024 11:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992912; cv=none; b=I7UleNn2AY8mySBEysOOp20K5psewazQJKBXN4OsqNfit6z6vC77F+8wsrUqA+flk6eTgIosMW47F67NBOqlCOn3XNQBEEuUQ/Ab5S5Hcw3LKbAp76OswMcZSmAfitH6blCw7lul2KuP8f52CwpcAXKntVdMWn07pV2h01FECio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992912; c=relaxed/simple;
	bh=KVHyR/DP5RBhCcq0YX6krS35vL3sy6WZun9UcUKMc+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7zAv916bWTeITpTH2ZitN3kEf0THbH6jNkgZqfk4Ww12drFjNKegCaNtioFf8EKF7ue7pWlnnm8lQ1frE1108BT2K/ffXUHrXEVo5+CskxgUzsaOYtxqcH6rWpSGb0eTuuV5JqUGcHiSESVtavfjXdqJl2gBvrIL2Y+K9/Z2Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ti0ywYvo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ti0ywYvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BA6C4CECE;
	Tue, 15 Oct 2024 11:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992911;
	bh=KVHyR/DP5RBhCcq0YX6krS35vL3sy6WZun9UcUKMc+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ti0ywYvoo/yxlQqeJbqq8r7+3O1UbWh69M4EF3VwOUBsq0emqXjgqNXWpTuArg1JZ
	 pVEA4VZmZwsIEgnzOca2/EnenGs6Ew0+1Cql2+dEGqH6iIzpNggYXzN36BJc9jF9DX
	 XyAGZMZreqtKUVcKgCM386IHTIpfDwZiWaXSWxOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 256/691] RDMA/cxgb4: Added NULL check for lookup_atid
Date: Tue, 15 Oct 2024 13:23:24 +0200
Message-ID: <20241015112450.511709311@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f159cbb6bb3ea..e6343c89c892e 100644
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



