Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27DD7E799;
	Mon,  8 Apr 2024 13:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582294; cv=none; b=Xz0vY88XVkp2P7bd1BNxkWgy9G/oRYsxLq+pgm2GN6BqgJkNvRXO2rj/oF+8XOkub4V6kQsjW2WT8Tjdo2p/asTsWaCxS4PliC5u/ruhNS4pyX4xZEHM/4z8BnNp5AWJhz3WnngMxlfn+M61DL397B9EBvMhCtAeXZjc/otzMNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582294; c=relaxed/simple;
	bh=vgpBT0La6bLHdSodZMnmnpGCwVs/wZvvNLEOWRlcMRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GJXHulevxCgv2nKX+Ulrz5wg1/+JDqi6lUKkfXzic9GjriIiAlBr2qrTsKB6KlRBs5BqKg+xgseG4qGN2Cii3Yy1yClRnKpl2BqDPoOs9WR48ZjLAcyX4wpj1K/vCqh8Dqp1Vl8SHHHx4bvY0xMOjfZLUdOT8gLsTfv7SrNTQTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIEDvJmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIEDvJmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED99C433C7;
	Mon,  8 Apr 2024 13:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582293;
	bh=vgpBT0La6bLHdSodZMnmnpGCwVs/wZvvNLEOWRlcMRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIEDvJmS6Vgae0qh6bIu8mfxzXi7RaJJtslfXgBgRcvAqKNdjcBshi/7vxENXgLwX
	 dR/EWQ6OFfTdaTzHNfBhVgJWTrQO0UJsp/UncgNRDh7d2lsKsaahIRsd2u9naLtVAr
	 8OM1QRcg4sMlZQCkqMnSWUCIohbdMc6LGvuuabhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 072/252] selinux: avoid dereference of garbage after mount failure
Date: Mon,  8 Apr 2024 14:56:11 +0200
Message-ID: <20240408125308.866991066@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2135,7 +2135,6 @@ static struct file_system_type sel_fs_ty
 	.kill_sb	= sel_kill_sb,
 };
 
-static struct vfsmount *selinuxfs_mount __ro_after_init;
 struct path selinux_null __ro_after_init;
 
 static int __init init_sel_fs(void)
@@ -2157,18 +2156,21 @@ static int __init init_sel_fs(void)
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


