Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA01E549364;
	Wed,  9 Sep 2026 14:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962690; cv=none; b=E5PFNUvtRJL+6+wXRi9AaymxuvG1pNx1eJb/fJ5Jl9dpvonj2Y2SDhELSZF5f6nHmhJdQJw3tf0jPXYOReYx+7F8sOpjEvrxnd8t+HCbxrjNR0E1on2o6UoVK/2Hhi02ZwMiqfoZaY4TJpxANoWSFCd8PcXtRe9a1T4i3KOJ7pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962690; c=relaxed/simple;
	bh=f4Yt8z59SStC4iYfK/4EzUMhBCkb3jKn69gIVBgNj5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWEytChILehok6Mtov2fC2nmSrPnDhEClmINrSR1HHz1pCM8RXPKNe49Uu5B8v+LiCGaEZxcSBg/KfEwrLIDn9D7xMX2WXDHiYvz+l0LdGCCQcQoKdHWdnlYFCd73G6zaFGNX0UIuNuYE/FwvOAUyp7/MhzwkibBhXrR4yCSJs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vy1IXgSM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vy1IXgSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED76C1F00A3A;
	Wed,  9 Sep 2026 14:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962688;
	bh=+DFUCkUdhombJlgxktleEulmLV9NH+8MaszXimd8P5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vy1IXgSMeyfkBLFV/9Xuj26xZipzOft3UyuibRlAB3wh9HfcG02uGhR1liocX0ESY
	 16ch74wWU9jX8sqg595/AWbveQnBap3D9UWdTmXsOkVLNl3fAmn070a0DNfHb1klmj
	 xJC5D05bh7AATFm3cNu5CExVFfAdBpMyR82EkKDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moudy Ho <moudy.ho@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 376/556] media: platform: mtk-mdp3: fix NULL deref on failed SCP lookup
Date: Wed,  9 Sep 2026 15:40:56 +0200
Message-ID: <20260909134243.917412889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 90368323fb244da0504e3da37a182f8e89bcc3b9 upstream.

Add the missing sanity check after looking up the SCP to avoid
dereferencing a NULL-pointer in case its driver has not yet been bound.

Fixes: 61890ccaefaf ("media: platform: mtk-mdp3: add MediaTek MDP3 driver")
Cc: stable@vger.kernel.org	# 6.1
Cc: Moudy Ho <moudy.ho@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
@@ -296,6 +296,11 @@ static int mdp_probe(struct platform_dev
 		mdp->scp = platform_get_drvdata(mm_pdev);
 	}
 
+	if (!mdp->scp) {
+		ret = -EPROBE_DEFER;
+		goto err_destroy_clock_wq;
+	}
+
 	mdp->rproc_handle = scp_get_rproc(mdp->scp);
 	dev_dbg(&pdev->dev, "MDP rproc_handle: %p", mdp->rproc_handle);
 


