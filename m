Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5ADFC11;
	Sat,  3 Feb 2024 04:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933390; cv=none; b=b8819/e2qYeUwUVXa3cHMPpjEG38KWAmxaYm9qGPS+2IMrhpgVDTMXTGUNL2JiXEvUjmmr3pGhsx4GW2Ccp53POg3n7iBT9ELUZzOc7Tq7NQSuNqsFK0cRwQaZIDgQArEZQrZwvuJ+HC+MMBGiM08yrALAlHzY2KsMxhRplEFiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933390; c=relaxed/simple;
	bh=aVwnS3VuyjdFl8esDgPvGkdEcfPonjs5Cs7V222KLas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USEulTiA2QeB/v4OBwRelrEftroWSpnr39Ujwuien/beRq81UpzYepih66iSSXrP8UqsfwI1NXJwMN7yXJ85sHjKxOvmkGrMuBL4AEkeK1VNX5ppe+gPiWOjijvEdRJaWmz6fz/r7WL+h5SvzwLcjEc3GovxaILZZXj2E5x1FcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zphSN89/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zphSN89/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897B8C43394;
	Sat,  3 Feb 2024 04:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933390;
	bh=aVwnS3VuyjdFl8esDgPvGkdEcfPonjs5Cs7V222KLas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zphSN89//l9+Dzl+rJJhXj/uYemvCOwn1tU89A08iOOuzhcpeU9BdpR/3HQNCFc4A
	 4wYk9pkoVN5toqSh237+FQx/RiV2aM5rkyzpospmV9oMUKdI1GoupzpoBg8X+1Jpv/
	 7EZjRd2cZq/A+R8n82DRCuySM0nS7gK9l7h6pxCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/219] ALSA: hda: Refer to correct stream index at loops
Date: Fri,  2 Feb 2024 20:04:38 -0800
Message-ID: <20240203035332.202859929@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 26257869672fd4a06a60c2da841e15fb2cb47bbe ]

In a couple of loops over the all streams, we check the bitmap against
the loop counter.  A more correct reference would be, however, the
index of each stream, instead.

This patch corrects the check of bitmaps to the stream index.

Note that this change doesn't fix anything for now; all existing
drivers set up the stream indices properly, hence the loop count is
always equal with the stream index.  That said, this change is only
for consistency.

Link: https://lore.kernel.org/r/20231121154125.4888-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdac_stream.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/sound/hda/hdac_stream.c b/sound/hda/hdac_stream.c
index 741a5d17ae4c..ecd3aec57c87 100644
--- a/sound/hda/hdac_stream.c
+++ b/sound/hda/hdac_stream.c
@@ -629,17 +629,15 @@ void snd_hdac_stream_timecounter_init(struct hdac_stream *azx_dev,
 	struct hdac_stream *s;
 	bool inited = false;
 	u64 cycle_last = 0;
-	int i = 0;
 
 	list_for_each_entry(s, &bus->stream_list, list) {
-		if (streams & (1 << i)) {
+		if ((streams & (1 << s->index))) {
 			azx_timecounter_init(s, inited, cycle_last);
 			if (!inited) {
 				inited = true;
 				cycle_last = s->tc.cycle_last;
 			}
 		}
-		i++;
 	}
 
 	snd_pcm_gettime(runtime, &runtime->trigger_tstamp);
@@ -684,14 +682,13 @@ void snd_hdac_stream_sync(struct hdac_stream *azx_dev, bool start,
 			  unsigned int streams)
 {
 	struct hdac_bus *bus = azx_dev->bus;
-	int i, nwait, timeout;
+	int nwait, timeout;
 	struct hdac_stream *s;
 
 	for (timeout = 5000; timeout; timeout--) {
 		nwait = 0;
-		i = 0;
 		list_for_each_entry(s, &bus->stream_list, list) {
-			if (!(streams & (1 << i++)))
+			if (!(streams & (1 << s->index)))
 				continue;
 
 			if (start) {
-- 
2.43.0



