Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038304;
	b=Otp5PF+Go1p+/yeiNuYvM2iDxBhxCE8dAJ/gNgTIIRxiBygIevtLWqa05QMSEpLJWeGZ
	 RCgD4T4CzFUdDMg25jBRS+Q1dRW3fDCn0hRIBnQyP28A0K8utjqq0qZNtwir/N2fPavUy
	 sxAXPPKfvC/Ama+xEsr6yHnpq73epvdVCFcFJnh6I//UG2aQBY/UWZhQDbSS4SsK3BqGm
	 nMWliK0chPv1gc6GuLpHT5L/ssKZoupA0goagkSOaW0qHWPcnztsfleYSpo3THiVe4Yw9
	 XZmHkmZyB3MkPbcGGnSupDEMBUKoOmVV5OWZQsjo2BH1X0MQsLOZe5fqMP5DzrLyV7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uaClj4WTT2dTNqyJGtiUIfx5LQc5OgnTofMT4Tp8mAg=;
	b=vuXikT0NPl3AaTzYM4VdAO9wRm/iAF6zmDgAbCQsnVPqDD+7+HCQqTuLPhaVuhLQTO2C
	 KW9H8kw2OGUp8fc9JN5uqBfunV46HBSTV7WqGu/v9+KYcL+1ZTkjNQOVhyg9XOexRa569
	 qgTMWFP+RazNZ96rTbYF/DTAvw1gDEe5zKBmfCpsD8hqqFQSgVRp8wHAZIqgHr6890jA/
	 n3uN6+0Q5w/lsW6GYlg8uIl+ArM2RTg2jhnow4Q69/BRsyy6Fg4PaXVo/IuFWwWiBLDje
	 lJCf0JpLkT9krB40/eXaf0fG8UTyyKFB4PFvRfcS3b28Oagu0xkuA7OGkG/BpXYdbLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2TJg0vwo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4031C606A32F;
	Wed, 18 Nov 2026 21:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2TJg0vwo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DD71F000C4;
	Wed, 18 Nov 2026 21:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038304;
	bh=uaClj4WTT2dTNqyJGtiUIfx5LQc5OgnTofMT4Tp8mAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2TJg0vwob2fIUGflhfln+MJnQjTwsolvJOk8qs6j7dlWw0SJZIrTxMaWW0og9s59N
	 lanv5Oxv6z0JYnON1ariwjioH7SVaT8sHPH72IQbKLdusatY9+dHSuskf7Td6P3NjE
	 twpLSubDRQcea2wO9ITerBa/fOgr3wmRlWLZmYXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1655/3318] ALSA: compress_offload: Use automatic cleanup of kfree()
Date: Wed, 18 Nov 2026 15:37:57 +0100
Message-ID: <20261118150411.423638682@linuxfoundation.org>
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

[ Upstream commit 9b02221422a55e834469fdc91dc4d5147f5a1fb9 ]

There are common patterns where a temporary buffer is allocated and
freed at the exit, and those can be simplified with the recent cleanup
mechanism via __free(kfree).

A caveat is that some allocations are memdup_user() and they return an
error pointer instead of NULL.  Those need special cares and the value
has to be cleared with no_free_ptr() at the allocation error path.

Other than that, the conversions are straightforward.

No functional changes, only code refactoring.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240222111509.28390-4-tiwai@suse.de
Stable-dep-of: 82da1acad6fd ("ALSA: compress: reject buffer geometry change on gapless next_track")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 36 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 3c259b9419598..511087456568d 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -458,7 +458,7 @@ static int
 snd_compr_get_codec_caps(struct snd_compr_stream *stream, unsigned long arg)
 {
 	int retval;
-	struct snd_compr_codec_caps *caps;
+	struct snd_compr_codec_caps *caps __free(kfree) = NULL;
 
 	if (!stream->ops->get_codec_caps)
 		return -ENXIO;
@@ -469,12 +469,9 @@ snd_compr_get_codec_caps(struct snd_compr_stream *stream, unsigned long arg)
 
 	retval = stream->ops->get_codec_caps(stream, caps);
 	if (retval)
-		goto out;
+		return retval;
 	if (copy_to_user((void __user *)arg, caps, sizeof(*caps)))
-		retval = -EFAULT;
-
-out:
-	kfree(caps);
+		return -EFAULT;
 	return retval;
 }
 #endif /* !COMPR_CODEC_CAPS_OVERFLOW */
@@ -579,7 +576,7 @@ static int snd_compress_check_input(struct snd_compr_params *params)
 static int
 snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
 {
-	struct snd_compr_params *params;
+	struct snd_compr_params *params __free(kfree) = NULL;
 	int retval;
 
 	if (stream->runtime->state == SNDRV_PCM_STATE_OPEN || stream->next_track) {
@@ -589,24 +586,22 @@ snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
 		 */
 		params = memdup_user((void __user *)arg, sizeof(*params));
 		if (IS_ERR(params))
-			return PTR_ERR(params);
+			return PTR_ERR(no_free_ptr(params));
 
 		retval = snd_compress_check_input(params);
 		if (retval)
-			goto out;
+			return retval;
 
 		retval = snd_compr_allocate_buffer(stream, params);
-		if (retval) {
-			retval = -ENOMEM;
-			goto out;
-		}
+		if (retval)
+			return -ENOMEM;
 
 		retval = stream->ops->set_params(stream, params);
 		if (retval)
-			goto out;
+			return retval;
 
 		if (stream->next_track)
-			goto out;
+			return retval;
 
 		stream->metadata_set = false;
 		stream->next_track = false;
@@ -615,15 +610,13 @@ snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
 	} else {
 		return -EPERM;
 	}
-out:
-	kfree(params);
 	return retval;
 }
 
 static int
 snd_compr_get_params(struct snd_compr_stream *stream, unsigned long arg)
 {
-	struct snd_codec *params;
+	struct snd_codec *params __free(kfree) = NULL;
 	int retval;
 
 	if (!stream->ops->get_params)
@@ -634,12 +627,9 @@ snd_compr_get_params(struct snd_compr_stream *stream, unsigned long arg)
 		return -ENOMEM;
 	retval = stream->ops->get_params(stream, params);
 	if (retval)
-		goto out;
+		return retval;
 	if (copy_to_user((char __user *)arg, params, sizeof(*params)))
-		retval = -EFAULT;
-
-out:
-	kfree(params);
+		return -EFAULT;
 	return retval;
 }
 
-- 
2.53.0



