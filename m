Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD2A563FC5;
	Wed,  9 Sep 2026 14:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964077; cv=none; b=uEQkguuWPEVreP7kmN11QsrTRF7bykN8a6TUISIxzlyRJuhG8AcsCmwI690WFV01lFbVlg9epAnCHySOYYBvdvMYF9uh2ispA4NzR7Uxk3+8XQqXHNHVCSOUujqH0aNB5AmJLNzjEbVWOhOixMZPuf6cw34WralD7gmP2k+gQxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964077; c=relaxed/simple;
	bh=iFXjNRGRVXftnP9EEPY78Z/A6utbyF16MNziQisGXl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dv7BLp3RH25JYMVzgmJ5WbT0iMtiN7Mp/UFkZ0C/cLOMn3fFtM3BOzwgVQffKLM4tNb/zuTQJ1Xct1m0nxzjwipH6mxEruYbDtB7z9zesMyj+/4oU3vCO1g1XzCA0WCoNFbKptgMfdo65TQdVEzdjKU8uoKi0qY4ZnsxuHmyXZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FylPNTEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FylPNTEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306981F00A3A;
	Wed,  9 Sep 2026 14:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964075;
	bh=wEDng/eQ7fgFCCZei2GjeQ0vc0LJWsu657DqoXLUMTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FylPNTEXtwbOmgNHDIT0CMM4pwsQJx/juXytWFjNs032ao+Vly2eHAh3DHYOCe+c3
	 8faeNZWvMlLtxorj9ZbeWUcvfwFpqxtkpKVlKSW1zBMqMzer/b+PXgqIp/QHcJt82A
	 EF5W2U52dVBgUSSnX/y0UepfAlDYi7y1jzPNUREQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moudy Ho <moudy.ho@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 298/583] media: platform: mtk-mdp3: fix NULL deref on failed SCP lookup
Date: Wed,  9 Sep 2026 15:39:43 +0200
Message-ID: <20260909134248.349871926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -294,6 +294,11 @@ static int mdp_probe(struct platform_dev
 		mdp->scp = platform_get_drvdata(mm_pdev);
 	}
 
+	if (!mdp->scp) {
+		ret = -EPROBE_DEFER;
+		goto err_destroy_clock_wq;
+	}
+
 	mdp->rproc_handle = scp_get_rproc(mdp->scp);
 	dev_dbg(&pdev->dev, "MDP rproc_handle: %p", mdp->rproc_handle);
 


