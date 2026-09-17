Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7AE4ED185;
	Thu, 17 Sep 2026 17:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667906; cv=none; b=rE5075hPB+QKi8FuzSh9+ptUxqM5KoR3OhvcMOEfzDmEVeF8Q6HSI/Ia0GGv1mJxMs0b+3BEr54YIQLCk08ypexWgce9VIJKOKZXNqXyNdlYz6GGFPOcnjNa5EK2SF9rK08sfTFiHmb2qdL/bZn/rTEvdxlkrqYe4sPBmUx2Q80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667906; c=relaxed/simple;
	bh=veV2rt6cdYfNE18TFwTc9PmkuK8pYAtgUCOc4y+jcAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UgoIhC1nXB1cJCSbSz9Co3cihyb36rGduoBNLBOv76Hapj230UVgZOzv1C4kmYfbDC5xPvBQhmak29v0iEMaEMhqSI7ALSYEFZ/+KC0IZOrZtrI0f9iDZF145O0dDHV14Uyf6WdASaGM+wKMDPzkeMVHXNgKcXRnPYvVTwkUwDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Gy3uG+o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Gy3uG+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719551F00898;
	Thu, 17 Sep 2026 17:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667905;
	bh=XcyIJmIwVr6AOZSzyhhoFCSCMA8rxa+781zPRCp8bBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Gy3uG+oL0g7eyMTFcvjM1a4BIPrlxH6KZq05qN0vhbS4jZMQ6oefLYsj4931M8H1
	 dcAjbGbtaKCVExeoP1zRmf5ak0WLRSe5SlFYPYxgi/jp3/ZzSCnj/katFBaMhoT3CV
	 8t/t5CIEBU+KD/n15U86ut5NFpgY4vMbXOMu3PUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0212/1102] ALSA: seq: oss: Reject reads that cannot fit the next event
Date: Thu, 17 Sep 2026 16:02:35 +0100
Message-ID: <20260917151544.899148584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

[ Upstream commit 611f538253d970f4d152003841544e875828d015 ]

snd_seq_oss_read() checks whether the next queued OSS sequencer event
fits in the remaining userspace buffer before removing it from the read
queue.

The check is inverted. It currently stops when the event is smaller than
the remaining buffer, so a normal 4-byte event is not copied for an
8-byte read buffer. Conversely, an 8-byte event can be copied for a
smaller read count.

Break only when the remaining userspace buffer is smaller than the next
event, and report -EINVAL if no complete event has been copied. This
prevents an undersized read from looking like end-of-file while leaving
the event queued for a later read with a large enough buffer.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260602-alsa-seq-oss-read-size-check-v1-1-10e59b1742e0@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/oss/seq_oss_rw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/core/seq/oss/seq_oss_rw.c b/sound/core/seq/oss/seq_oss_rw.c
index 307ef98c44c7b..45bb458597708 100644
--- a/sound/core/seq/oss/seq_oss_rw.c
+++ b/sound/core/seq/oss/seq_oss_rw.c
@@ -57,7 +57,8 @@ snd_seq_oss_read(struct seq_oss_devinfo *dp, char __user *buf, int count)
 			break;
 		}
 		ev_len = ev_length(&rec);
-		if (ev_len < count) {
+		if (count < ev_len) {
+			err = -EINVAL;
 			snd_seq_oss_readq_unlock(readq, flags);
 			break;
 		}
-- 
2.53.0



