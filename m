Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C1A305678;
	Fri, 15 May 2026 15:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860691; cv=none; b=ETnBwDJS8A9GNO+vzRH6PZ4IM1bF+smjey2haIWdEpXjvXqUCn7cPdlQPUliTq2xXK7rrnJv7sGFQ4LhGjTBlbKbCLQJFF8Moi391Yhcg435P9vqrhfBAA/n+kd5Gn4OH7OWcdKCc/nrccyNfPh9bCKZ0MEt30EQHJEKxiVyVRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860691; c=relaxed/simple;
	bh=eO4AWkESb7YLmfWbxzBp9++vlicpH2Guo8h0JjFT7pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lIfLjTFTEFupfwazP3tnfd6NJG/i6m6/xTf7b0ajpU9nl/YOwUoJE36dz5TjqqvBHHu6M1wknLNhS0fzA04vfTXvOvFaV10uFDTEVMJt9bdXh08ZR0g6DZBzgCULhNcGuLIO9kkRubLFohKa4+WKXV7/AJMYMOokxMCp3mm60kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNcFfhFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNcFfhFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D730C2BCB0;
	Fri, 15 May 2026 15:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860691;
	bh=eO4AWkESb7YLmfWbxzBp9++vlicpH2Guo8h0JjFT7pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNcFfhFuCNEGDu6DbpgQTn9r6nXE7/ms2rAPeMmuGn+gM9v6GMxkgW33sx5RFuM40
	 SupNONEQHJTOWfz/HDj9TUrDkhgi7zz5qfIT0+B1f4JsMoImrIXVEzMvCvEkV24G7f
	 fuxv6jnqzYqHhX4IiHbH2QjupQOkKJXOSLcL5vZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 042/474] ALSA: aoa: i2sbus: fix OF node lifetime handling
Date: Fri, 15 May 2026 17:42:31 +0200
Message-ID: <20260515154715.959263070@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -83,6 +83,7 @@ static void i2sbus_release_dev(struct de
 	for (i = aoa_resource_i2smmio; i <= aoa_resource_rxdbdma; i++)
 		free_irq(i2sdev->interrupts[i], i2sdev);
 	i2sbus_control_remove_dev(i2sdev->control, i2sdev);
+	of_node_put(i2sdev->sound.ofdev.dev.of_node);
 	mutex_destroy(&i2sdev->lock);
 	kfree(i2sdev);
 }
@@ -148,7 +149,6 @@ static int i2sbus_get_and_fixup_rsrc(str
 }
 
 /* Returns 1 if added, 0 for otherwise; don't return a negative value! */
-/* FIXME: look at device node refcounting */
 static int i2sbus_add_dev(struct macio_dev *macio,
 			  struct i2sbus_control *control,
 			  struct device_node *np)
@@ -179,8 +179,9 @@ static int i2sbus_add_dev(struct macio_d
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
@@ -206,6 +207,7 @@ static int i2sbus_add_dev(struct macio_d
 			}
 		}
 	}
+	of_node_put(sound);
 	/* for the time being, until we can handle non-layout-id
 	 * things in some fabric, refuse to attach if there is no
 	 * layout-id property or we haven't been forced to attach.
@@ -220,7 +222,7 @@ static int i2sbus_add_dev(struct macio_d
 	mutex_init(&dev->lock);
 	spin_lock_init(&dev->low_lock);
 	dev->sound.ofdev.archdata.dma_mask = macio->ofdev.archdata.dma_mask;
-	dev->sound.ofdev.dev.of_node = np;
+	dev->sound.ofdev.dev.of_node = of_node_get(np);
 	dev->sound.ofdev.dev.dma_mask = &dev->sound.ofdev.archdata.dma_mask;
 	dev->sound.ofdev.dev.parent = &macio->ofdev.dev;
 	dev->sound.ofdev.dev.release = i2sbus_release_dev;
@@ -328,6 +330,7 @@ static int i2sbus_add_dev(struct macio_d
 	for (i=0;i<3;i++)
 		release_and_free_resource(dev->allocated_resource[i]);
 	mutex_destroy(&dev->lock);
+	of_node_put(dev->sound.ofdev.dev.of_node);
 	kfree(dev);
 	return 0;
 }


