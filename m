Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CF63451A7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301739; cv=none; b=JHUK4GTfW4wfc/duhLXo1j2jAdyEq0EvLsOfLR8eO+ze4IqANlJhJRqKN5GcNI2QPQBWn21H+5fmsHvyY8Cmic2GRp3mrOipYvlLmefWvHfJXx0iHDH8GoWDLGIZwbIE4FazKe/f6VbRf7M6uIyLTGj3GzVIHD193/xiPxtrrTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301739; c=relaxed/simple;
	bh=uL46H9dio4K1oOzE6bdTzs+f2/y5RdZ616nm1lji634=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTJ/KNXF8p5Ur51xl/qE7yvrxxY+cfEHsJLIVJNqcNcQC1pSKxKRgmasIR5WGA+medL6x0CF06lyeWVPfZ/xusCqndLRCXiUNEo4uQxdp3gE6W5bF/26/ix2bu+TAjidqjBiqcRdFi6Lq6X61m1p5MGhFqBuycwXeH1nyFO5vt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWpwaUYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWpwaUYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00BEC19424;
	Sat, 28 Feb 2026 18:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301739;
	bh=uL46H9dio4K1oOzE6bdTzs+f2/y5RdZ616nm1lji634=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWpwaUYehDCEQXxt+EVg9R/YmEc6xrTIeFr+F8Gtk0cbDcdspTBMRBeFUfaCZ0rlj
	 MSBAzZuKE/nkfrQkyxqqhzB+5MG5cJao8XW+ZC5ENgblEcnl+9c47sRBgrbYQjbayy
	 I81qpgE5O1pSleJtwC6JZ8C/g2cd5+AfFWzBfXX+HHS6Kkh3thL2ySbSOWE0Qqbtq6
	 OILVriju2HUInE+0F6x8sRZGuu5QZ/vYDzOrwAk7SE3n/tzjF4GpDNIXXwoBrO1iLn
	 oTlINwXEmi1i8Z0yrI0cSmIhZoyYG7d1xLK68edH2vDpBGoQxIed+eYMyHWiISdPFW
	 2OOoID05hp3uA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 140/385] ALSA: vmaster: Relax __free() variable declarations
Date: Sat, 28 Feb 2026 12:56:02 -0500
Message-ID: <20260228180011.1568201-140-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 3b7c7bda39e1e48f926fb3d280a5f5d20a939857 ]

We used to have a variable declaration with __free() initialized with
NULL.  This was to keep the old coding style rule, but recently it's
relaxed and rather recommends to follow the new rule to declare in
place of use for __free() -- which avoids potential deadlocks or UAFs
with nested cleanups.

Although the current code has no bug, per se, let's follow the new
standard and move the declaration to the place of assignment (or
directly assign the allocated result) instead of NULL initializations.

Fixes: fb9e197f3f27 ("ALSA: vmaster: Use automatic cleanup of kfree()")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251216140634.171890-9-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/vmaster.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/core/vmaster.c b/sound/core/vmaster.c
index c657659b236c4..76cc64245f5df 100644
--- a/sound/core/vmaster.c
+++ b/sound/core/vmaster.c
@@ -56,10 +56,10 @@ struct link_follower {
 
 static int follower_update(struct link_follower *follower)
 {
-	struct snd_ctl_elem_value *uctl __free(kfree) = NULL;
 	int err, ch;
+	struct snd_ctl_elem_value *uctl __free(kfree) =
+		kzalloc(sizeof(*uctl), GFP_KERNEL);
 
-	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
 	if (!uctl)
 		return -ENOMEM;
 	uctl->id = follower->follower.id;
@@ -74,7 +74,6 @@ static int follower_update(struct link_follower *follower)
 /* get the follower ctl info and save the initial values */
 static int follower_init(struct link_follower *follower)
 {
-	struct snd_ctl_elem_info *uinfo __free(kfree) = NULL;
 	int err;
 
 	if (follower->info.count) {
@@ -84,7 +83,8 @@ static int follower_init(struct link_follower *follower)
 		return 0;
 	}
 
-	uinfo = kmalloc(sizeof(*uinfo), GFP_KERNEL);
+	struct snd_ctl_elem_info *uinfo __free(kfree) =
+		kmalloc(sizeof(*uinfo), GFP_KERNEL);
 	if (!uinfo)
 		return -ENOMEM;
 	uinfo->id = follower->follower.id;
@@ -341,9 +341,9 @@ static int master_get(struct snd_kcontrol *kcontrol,
 static int sync_followers(struct link_master *master, int old_val, int new_val)
 {
 	struct link_follower *follower;
-	struct snd_ctl_elem_value *uval __free(kfree) = NULL;
+	struct snd_ctl_elem_value *uval __free(kfree) =
+		kmalloc(sizeof(*uval), GFP_KERNEL);
 
-	uval = kmalloc(sizeof(*uval), GFP_KERNEL);
 	if (!uval)
 		return -ENOMEM;
 	list_for_each_entry(follower, &master->followers, list) {
-- 
2.51.0

