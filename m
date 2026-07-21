Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48ED4471265;
	Tue, 21 Jul 2026 20:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664380; cv=none; b=abSSYqJi0oKNNhHRx89H/WbElvggiMaMRk1jTLpmhgeFoP1sO0ZOU80gUGwrenSCPOxC5g0rp2VqgpD3b8pMbwpO5Y5l1LYlEwdfnAN+gvo9Ei8OUkhWUAbBV/HeL63ncgKt74utOmCOYKq42Ddgk/9JpnpyvivDofIGIoj7qXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664380; c=relaxed/simple;
	bh=DkER/GLVeTgQYABAVTiH907NiV3HvQnSILWAvHhFGCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7endBsoEY4QWRKEZPQVLUzSo4vT/v5uAZTC84GVY3D/slHDpvHiGsAUYPWbEpMd+zdBZeFgVmzfIStEpu8fB7mW22MGKSAIr3mXqYpf6FifqGJuTnAMeBvd2mVH/iczWnLMwFyaw4Eh/Hzl7vm9YNyb2Dgdj7Eo5ZVYhPeHW+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiqX/2Al; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiqX/2Al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AB61F000E9;
	Tue, 21 Jul 2026 20:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664379;
	bh=FWi0rE0aR9IXUzrPc31uJ00JzpG0azNo39HOcSm72Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IiqX/2AlbrQyILP5cmd/X1nX5Dt8B8ygWCoh9/syy+9MC230ABLvEG90p1RJcTNdm
	 zVk/s2oxtKXRotfSM41pGousBZg1Xc1LWT0lcTRU5+IohiPpfXup5VWnqqdz1mysvN
	 cX04PD3Kuc7/0E0/RrT0EdhWMoA/Fvkc0omracKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1178/1276] smb: client: Improve unlocking of a mutex in cifs_get_swn_reg()
Date: Tue, 21 Jul 2026 17:27:01 +0200
Message-ID: <20260721152512.394537690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit e2080b70c5851a132547bec3bd7dde847e649678 ]

Use two additional labels so that another bit of common code can be better
reused at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: ec457f9afe5a ("smb: client: resolve SWN tcon from live registrations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifs_swn.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -313,17 +313,15 @@ static struct cifs_swn_reg *cifs_get_swn
 	reg = cifs_find_swn_reg(tcon);
 	if (!IS_ERR(reg)) {
 		kref_get(&reg->ref_count);
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		return reg;
+		goto unlock;
 	} else if (PTR_ERR(reg) != -EEXIST) {
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		return reg;
+		goto unlock;
 	}
 
 	reg = kmalloc(sizeof(struct cifs_swn_reg), GFP_ATOMIC);
 	if (reg == NULL) {
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		return ERR_PTR(-ENOMEM);
+		ret = -ENOMEM;
+		goto fail_unlock;
 	}
 
 	kref_init(&reg->ref_count);
@@ -354,7 +352,7 @@ static struct cifs_swn_reg *cifs_get_swn
 	reg->ip_notify = (tcon->capabilities & SMB2_SHARE_CAP_SCALEOUT);
 
 	reg->tcon = tcon;
-
+unlock:
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 
 	return reg;
@@ -365,6 +363,7 @@ fail_idr:
 	idr_remove(&cifs_swnreg_idr, reg->id);
 fail:
 	kfree(reg);
+fail_unlock:
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 	return ERR_PTR(ret);
 }


