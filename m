Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABECD28850C;
	Wed, 25 Feb 2026 01:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983933; cv=none; b=EZKgwZIdLQYRc2AxotF0PF47fMQ/ANYrolQTckJmTasir5vY6bS1dQ7GI0LXQOu9EKlAcI88cUu0e0zyNutAEvBDueiiMXaOp4rV1QjSBzugcHsSf1QgXdKmPYt7j9BIu87HOwAuv6n1uReIupueHOOzJF2nvyOwvP0cNDWVEK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983933; c=relaxed/simple;
	bh=3V3t9b0eMa55ZyFXhdp7Smey5xFofuCj9Oh9IlX1zf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqnfXtPA4r1l0h8ksbbKSA7mKqToyuzbwLFWNDsQMrmhC9prJ+9N10k7ZNWI2s84IkakppbqPQfDF5szh4ylhRFdXzPin8pgwIPW95sUn/yhCi4nhJw0kPBWWnm/fABvRgQPcHnODRrrOXBqqgeZWFPa6RV8vwm5DCj0SlrJ59A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fK2WzVmU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fK2WzVmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823C6C116D0;
	Wed, 25 Feb 2026 01:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983933;
	bh=3V3t9b0eMa55ZyFXhdp7Smey5xFofuCj9Oh9IlX1zf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fK2WzVmUpqRXhHupTnGJoXtXZ1zk9AarEF41HpM5wU1cIu463vLFDcotuxcQQ5yxI
	 ct1U9GJdUa/8+LULCIa6hFRFa+xwsH7R5ocU9felOnkvGvVD36DxtcLhix7QwC+uKv
	 +MKrKhJ7F2UvtnBu+WrYkBNk6YwDOA2LSSfJtBHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 181/641] ALSA: vmaster: Relax __free() variable declarations
Date: Tue, 24 Feb 2026 17:18:27 -0800
Message-ID: <20260225012353.411426280@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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



