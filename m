Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277013DE443;
	Mon,  4 May 2026 14:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904476; cv=none; b=MvVrbFWlyBoFSmfY2oLcO+uc3TNgjDyGF/DgBa0A+GkIAQs/fmY364M+6RLelO1mvmbAJGjEVVNE74wBlnVRfKSgc9LPFJgRRdmdsf1BRKAfoHzC0gwLQf1+jlQZkA7oMmmPYn9dS+ttER86wG1J4JWw5J8eusa5Y2xFQAU2fjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904476; c=relaxed/simple;
	bh=ETq3TBjWsmH6GV43qsf2yUmWj5FpEPoYLTTk0T7Ruoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jUBzEY61dYFOzvbz69eXT9ZwT9IyBTqBGUl2aKzvfCMAVElffZIfp0pnnA+8jTS6qdvXvxJU4i2fRjl66aVKVjVut/NxowZ4PbPTtwolvWMaz+hXqR3UlxghyKX+YMirJvroXKaiaq1UzlIEoyPwNroM/73TAzuntCqTIVqKP2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSNGIPdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSNGIPdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F07C2BCB8;
	Mon,  4 May 2026 14:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904476;
	bh=ETq3TBjWsmH6GV43qsf2yUmWj5FpEPoYLTTk0T7Ruoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSNGIPdlnY9VhvrA4/N7NPgDl8NlGgp1MA9DmQYKYORuQyjdMz8zMOntnpzSjj90C
	 5Q+WAtK3ZfuLzoeBiA0WaLtRmvjgLczTfhvknYxUvaa1bmRvLWzMQowDD2rQInr7EN
	 DDNq9a7zyezZ3xuAwjbZfzzhrZJneFkRji4x8VR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 053/215] ALSA: aoa: i2sbus: fix OF node lifetime handling
Date: Mon,  4 May 2026 15:51:12 +0200
Message-ID: <20260504135132.113852025@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 4ec93f070eda6b765b62efcaed9241c3b3b0b6ad upstream.

i2sbus_add_dev() keeps the matched "sound" child pointer after
for_each_child_of_node() has dropped the iterator reference. Take an
extra reference before saving that node and drop it after the
layout-id/device-id lookup is complete.

The function also stores np in dev->sound.ofdev.dev.of_node without
taking a reference for the embedded soundbus device. Since i2sbus
overrides the embedded platform device release callback, balance that
reference explicitly in the local error path and in i2sbus_release_dev().

Fixes: f3d9478b2ce4 ("[ALSA] snd-aoa: add snd-aoa")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260330-aoa-i2sbus-ofnode-lifetime-v1-1-51c309f4ff06@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/aoa/soundbus/i2sbus/core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -84,6 +84,7 @@ static void i2sbus_release_dev(struct de
 	for (i = aoa_resource_i2smmio; i <= aoa_resource_rxdbdma; i++)
 		free_irq(i2sdev->interrupts[i], i2sdev);
 	i2sbus_control_remove_dev(i2sdev->control, i2sdev);
+	of_node_put(i2sdev->sound.ofdev.dev.of_node);
 	mutex_destroy(&i2sdev->lock);
 	kfree(i2sdev);
 }
@@ -149,7 +150,6 @@ static int i2sbus_get_and_fixup_rsrc(str
 }
 
 /* Returns 1 if added, 0 for otherwise; don't return a negative value! */
-/* FIXME: look at device node refcounting */
 static int i2sbus_add_dev(struct macio_dev *macio,
 			  struct i2sbus_control *control,
 			  struct device_node *np)
@@ -180,8 +180,9 @@ static int i2sbus_add_dev(struct macio_d
 	i = 0;
 	for_each_child_of_node(np, child) {
 		if (of_node_name_eq(child, "sound")) {
+			of_node_put(sound);
 			i++;
-			sound = child;
+			sound = of_node_get(child);
 		}
 	}
 	if (i == 1) {
@@ -207,6 +208,7 @@ static int i2sbus_add_dev(struct macio_d
 			}
 		}
 	}
+	of_node_put(sound);
 	/* for the time being, until we can handle non-layout-id
 	 * things in some fabric, refuse to attach if there is no
 	 * layout-id property or we haven't been forced to attach.
@@ -221,7 +223,7 @@ static int i2sbus_add_dev(struct macio_d
 	mutex_init(&dev->lock);
 	spin_lock_init(&dev->low_lock);
 	dev->sound.ofdev.archdata.dma_mask = macio->ofdev.archdata.dma_mask;
-	dev->sound.ofdev.dev.of_node = np;
+	dev->sound.ofdev.dev.of_node = of_node_get(np);
 	dev->sound.ofdev.dev.dma_mask = &dev->sound.ofdev.archdata.dma_mask;
 	dev->sound.ofdev.dev.parent = &macio->ofdev.dev;
 	dev->sound.ofdev.dev.release = i2sbus_release_dev;
@@ -329,6 +331,7 @@ static int i2sbus_add_dev(struct macio_d
 	for (i=0;i<3;i++)
 		release_and_free_resource(dev->allocated_resource[i]);
 	mutex_destroy(&dev->lock);
+	of_node_put(dev->sound.ofdev.dev.of_node);
 	kfree(dev);
 	return 0;
 }


