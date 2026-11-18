Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049705;
	b=gCT1881Bf+iNZLBJBRkkNwXqeW4K6/d5Dwl+3W1UTGqoViA2B1rFWZe3LgE6T8Lq13bM
	 aSqa3lQQAv8FZY+uGxZfwFQzJ4088Tk8U/4Sym4I3h617BJ2s+14ksd2lvORyW3roGQ+q
	 piIqNyMW7W1S4ehr6VP3Z7Yk2ySU+j+LGJLNjCF4ZppgWSqVdBhIEo4uedo5K+qEeXwFt
	 DTyO0rcQd1UWoC78hc+XA7UdGqabbXaez0F55GuXB2T3HLg1XK+d/zave4EEMxmZ4LG5O
	 zy8zxvk8ivTjPX/07wuGzVqBOw/ZUqIM5JV83dyffiKres3TVKFrjiP4n32KIo6FqWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K1U6D9bSubYamA8W6f+UyuWKA5ULUNGlopb76o9jFZ4=;
	b=YIFD6kVjWNz1IuNx/UvI3Wdu90XmOo05m2zbJ4o/KBv6pInu4yp9El0mJhUnYGyWW/aP
	 GWscT7wszb12mZ/IdPxopzi5NH15YuNVBd/fqdfY865HHBnUWowQt5FR1xs8+l7agZJ+m
	 T/xgYvLsaDWatg3MEtBOmy1B4D+uPyPOWPk/qUL8jfYpV1MbxpddStOJhUQlSFAAfoqsK
	 z7+XEAlsXIAQcTLY+jZu46J4HSn9mSt5eRcGgJ8KvbgWlZF6SSYZs3s8U+sIx75TnOB3D
	 WiFavjMteaMxKOJ8I9My05VfzckNKfucrxo8hF0RDj08TdJQqi06ujTpgWCyluKBnsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ci0aVOfV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D99C606A325;
	Thu, 19 Nov 2026 00:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ci0aVOfV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8A91F000C4;
	Thu, 19 Nov 2026 00:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049705;
	bh=K1U6D9bSubYamA8W6f+UyuWKA5ULUNGlopb76o9jFZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ci0aVOfVdKmpBHRd1yHX2gkuFZgaFj47xx4wtjANTsLhkD74VCzl75nOimFD150pC
	 vFPjSvn6jYtayiWPiuyDcTXKL7+Pby9c7HEv4Nf1+8lqu402c37WEumYurFv8ScEbd
	 2dKe2KrvnRHhPu9RPHm81MTmC0CTtt+ybTOvLiJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2445/2857] ASoC: intel: atom: Fix .shutdown() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:59 +0100
Message-ID: <20261118150329.601936841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit e3bb575811042ca30ac9b7b4dacc74aab8efa512 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from sst_media_open(). ASoC only marks the DAI as started when
.startup() returns 0, so .shutdown() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 4889a8a73f65 ("ASoC: intel: atom: Use __free(kfree) for stream pointer")
Fixes: 6cc0f4e63994 ("ASoC: Intel: mfld_pcm: move stream handling to dai_ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-20-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/atom/sst-mfld-platform-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
index 9e8af69a438f3..f0118e857dcfc 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -355,7 +355,7 @@ static int sst_media_open(struct snd_pcm_substream *substream,
 
 	stream = NULL;
 
-	return ret_val;
+	return 0;
 }
 
 static void sst_media_close(struct snd_pcm_substream *substream,
-- 
2.53.0



