Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E361374C09;
	Mon,  8 Apr 2024 13:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582361; cv=none; b=Ms6rPjCLDw/+3k9iP8+HsjsAB0McKFux+7Y1eZNgvugZVi9DPrEb4gLESzCFmLA+GqrdYHCfj2r8urJfaqZArcSAsAJhE9uxRBrIn0ntZLh0sTdlB309GjfFXxaa963+W+eNhONSJ9Vwa9Bb/Pm7VbDTcPHKVLdxbF4OGHyvJlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582361; c=relaxed/simple;
	bh=h1dt10nipVLswfPO1OQcz4tSFVg75PnC5MLqRjamSaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KZWBAYhK7yEY1Bwx+Nkws8rVywIzCYbAooyVxaJ6pSNU8pqltrahkXlaEgT6PWvT/a84RQhD4fYO8n/ekBTntbktvC8TjAMXy91RTuBUwoAa1wNZYXqXVggpLXyfIdBFCcwmhS0w7/Hk2HDla5BH31yHN9CgSX1dBvfoCgpWxW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3f5Kqnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3f5Kqnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696F3C43390;
	Mon,  8 Apr 2024 13:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582360;
	bh=h1dt10nipVLswfPO1OQcz4tSFVg75PnC5MLqRjamSaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3f5KqnbTFvLdPlDG+R9Bhx7Ih7qiRxgzVt1acoq+MQtJwGcBygsHQNbLjAGfn+Q7
	 mAXFbriSrfcXkV3EZkcHbJ6NFvVVNBWLW+pwD9BIaaP19jGojRZMvPPM5dq8WDrjdk
	 iC4zjm6gu1xmJ13cCFBAi4UG8pGZwesll0WSlwJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.8 068/273] selinux: avoid dereference of garbage after mount failure
Date: Mon,  8 Apr 2024 14:55:43 +0200
Message-ID: <20240408125311.415746960@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Göttsche <cgzones@googlemail.com>

commit 37801a36b4d68892ce807264f784d818f8d0d39b upstream.

In case kern_mount() fails and returns an error pointer return in the
error branch instead of continuing and dereferencing the error pointer.

While on it drop the never read static variable selinuxfs_mount.

Cc: stable@vger.kernel.org
Fixes: 0619f0f5e36f ("selinux: wrap selinuxfs state")
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/selinuxfs.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -2123,7 +2123,6 @@ static struct file_system_type sel_fs_ty
 	.kill_sb	= sel_kill_sb,
 };
 
-static struct vfsmount *selinuxfs_mount __ro_after_init;
 struct path selinux_null __ro_after_init;
 
 static int __init init_sel_fs(void)
@@ -2145,18 +2144,21 @@ static int __init init_sel_fs(void)
 		return err;
 	}
 
-	selinux_null.mnt = selinuxfs_mount = kern_mount(&sel_fs_type);
-	if (IS_ERR(selinuxfs_mount)) {
+	selinux_null.mnt = kern_mount(&sel_fs_type);
+	if (IS_ERR(selinux_null.mnt)) {
 		pr_err("selinuxfs:  could not mount!\n");
-		err = PTR_ERR(selinuxfs_mount);
-		selinuxfs_mount = NULL;
+		err = PTR_ERR(selinux_null.mnt);
+		selinux_null.mnt = NULL;
+		return err;
 	}
+
 	selinux_null.dentry = d_hash_and_lookup(selinux_null.mnt->mnt_root,
 						&null_name);
 	if (IS_ERR(selinux_null.dentry)) {
 		pr_err("selinuxfs:  could not lookup null!\n");
 		err = PTR_ERR(selinux_null.dentry);
 		selinux_null.dentry = NULL;
+		return err;
 	}
 
 	return err;


