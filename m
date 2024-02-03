Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28425F9EB;
	Sat,  3 Feb 2024 04:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933611; cv=none; b=iaXCuD99ik8PhDVEXh6iOOkWC/sWcpIy+kgILb2WYT0+1o5u5p4pLgpHrCD0LtnAcQgJp1rOGEYgdsHS8guCXHLZdihMrVpiE7TONNNRsXtcCwrOs89CY83IXNUFJe6RUyWaH4Kio2KwOwPbKGnhmIrj5XkD8Ox0Y41DJ0kSDnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933611; c=relaxed/simple;
	bh=KR0Ae327LXHsILFPVoxvLAkRDRy/QNw7JRpaZ9ofnTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOZXnL62lpCworDJnxgyssbhK40bj4gUACs4bdiiUPWsPNLk+uz48EgLfbGmXAiinY9Z5qj4E2fe6/eRJFYqCEt1EeoE68+R6ik2sSNkbk1k8KKIDQ6/e6bY0ieZc6pXOcQlT2U/wxX0S1nu2bvnUfqpqpeA2n1UPtQcRAr2Z/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQT+Xbbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQT+Xbbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40DCC43390;
	Sat,  3 Feb 2024 04:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933611;
	bh=KR0Ae327LXHsILFPVoxvLAkRDRy/QNw7JRpaZ9ofnTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQT+XbbdKTyU0xRE0rfFX5H0N+VQ5vfpJOkXyagT2SqrSUBvq3uCTkOykpc106mVw
	 q1m7tbiDT0ppRS8ktixlQB3nPGxcOzed35P96I3kztzZbYT4u3wS8RTMywLachmc4w
	 +bkjs0kZPlX75YBXZvl0nwxfCGAI0ajjtUZwWPqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/322] ALSA: hda: Refer to correct stream index at loops
Date: Fri,  2 Feb 2024 20:04:15 -0800
Message-ID: <20240203035404.328588156@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 214a0680524b..fe0958f9969c 100644
--- a/sound/hda/hdac_stream.c
+++ b/sound/hda/hdac_stream.c
@@ -660,17 +660,15 @@ void snd_hdac_stream_timecounter_init(struct hdac_stream *azx_dev,
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
@@ -715,14 +713,13 @@ void snd_hdac_stream_sync(struct hdac_stream *azx_dev, bool start,
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



