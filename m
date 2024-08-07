Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698E778C92;
	Wed,  7 Aug 2024 15:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043466; cv=none; b=rnFZr5W1UEHJWomXwLYhE+PGRpjwxkJU3d0jkwWU8j0bfnatNWSbpmnC7i/sWMOlG/hS8mqs5JXPUyEabJiqw63xxWi7iuE+fhK+fPoP7k1UlEy7bcK8XKMczBnAP/KjcOo4FxUGA562Wck/ei23dmqtiDdypwg6m/IYfq9Bnt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043466; c=relaxed/simple;
	bh=BIMMsJNtxxqmGLpesXfEvcsNqnfDFnV23sMUNrTm7BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNaQjxThcqtwiC7GWu6fV5HXL63IEGoL30ZLVdegGlUFwfgFDGhdAII80ysivDYlUYLWGL8R1WezXa1xN1XcdoQgJlyxnZ9Q/8aQx1AC7BqssvLgSgBc1Ogdo/j1Ek4ZFkiN798k+znJrVZ+DcubSXH18jx7J99KAIMZoCUumsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPTYwGni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPTYwGni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA4CC32781;
	Wed,  7 Aug 2024 15:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043466;
	bh=BIMMsJNtxxqmGLpesXfEvcsNqnfDFnV23sMUNrTm7BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPTYwGniCTnWiBQlgUuH7cmhIl5pPkRkh28wQ0xc2Rt4akuAgDFCenFQsHYDAaGne
	 82e+4uwyFl873lvhe0S3LA2jK8mzdMiONGkkoorAtRlVOsWm1Y4gC4vWr48DEJ1NyT
	 Sc842iEJxfIXf1Ck0SypA9ziEw0hl6/jX9yedsWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sylvain BERTRAND <sylvain.bertrand@legeek.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 101/121] ALSA: usb-audio: Correct surround channels in UAC1 channel map
Date: Wed,  7 Aug 2024 17:00:33 +0200
Message-ID: <20240807150022.698539324@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

commit b7b7e1ab7619deb3b299b5e5c619c3e6f183a12d upstream.

USB-audio driver puts SNDRV_CHMAP_SL and _SR as left and right
surround channels for UAC1 channel map, respectively.  But they should
have been SNDRV_CHMAP_RL and _RR; the current value *_SL and _SR are
rather "side" channels, not "surround".  I guess I took those
mistakenly when I read the spec mentioning "surround left".

This patch corrects those entries to be the right channels.

Suggested-by: Sylvain BERTRAND <sylvain.bertrand@legeek.net>
Closes: https://lore.kernel.orgZ/qIyJD8lhd8hFhlC@freedom
Fixes: 04324ccc75f9 ("ALSA: usb-audio: add channel map support")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240731142018.24750-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/stream.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -244,8 +244,8 @@ static struct snd_pcm_chmap_elem *conver
 		SNDRV_CHMAP_FR,		/* right front */
 		SNDRV_CHMAP_FC,		/* center front */
 		SNDRV_CHMAP_LFE,	/* LFE */
-		SNDRV_CHMAP_SL,		/* left surround */
-		SNDRV_CHMAP_SR,		/* right surround */
+		SNDRV_CHMAP_RL,		/* left surround */
+		SNDRV_CHMAP_RR,		/* right surround */
 		SNDRV_CHMAP_FLC,	/* left of center */
 		SNDRV_CHMAP_FRC,	/* right of center */
 		SNDRV_CHMAP_RC,		/* surround */


