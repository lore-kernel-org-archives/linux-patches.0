Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587643FD94E;
	Fri, 15 May 2026 16:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862482; cv=none; b=ouwp0VbbV/BAgkrAIIaSq1ggkQeT7CrRZ3yppls0s7mqqH7ZqBWkvG2LS+AYXdCCAUj/JiPCKDaNY5NON+2IgUr2ud5p0/91PHwn/OUtuDAldLAhATL6QLnS883eIV/Bfqa2dsguL6xoGFcNCh01ChPYtHixAs3vp/sJVW6TsOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862482; c=relaxed/simple;
	bh=xTLMSdO7x3U4pPUMkAKzqS4OqBA097IzlJfiMM7n7pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOa4aTZbZCfnt78p++CafT5dx+swy1L8V5Atk6rmV5RMhlbIN9/DZNXnQQHB1gzE92bDzbzpP+AkW5Ib25iRYbV+wY/vJOySljwSoNz6HJ6rUwwaGjb8JwSLBvz1H3tXOe+Jga5yJZxHflTnyyaOq0ZHVVH5pZISIApvKeGYcH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ud/2ynER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ud/2ynER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31E8C2BCB0;
	Fri, 15 May 2026 16:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862482;
	bh=xTLMSdO7x3U4pPUMkAKzqS4OqBA097IzlJfiMM7n7pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ud/2ynERRJW24f25CxDKbcR32mbpHSgahflQoxv5bZe0jjvih7VuV8jeYWIuivr9A
	 Q2i4wfH7tusGXsdj6ouF7XALiJDFGJbjTLZp3ApQ9iCTFmBrRxp1o5/LGz3yvRPQ57
	 nYHgodQY5lR8RigmGb8w0RA9igVwKPAb9tUBKGHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 065/201] media: pci: zoran: fix potential memory leak in zoran_probe()
Date: Fri, 15 May 2026 17:48:03 +0200
Message-ID: <20260515154659.942965103@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1373,7 +1373,7 @@ static int zoran_probe(struct pci_dev *p
 		}
 		if (zr->codec->type != zr->card.video_codec) {
 			pci_err(pdev, "%s - wrong codec\n", __func__);
-			goto zr_unreg_videocodec;
+			goto zr_detach_codec;
 		}
 	}
 	if (zr->card.video_vfe != 0) {


