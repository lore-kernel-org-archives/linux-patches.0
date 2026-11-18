Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041097;
	b=TtqXLbsDtt1cCHKRoTGPSL+9iaZiU4NhPQ348vCcmR4bZMDiqkvc68lWtJ0kqY16rkbx
	 wBEsyeq5cNu0QFjzUV6Kz91fyVuXJJDKb6/B4XND3tPoOXOOhGwpJLBxlCWOVwDiqUgkM
	 5MRQwums1pNcU8eTHoWW93iunFWYcPLTU8SUilQjg1PTUIjl5+rkeb2XxF8HWZj98TpeE
	 pTyWgv84NlGOKHkmO4p2h7FDvLyq41OF0GTdNlDX++HuGEdtVzfhfh3/q5MDChlYnYvBz
	 BHwzAAby5C3Nv1j974p8LTkBKqfcYbqEyfMocpBalbqsVd6AVCKdPw3E1uaXXjdK/zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d7luxYIddxlR7VEZ7eNN1GSnArYnrFdwzfg4Qr02zyI=;
	b=X7By4xms1IIktABeBVi3MMYP18vYgpLiZgRCy1eRYtsgdP9il65yL+ptcxk/OxOuYL9B
	 3Q6bwcPQ44W3EezaVRmYV2a5R8BtWzFl5mF5jZQbhz2mjVooCPwrrCyNjQ1T8mjNrDfwS
	 Gy1JG2p9mftbw/LKv4/72vB2ug3OwwQVl8Rxao3vJROK0Nls2//c7vCayZmRbNgix8H+E
	 wMSFNdB+RQPhlya8TCg78k26w8Gfo7YBcZdH0/F8KYfuYI9LNdBwTR1QZ6dGyffyT5LN3
	 YdwCxoqP8exO11Kp98SI6lMR6wNxIoz6L0HyvPpaeZJk14WQMfuBw4DEQgoLwMoNr5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NfL7LP2o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B543C606A31C;
	Wed, 18 Nov 2026 22:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NfL7LP2o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130491F000C4;
	Wed, 18 Nov 2026 22:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041097;
	bh=d7luxYIddxlR7VEZ7eNN1GSnArYnrFdwzfg4Qr02zyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NfL7LP2oPSl/33DlmYKbqVTa7KqjJ43Xxvv0ekyKkyfStQJcSZET7UigVK6uDLxV1
	 9xLO3j1T9ijWPUxPGRMm2x12aaROAGgDXJ+1iqMnZZPJE27jmSonh537imiLQb0vgK
	 p6hbkLKlPPDo2aL4ob35X0rvSjsIuS2/rAdoMGY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2692/3318] ALSA: seq: core: Use automatic cleanup of kfree()
Date: Wed, 18 Nov 2026 15:55:14 +0100
Message-ID: <20261118150441.708097509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit edbcf872c14690c2894b726b67a871b4d238eea8 ]

There are common patterns where a temporary buffer is allocated and
freed at the exit, and those can be simplified with the recent cleanup
mechanism via __free(kfree).

No functional changes, only code refactoring.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240222111509.28390-10-tiwai@suse.de
Stable-dep-of: 9d3e19c192b9 ("ALSA: seq: Fix missing direction and ump_group handling in 32bit compat ioctl")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_compat.c | 12 +++++-------
 sound/core/seq/seq_midi.c   | 14 +++-----------
 2 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/sound/core/seq/seq_compat.c b/sound/core/seq/seq_compat.c
index e26200fb351e3..ee9bfdf781b12 100644
--- a/sound/core/seq/seq_compat.c
+++ b/sound/core/seq/seq_compat.c
@@ -31,8 +31,8 @@ struct snd_seq_port_info32 {
 static int snd_seq_call_port_info_ioctl(struct snd_seq_client *client, unsigned int cmd,
 					struct snd_seq_port_info32 __user *data32)
 {
-	int err = -EFAULT;
-	struct snd_seq_port_info *data;
+	struct snd_seq_port_info *data __free(kfree) = NULL;
+	int err;
 
 	data = kmalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -41,22 +41,20 @@ static int snd_seq_call_port_info_ioctl(struct snd_seq_client *client, unsigned
 	if (copy_from_user(data, data32, sizeof(*data32)) ||
 	    get_user(data->flags, &data32->flags) ||
 	    get_user(data->time_queue, &data32->time_queue))
-		goto error;
+		return -EFAULT;
 	data->kernel = NULL;
 
 	scoped_guard(mutex, &client->ioctl_mutex) {
 		err = snd_seq_kernel_client_ctl(client->number, cmd, data);
 	}
 	if (err < 0)
-		goto error;
+		return err;
 
 	if (copy_to_user(data32, data, sizeof(*data32)) ||
 	    put_user(data->flags, &data32->flags) ||
 	    put_user(data->time_queue, &data32->time_queue))
-		err = -EFAULT;
+		return -EFAULT;
 
- error:
-	kfree(data);
 	return err;
 }
 
diff --git a/sound/core/seq/seq_midi.c b/sound/core/seq/seq_midi.c
index 2006313dc9255..9af4d4dad6206 100644
--- a/sound/core/seq/seq_midi.c
+++ b/sound/core/seq/seq_midi.c
@@ -320,8 +320,8 @@ snd_seq_midisynth_probe(struct device *_dev)
 	struct snd_seq_device *dev = to_seq_dev(_dev);
 	struct seq_midisynth_client *client;
 	struct seq_midisynth *msynth, *ms;
-	struct snd_seq_port_info *port;
-	struct snd_rawmidi_info *info;
+	struct snd_seq_port_info *port __free(kfree) = NULL;
+	struct snd_rawmidi_info *info __free(kfree) = NULL;
 	struct snd_rawmidi *rmidi = dev->private_data;
 	int newclient = 0;
 	unsigned int p, ports;
@@ -347,10 +347,8 @@ snd_seq_midisynth_probe(struct device *_dev)
 	ports = output_count;
 	if (ports < input_count)
 		ports = input_count;
-	if (ports == 0) {
-		kfree(info);
+	if (ports == 0)
 		return -ENODEV;
-	}
 	if (ports > (256 / SNDRV_RAWMIDI_DEVICES))
 		ports = 256 / SNDRV_RAWMIDI_DEVICES;
 
@@ -361,7 +359,6 @@ snd_seq_midisynth_probe(struct device *_dev)
 		client = kzalloc(sizeof(*client), GFP_KERNEL);
 		if (client == NULL) {
 			mutex_unlock(&register_mutex);
-			kfree(info);
 			return -ENOMEM;
 		}
 		client->seq_client =
@@ -371,7 +368,6 @@ snd_seq_midisynth_probe(struct device *_dev)
 		if (client->seq_client < 0) {
 			kfree(client);
 			mutex_unlock(&register_mutex);
-			kfree(info);
 			return -ENOMEM;
 		}
 	}
@@ -453,8 +449,6 @@ snd_seq_midisynth_probe(struct device *_dev)
 	if (newclient)
 		synths[card->number] = client;
 	mutex_unlock(&register_mutex);
-	kfree(info);
-	kfree(port);
 	return 0;	/* success */
 
       __nomem:
@@ -467,8 +461,6 @@ snd_seq_midisynth_probe(struct device *_dev)
 		snd_seq_delete_kernel_client(client->seq_client);
 		kfree(client);
 	}
-	kfree(info);
-	kfree(port);
 	mutex_unlock(&register_mutex);
 	return -ENOMEM;
 }
-- 
2.53.0



