Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6184E36E9;
	Wed, 30 Sep 2026 16:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784406; cv=none; b=e+s/nKgIVcleaBeqRNqAsnOaFJxum2FF64qPR+VE10o4HOnzqbz0vs4aKLV+BOFICqZ9ALIM/X9V0oUMz8V2lNhi3P95V/cYv4VBjjqgYT8TEqDS5r15kHG1FPX33XmTcI4SCgyCCJLzX1ZQc4DJKFI1A8QBFxmZMMrzZ06IXaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784406; c=relaxed/simple;
	bh=ic2aCKEWFbXy+epCotNHmNK3LX0A/rh4W6VWL5gPm3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rFar+WzRO5Lzil/62Weg+wsSMgiL6/RLGxNbu+1EMSSYbai9qNmyxOQzn+bWrYlC12mJ+ZL0T8PlEm/Ak8YJHOqqBI7L16qQXKtW+QRTpkvtkztqKZrE/hoJMioHWzqmr7eHGANO9rEEMHXz+8Y1lLkG9D3Cc4H2CJWHTHRkda8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NczX7gEP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NczX7gEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552881F000FF;
	Wed, 30 Sep 2026 16:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784402;
	bh=HO49T18aPSJVTQibL723JpE3QHi3aJEnzg3SbQIf74w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NczX7gEPYXKkU0eXrqyxGrC6mx/ZOLZKX4oqTF/Sf09wnYaajicvB0nDZGY+4oOMn
	 UBZ2tON1sPapAlHgdYKtBaagwwmP/hMBN4gAxL1JUBHaVjpSm1hw24Fw2RPg4GstGN
	 /xVsu+u5QQnMrq/2rNleyLjRMETvhIBRQLZDySWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/982] ALSA: seq: oss: Reject reads that cannot fit the next event
Date: Wed, 30 Sep 2026 17:14:39 +0200
Message-ID: <20260930152419.890052178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



