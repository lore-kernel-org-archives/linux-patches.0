Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27195412269;
	Sat, 12 Sep 2026 11:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213818; cv=none; b=LvAbxWY1nUaZR0+RC98hWpUUJ4umb9Kvpu4lxy82Q+nPidWMua1/Zx/QrcGmm1YgK5l4ECFj3wCB410OjGO5UaunM2m41ltQttSu6UqtUmjSkkEFiy2AqO7bw2Zx6zIMDZn8Nxy0muQKNx2AmiZgQy8uIITzBlcya5MN12DRx1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213818; c=relaxed/simple;
	bh=CQzvKcliKzjeFNN/V5lwQmjPmsrd/DKWsEROgMzJ6mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvZQ9tAdSjZbv01C55gZYb4zD75VPL2095Z/9y93kbqhVauYG4yiTFZlpO673ahZkcqZidffsmayHRzzp2qCAULGn270zIg6N7/V9713g3aO2mVhG28AmpBhi74ClescDPaOcvhG/h3kmelEPFz7EiviIAK/K9EPXESaf874Vtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1xx8eGk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1xx8eGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED94A1F000FF;
	Sat, 12 Sep 2026 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213817;
	bh=emKW0NPVskgBFxq0cgLrktEqbxMxl9KtdTWLUmvO7AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1xx8eGkmvW8zg/G5qhXa35zuOnR2dkzptkIzADmDjO4eejkZ8WopWzOHtYlk4gSm
	 u/W97WvLDAKlKe7DpcvGiLw/OP2uHRD3lLnwryu9Hz5o3prk5WQYVnosIi9LGhuCS8
	 DaVw0kxT2BCIAL12poTlH4NkRy8dpReglJNmnl0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moudy Ho <moudy.ho@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0200/1376] media: platform: mtk-mdp3: fix NULL deref on failed SCP lookup
Date: Sat, 12 Sep 2026 08:43:46 +0200
Message-ID: <20260912065612.007365830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -313,6 +313,11 @@ static int mdp_probe(struct platform_dev
 		mdp->scp = platform_get_drvdata(mm_pdev);
 	}
 
+	if (!mdp->scp) {
+		ret = -EPROBE_DEFER;
+		goto err_destroy_clock_wq;
+	}
+
 	mdp->rproc_handle = scp_get_rproc(mdp->scp);
 	dev_dbg(&pdev->dev, "MDP rproc_handle: %pK", mdp->rproc_handle);
 


