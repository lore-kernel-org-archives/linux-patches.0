Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF2C208A7;
	Sun,  1 Sep 2024 16:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209870; cv=none; b=hiOVdMenfKi5TfEXHMGuCjUNUukhDLlsuPQI+TZ5Y4rs9zy8V16DIcy8c16/0wJLdM+fqk/R+XPsFEzlCaLhfglzukUh5gaBnQvqoWvf63MxfIfDC7IMzjyuP/s17o4ygMOdlbOng24i7hBUvT7GDJN5KfgbjvqhukvwdGMcdKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209870; c=relaxed/simple;
	bh=1/5oytWr3cqIKnmOEur8qPwzD0aaCFSbIOtS5FYsTIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlOgGMK8vK0uUrGMaqV4+1skxUI0ALA723N95NHJaxRdgjqGilRxTmvegaq5dzejJXv36EeRNE2ArtJmzR/LJN42asnSg9f5WZU/urGe2fS3+JUgFGV+Dimf+RVKjJTgtNU7sNCzqJhXz18vZrUa0u0WxjmbVZ+qdE/LR4qt2z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzHnZlwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzHnZlwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6BAC4CEC3;
	Sun,  1 Sep 2024 16:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209870;
	bh=1/5oytWr3cqIKnmOEur8qPwzD0aaCFSbIOtS5FYsTIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fzHnZlweQ0TeJ9/9lOl9czZlR1Lecu8popHJDLQtLbFyB8dYU7p7QwwslBXAnCzBU
	 wg40cFRvhAkrMYjb4Bxc6m9EZ0DGBrCWMUryLNO7Tm5ZrwVPe2M6rU3/uQPfQBPV6L
	 2j0vqbGyUO6gd8SOXf9oYBWsBeheVJN367CU6zlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.15 019/215] selinux: fix potential counting error in avc_add_xperms_decision()
Date: Sun,  1 Sep 2024 18:15:31 +0200
Message-ID: <20240901160823.986358750@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
 


