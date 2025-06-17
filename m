Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F75CA4B;
	Tue, 17 Jun 2025 16:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179379; cv=none; b=l51eQivwL54nV82bxvvKAV/WzZW+VLE1KHBUhT1jfg+juHsWVbSxFuCu67xMBtrDOUPreAJZIp1zT1HHDrpUyiAP9rEwGs/B15GsexDacw87jbWrzk/Zfo+BbxP4T7tSNchB5j12j/J3mb5IlBcT00PUZEc7JoGvGdG04T06agA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179379; c=relaxed/simple;
	bh=09NFfwhfTmnmfXYAjSSDXtP/jjG2vrY6EdNGNRRhqvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxUq5Qkm3daGllHC286ygbdPEQ55sp6+W7dpAMKszptt1hpiI5r0lD0WUgTVMwpTPWjTuOwFWx7Y6WGnI66vz04glCZGBZZKuT8/CqyUHgo4FAm1C7iWgRcHzl15OmvWxSIgGaA0+XLWZ7SyHeg44N2UkV/QPLX/IIVrA5Mge7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djVJETxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djVJETxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740E1C4CEE3;
	Tue, 17 Jun 2025 16:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179377;
	bh=09NFfwhfTmnmfXYAjSSDXtP/jjG2vrY6EdNGNRRhqvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djVJETxSOBHtsEOtzdC5GpooVNrPZSJNFvtfn0F+WQBRASwRlS6ry7gjK2KqD6DR3
	 HIXMWBYApPW0OtdMi86aV7zEPe6qnR2kJqC4nuBnZtvVe57LgJPn8ZJ1VzqXhlKz5w
	 4eydEv7Tk9dOWMbcQTI3OdSMOVU18/LzKFgXxTs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 727/780] gfs2: pass through holder from the VFS for freeze/thaw
Date: Tue, 17 Jun 2025 17:27:15 +0200
Message-ID: <20250617152521.097934531@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 62a2175ddf7e72941868f164b7c1f92e00f213bd ]

The filesystem's freeze/thaw functions can be called from contexts where
the holder isn't userspace but the kernel, e.g., during systemd
suspend/hibernate. So pass through the freeze/thaw flags from the VFS
instead of hard-coding them.

Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 54f1efd47a3e5..0bd7827e6371e 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -674,7 +674,7 @@ static int gfs2_sync_fs(struct super_block *sb, int wait)
 	return sdp->sd_log_error;
 }
 
-static int gfs2_do_thaw(struct gfs2_sbd *sdp)
+static int gfs2_do_thaw(struct gfs2_sbd *sdp, enum freeze_holder who)
 {
 	struct super_block *sb = sdp->sd_vfs;
 	int error;
@@ -682,7 +682,7 @@ static int gfs2_do_thaw(struct gfs2_sbd *sdp)
 	error = gfs2_freeze_lock_shared(sdp);
 	if (error)
 		goto fail;
-	error = thaw_super(sb, FREEZE_HOLDER_USERSPACE);
+	error = thaw_super(sb, who);
 	if (!error)
 		return 0;
 
@@ -710,7 +710,7 @@ void gfs2_freeze_func(struct work_struct *work)
 	gfs2_freeze_unlock(sdp);
 	set_bit(SDF_FROZEN, &sdp->sd_flags);
 
-	error = gfs2_do_thaw(sdp);
+	error = gfs2_do_thaw(sdp, FREEZE_HOLDER_USERSPACE);
 	if (error)
 		goto out;
 
@@ -728,6 +728,7 @@ void gfs2_freeze_func(struct work_struct *work)
 /**
  * gfs2_freeze_super - prevent further writes to the filesystem
  * @sb: the VFS structure for the filesystem
+ * @who: freeze flags
  *
  */
 
@@ -744,7 +745,7 @@ static int gfs2_freeze_super(struct super_block *sb, enum freeze_holder who)
 	}
 
 	for (;;) {
-		error = freeze_super(sb, FREEZE_HOLDER_USERSPACE);
+		error = freeze_super(sb, who);
 		if (error) {
 			fs_info(sdp, "GFS2: couldn't freeze filesystem: %d\n",
 				error);
@@ -758,7 +759,7 @@ static int gfs2_freeze_super(struct super_block *sb, enum freeze_holder who)
 			break;
 		}
 
-		error = gfs2_do_thaw(sdp);
+		error = gfs2_do_thaw(sdp, who);
 		if (error)
 			goto out;
 
@@ -796,6 +797,7 @@ static int gfs2_freeze_fs(struct super_block *sb)
 /**
  * gfs2_thaw_super - reallow writes to the filesystem
  * @sb: the VFS structure for the filesystem
+ * @who: freeze flags
  *
  */
 
@@ -814,7 +816,7 @@ static int gfs2_thaw_super(struct super_block *sb, enum freeze_holder who)
 	atomic_inc(&sb->s_active);
 	gfs2_freeze_unlock(sdp);
 
-	error = gfs2_do_thaw(sdp);
+	error = gfs2_do_thaw(sdp, who);
 
 	if (!error) {
 		clear_bit(SDF_FREEZE_INITIATOR, &sdp->sd_flags);
-- 
2.39.5



