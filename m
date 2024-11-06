Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D641DF24A;
	Wed,  6 Nov 2024 12:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894959; cv=none; b=PNBaWmTPVwLjifX8gBFvdk038WHNFxIzSe8XdIDgi/nyIX3x4xugUYKBXsY/RY4OiPmwhsPWLzuZSaeCxPBrluzhgWkY0GDc6NTTtkMu7+DmG59JrYSzu/fXDjM9/d2TXgSsOUJpNd3ank7bCMa1tqw3a6rr5uwtUT8MMvb6+Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894959; c=relaxed/simple;
	bh=52d0rWgr0ie3x4qCuiminWStTC2wJoW7lZbNpCcBotw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxnKKPR5lw7wW/7wnoqNsljbkVCGiLqnb2luJYHliXxeV0igJQ7JIod9H48C1dBpiDvJKZ/aR7cJhzOpS9a5LJ772WihaPddoIayZ6DZzODz96Id98O0KEzk+0zvGGnkEoEDpxlRp2Glf0ZgYs/0vkwr/Gk+6TVF9UCL4We6/2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffOnyNAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffOnyNAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E80C4CECD;
	Wed,  6 Nov 2024 12:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894959;
	bh=52d0rWgr0ie3x4qCuiminWStTC2wJoW7lZbNpCcBotw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffOnyNAMUxdaF+5KuRXZZ3Y096dwTzxMvOoW+fMqdtsL2+1ZVdihZimsLdQvkvzka
	 zvQqH20jHgHddDl1790VqnY2N0s/N7Bo/wnN9WbyAwuXLiFnhyxG/mT6iytaYkCd5N
	 6VdqJ6XWIbi2QkLTBkR2/O5fM3IUhPUm/9TQRbNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 050/350] drm/stm: Fix an error handling path in stm_drm_platform_probe()
Date: Wed,  6 Nov 2024 12:59:38 +0100
Message-ID: <20241106120322.127570831@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ce7c90bfda2656418c69ba0dd8f8a7536b8928d4 ]

If drm_dev_register() fails, a call to drv_load() must be undone, as
already done in the remove function.

Fixes: b759012c5fa7 ("drm/stm: Add STM32 LTDC driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20fff7f853f20a48a96db8ff186124470ec4d976.1704560028.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/stm/drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/stm/drv.c b/drivers/gpu/drm/stm/drv.c
index f2021b23554d3..dade0ecdfc1a1 100644
--- a/drivers/gpu/drm/stm/drv.c
+++ b/drivers/gpu/drm/stm/drv.c
@@ -152,10 +152,12 @@ static int stm_drm_platform_probe(struct platform_device *pdev)
 
 	ret = drm_dev_register(ddev, 0);
 	if (ret)
-		goto err_put;
+		goto err_unload;
 
 	return 0;
 
+err_unload:
+	drv_unload(ddev);
 err_put:
 	drm_dev_put(ddev);
 
-- 
2.43.0



