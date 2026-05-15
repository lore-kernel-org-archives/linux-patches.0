Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D114963A1;
	Fri, 15 May 2026 16:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861947; cv=none; b=f6eqbXbw+sw5A/Fvyvt++HHz5hhTb5TmyxkUtdTVbRwLdYgKhEqDRwraRlr6pSVWWhNiux3nT0VkoQAiOgP/0MgQAQE82IXpmGeBQXt2C3LJWYnJptzywEVONPPrwx1hZ6kREut7OF2X3tBBm9WOWDhF7dtZlc3yMEUCiPlHRTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861947; c=relaxed/simple;
	bh=Sklpkppusjp3+jC+HVFvTdDsUoKhd4Jbc6tzoOy/3Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2uCBlnalRV/XWjrXWHvNP/HvTjD4JXUhGY154vg7NZh6Vy6i9dUEBvRSkyJEReul/4S20BpqaGnAUedq5LJSzG1F4x+oMugBWpRH5CzhngH2z8PW7HvfjVNhfAZZ0gSJIN3dMHdnO7+KYF0H3UgG58nfYBXUVhezYw4OhV+kkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBjWpjHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBjWpjHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDC9C2BCB0;
	Fri, 15 May 2026 16:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861947;
	bh=Sklpkppusjp3+jC+HVFvTdDsUoKhd4Jbc6tzoOy/3Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBjWpjHSURfL2+WONFZN/lI8LC736JLy/eHqoJqM+ZbA+KI5/KJbycIsCDwkQyJpp
	 byBMtfgLQAG+4ahB2RzDo0KXJhMdEIC3xEfRcIWHR30jDDvm7HLS/HnWnBjQCzfxzM
	 VDca0MtvZL/0YslD6iBpFh6DZTKgntFlhcN1EhK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 048/188] media: pci: zoran: fix potential memory leak in zoran_probe()
Date: Fri, 15 May 2026 17:47:45 +0200
Message-ID: <20260515154658.357666036@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


