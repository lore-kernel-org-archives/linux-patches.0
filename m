Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236CE183092;
	Sun,  1 Sep 2024 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209361; cv=none; b=tgekoXbaF1UeXP9wQ+CahSJ5pGbl/H+Uk2TmkMVnPIiGSgvV0jF8rlIwhxVcLoMzAygxsWq6G3xnUDjxzy1UKuPoib9SOcCw9zYhqFidbOQfZQ4ur0HeO+anmBeq9/om8Erw/B/y5Yy2XEmrBdUXKghEe7LE8hsRE9cai8v5ays=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209361; c=relaxed/simple;
	bh=jzaemdfIJgLmQoqXW4iB3o6xzckJDJiM0dCkG47hTVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2EZPFZY36uiOaKqp2bT2vnxdgrVB6NKLJnECtDU47jkkXK3GIK4VrJZL7FNIc6Ousq0WhWgjUzn2iSuWolvLczG9St+9NujqruOB0VTYeAXZLNhiQnVaaWqWja/XchDGUb+jdxpLJtNkZLtZo34x0HROSr8JtM/569KmDIdcwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LN9Mebs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LN9Mebs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EE7C4CEC3;
	Sun,  1 Sep 2024 16:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209361;
	bh=jzaemdfIJgLmQoqXW4iB3o6xzckJDJiM0dCkG47hTVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LN9MebsdN7Qas2iZDlD12Er8JR1x3ALMNVI5Bh+n6n8FHdEDOLUYC1GvP8eQscyB
	 C4mmLX1ypM2Dx+Exl07ygxBtPACmeGJkQLfxktF3OPODJOMNsDT08E1kFo4tku1te8
	 5ZuWlTxmLRqtPGO61e5dWiEAg4MrnrJUN8lNlImc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 012/151] selinux: fix potential counting error in avc_add_xperms_decision()
Date: Sun,  1 Sep 2024 18:16:12 +0200
Message-ID: <20240901160814.562266150@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Lei <thunder.leizhen@huawei.com>

commit 379d9af3f3da2da1bbfa67baf1820c72a080d1f1 upstream.

The count increases only when a node is successfully added to
the linked list.

Cc: stable@vger.kernel.org
Fixes: fa1aa143ac4a ("selinux: extended permissions for ioctls")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/avc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -332,12 +332,12 @@ static int avc_add_xperms_decision(struc
 {
 	struct avc_xperms_decision_node *dest_xpd;
 
-	node->ae.xp_node->xp.len++;
 	dest_xpd = avc_xperms_decision_alloc(src->used);
 	if (!dest_xpd)
 		return -ENOMEM;
 	avc_copy_xperms_decision(&dest_xpd->xpd, src);
 	list_add(&dest_xpd->xpd_list, &node->ae.xp_node->xpd_head);
+	node->ae.xp_node->xp.len++;
 	return 0;
 }
 


