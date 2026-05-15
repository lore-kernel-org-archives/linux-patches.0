Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DA93F86E1;
	Fri, 15 May 2026 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861405; cv=none; b=D+3zYeIU2LF9fK4jyrThb+aO67fgwVDKLtuFj4Ak4hgOgf8JpvffI2slNlWuGjOr3cbHfARKz7lEhGfzQgbMRwYLjGcGr6Y1eCAD12PfFOgJlVC8RDBIbCo5eSdLzoFAalu5pArr6MmHR4y4mFeIFWD2YKtCrURnmrg46/xqyc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861405; c=relaxed/simple;
	bh=X9OWU3TVvpVgqtkPLeGSB6sKA3HgZi3FD0gmCtkAJLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFen1Ua+UdI1ANce2uqk9iWQrGAjA9zVzHTXdLDUYTIl5uzNs6JYhgf5vDyJuoU2T8AEHcKSo1TXLYbra+/vWm5wE2q/u9hpUKbg3CSO0HjULB/Zcc5mxqqd1ZRjeYL7vecGIwLUh/rDnWIpt6Fg1d02GtKSdFbN7zoYnExC6p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSU8sTZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSU8sTZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D4CC2BCB3;
	Fri, 15 May 2026 16:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861404;
	bh=X9OWU3TVvpVgqtkPLeGSB6sKA3HgZi3FD0gmCtkAJLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSU8sTZOWt0a995LfJBPA0YyOJXXUFOsNRrBessyeiMWlkx7aDxRrA1CrWYclsfou
	 Ri9WCvyNItGz9vjwR5dR/1cskddoJAgM+2QmwzugTyW0XBlzGcpgZ1Wx/d3PEcr5Er
	 45/tUjkwIO5b/ZC5i3V70QEHhFcMOz1kasrh6DWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 316/474] media: pci: zoran: fix potential memory leak in zoran_probe()
Date: Fri, 15 May 2026 17:47:05 +0200
Message-ID: <20260515154721.850523131@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


