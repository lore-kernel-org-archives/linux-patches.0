Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828871;
	b=TqyyJh2mRdxJJG1U20uO/Oms6gFAlutYfAR9SiBkMkk9yS4fx7RlnQydpiyI6DIhVfg9
	 /1GwlmKB4YQuiGhBJQM2uCHjHOFP/cvtq038jhIHSgZQHw1tOA3ldMhiDHoTqaCjf5Wgl
	 Z1iknqMnGsgTIkMraeXNo7/ZmbcN7P4/6aYE/PW9dTd/gdueW1dKyTsQo+xTvpMIoh2yj
	 UnxKJ/v9cdoGSC2b690jK3CyHGCWSgmBPU7ayFkQ712fyqotXsSCkThfw18Lcequlm9bn
	 Y+AfcPeeQepElMLqod16vLmBlpWeRSAKhjRZ9UCv8PA1ijNqmITd5G3pyK+ZdxlkEkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wod6Tmlgd1E4duJTtL807UQ7n4lVqJnBKBEwDAnAdrQ=;
	b=1XmyJbJXF/xLUfgIIN5dBu0blfiRYh29Vteq59c9dcjAyEagtePuSlVQYgpWg43l+RrF
	 IVs4EIJryUUq2T7jK+fp5ZyLB5KKE+KRY71F/tpwzYKN1/z9JscCSqnI1Nhst2ig3Wi+6
	 twTzfpuyqs5rm45YvMnDwK+ukSl/eNQpAPA5wNC3SVKqe173dWYDQRh1BuErRLYeWOs6j
	 qwKBqdXgYmp9amdXlHqwgB0RJSMJl4Oklmi1zofk6qs6NuKdmyRxgny0EdIDIzNb2TsPz
	 mCpYBe2/UAs6+uCfK8TcFKQ15fwjylKw0se5Uyqw362wz/7W8rVkyGizwqeGVyQu6KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=apC5aB4M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5836070400;
	Wed,  4 Nov 2026 21:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=apC5aB4M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F591F000C1;
	Wed,  4 Nov 2026 21:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828870;
	bh=Wod6Tmlgd1E4duJTtL807UQ7n4lVqJnBKBEwDAnAdrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=apC5aB4MeyddbEcPoZ4OhmDssawNrBX+vq8+k/RI3RdRZ/5RpSga/BZyLNP57Jeii
	 c+RyAvEEo0Ht+h4vXgvNufzzFusqcBKkFSSLLQXJcwCi87umN5ljeHaUV0FfrnFxCj
	 sRaURQjwIY6xF4yQ1rYGQuG938ub6ihaky7Pq8+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Disha Goel <disgoel@linux.ibm.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 292/547] ovl: fix mount setup failing when override_creds drops CAP_SYS_ADMIN
Date: Wed,  4 Nov 2026 16:07:56 -0500
Message-ID: <20261104211046.500381911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 333ad304d4794d6384087ea7fc16e58ab642809b upstream.

When a process drops CAP_SYS_ADMIN and calls fsconfig(FSCONFIG_SET_FLAG,
"override_creds"), overlayfs saves those restricted credentials in
ofs->creator_cred. ovl_fill_super() then wraps the entire mount setup in
with_ovl_creds(), switching to those restricted credentials for the
duration.

Mount setup calls clone_private_mount(), which checks CAP_SYS_ADMIN
against current credentials. With restricted credentials active, this
check fails with -EPERM even though the task issuing
FSCONFIG_CMD_CREATE is fully privileged.

Use the mounter's real credentials only for cloning the private layer
mounts. Keep all other backing filesystem operations during mount setup
under the stashed credentials.

Reported-by: Disha Goel <disgoel@linux.ibm.com>
Closes: https://lore.kernel.org/linux-unionfs/20260924112858.51392-1-disgoel@linux.ibm.com
Fixes: c28f922c9dcee ("clone_private_mnt(): make sure that caller has CAP_SYS_ADMIN in the right userns")
Cc: stable@vger.kernel.org
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/super.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -497,6 +497,20 @@ static int ovl_report_in_use(struct ovl_
 	}
 }
 
+/*
+ * clone_private_mount() checks CAP_SYS_ADMIN in current->cred.
+ * ovl_fill_super_creds() runs under the stashed creator cred, which
+ * override_creds may have dropped.
+ * The task that issued FSCONFIG_CMD_CREATE is still current->real_cred, so
+ * use that only for the clone. creator_cred stays in effect for every other
+ * backing-fs operation.
+ */
+static struct vfsmount *ovl_clone_private_mount(const struct path *path)
+{
+	scoped_with_creds(current_real_cred())
+		return clone_private_mount(path);
+}
+
 static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
 			 struct ovl_layer *upper_layer,
 			 const struct path *upperpath)
@@ -520,7 +534,7 @@ static int ovl_get_upper(struct super_bl
 	if (err)
 		goto out;
 
-	upper_mnt = clone_private_mount(upperpath);
+	upper_mnt = ovl_clone_private_mount(upperpath);
 	err = PTR_ERR(upper_mnt);
 	if (IS_ERR(upper_mnt)) {
 		pr_err("failed to clone upperpath\n");
@@ -1098,7 +1112,7 @@ static int ovl_get_layers(struct super_b
 			}
 		}
 
-		mnt = clone_private_mount(&l->path);
+		mnt = ovl_clone_private_mount(&l->path);
 		err = PTR_ERR(mnt);
 		if (IS_ERR(mnt)) {
 			pr_err("failed to clone lowerpath\n");


