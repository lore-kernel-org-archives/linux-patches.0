Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE953FF1A0;
	Fri, 15 May 2026 15:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860289; cv=none; b=mXulstJwZRwEflI63MQ6LFHFG+TOsI0b0UObQs080gIMXCjII2zU489MZ5Kw/VxdN79gSjSrq7NTYalfjEPoxg2AC1Wyh3cY4lLqukWUrt6qCIEm+JH2GNEGHB2f4KxN2TV2UBHj3UXd+iejsiPb9j3H/TfFXwcK81OSjc8UTGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860289; c=relaxed/simple;
	bh=bJSUgErWMe39JzbQaL0TweG4hmP0FIan8qzN/+8ARcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbYpp6ipsFkIF4M/Ay7bbzeQ2NDeqFdid5yJXFnXnEvBDyVylFayuXgvG2O2nM1cdT6jZvkS/Vkad8SpTQPjGClolrO4pPizSnTgR9JM33PmgmFUP/qukYOehRI04rwHB8Ls52Zxa/Ff1NLxrupr1I8gebbgz31UM0B4LRn9fZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGaS1KUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGaS1KUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7565EC2BCB0;
	Fri, 15 May 2026 15:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860288;
	bh=bJSUgErWMe39JzbQaL0TweG4hmP0FIan8qzN/+8ARcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGaS1KUbu6+WpvtAR+dwrDToLVNUIik1ytmx6L2vgfIt4846h/Vv7AtRiw9d0zqbC
	 /KDuuIdA7vWD/4uvXSmPmwGthUdQ1NbW07CqD5h/+Gpq7Gj2oBQ27d6IoROnq8tOeO
	 srFpSD7S98TJOgc7fVBm0TKSiPdRWryrZWSOVNrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 032/144] media: pci: zoran: fix potential memory leak in zoran_probe()
Date: Fri, 15 May 2026 17:47:38 +0200
Message-ID: <20260515154654.256950930@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 8ea21435fe36fb853706f4935d78bc11beb63fb4 upstream.

The memory allocated for codec in videocodec_attach() is not freed in
one of the error paths, due to an incorrect goto label. Fix the label
to free it on error.

Fixes: 8f7cc5c0b0eb ("media: staging: media: zoran: introduce zoran_i2c_init")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/zoran/zoran_card.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -1377,7 +1377,7 @@ static int zoran_probe(struct pci_dev *p
 		}
 		if (zr->codec->type != zr->card.video_codec) {
 			pci_err(pdev, "%s - wrong codec\n", __func__);
-			goto zr_unreg_videocodec;
+			goto zr_detach_codec;
 		}
 	}
 	if (zr->card.video_vfe != 0) {


