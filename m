Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3E61C68C;
	Sun,  1 Sep 2024 16:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208692; cv=none; b=IKlEc/HTSVVseMlLxZM/toVWZI37Qfm4tNw2UfIErkoM4zYgbq0VOaj9Bin1uAjlWP7KF8V8wMBuArh0C4dxTMjv8qdu0ivRDKIHMQODShx0cDxcMdTM0iSb5fcFF1lv3rXsKCAIO9r+i1VDkxWZXokjW2QRdVyhuzfW062YdEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208692; c=relaxed/simple;
	bh=wakBcYyoWC4/7y7zu45bGzlT11TI+OkEq3Wfk+3TEcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lU/lXZFNMh0Q7iS0LrLC9e2teW83m8V0ke2zhJ/bAh3HlTNag3b7lUW28l+1bpewMiI0JeVe5qWW28zCCoOvzItJ/Jszyb6oMxsUsUIOcDwQuS16opTd2S6HGpYiLJvtmHoWnvX4xS76vsZAe9RJv/aD1mN3PcVf5ZpcSX/bHZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpGHuQEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpGHuQEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9199C4CEC3;
	Sun,  1 Sep 2024 16:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208692;
	bh=wakBcYyoWC4/7y7zu45bGzlT11TI+OkEq3Wfk+3TEcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpGHuQEHCVAlkTjuJ4aB+8RAKf6r2+w4W3zaCi8CN2r04KdNP1+S/2EYe2J8pOde6
	 i8IaV6ouIgaoLjl+dBplmigQEIhk6GZlP69yIhaiQaddodocvAEKrJZNpvp1kAb/E6
	 IKx1NYtuKinLYu4QGCjv4aRXjljB7wm3iNIeGIV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.4 011/134] selinux: fix potential counting error in avc_add_xperms_decision()
Date: Sun,  1 Sep 2024 18:15:57 +0200
Message-ID: <20240901160810.537500774@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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
@@ -329,12 +329,12 @@ static int avc_add_xperms_decision(struc
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
 


