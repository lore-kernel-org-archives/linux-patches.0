Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DC42135CE;
	Mon, 18 Aug 2025 13:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523453; cv=none; b=U9USMRIMPk5GCo2sxzQbAxzvOJ8AsqeDBUKm/brZZaG+nKVEKV/832XFMk9WWvgE9TiZzrplnh1uWTQEHTt3pSqmjgwqLiKDSoB07iFkPJgaxBegUMpALrA6jw96yDgTkGVUBP4UFLLTYKVxtKcqerLNW6HpoNkS5/IQxVJ7OcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523453; c=relaxed/simple;
	bh=Ur1GPGPUUFptq29bIkqrIMJ4f2dY0n+Ymgt20vREVDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKWBrFMLLYO7JiweClk60xs/760D+eDFqpfP0Zuv5rbLOuEGutOzkQ5IMHavh0rMsZre3PtN4/3D5iEbY8OVPkjphd4znMIVwlDCpcM+dt0l1/d7uG2j5ffbYlF6KmWBfj/6BxWOvGMveeYPDPbmECvGT3nxAODgiCSjvsv1Xy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHuWhe+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHuWhe+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72128C4CEEB;
	Mon, 18 Aug 2025 13:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523452;
	bh=Ur1GPGPUUFptq29bIkqrIMJ4f2dY0n+Ymgt20vREVDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHuWhe+Npi9E6MpcrwLUNnW820S8Z5v7X5+ZZUbeJ9eLmNy40Zte5puJCGbxQAO90
	 ZLwMmCoDieLtsd6x57J9oRx8p4UrgB24g8PL3HZifGrt9hai57KhF/EHmkiQ9TzddC
	 WVeypEChIkmjXHTZLWCQCeReHXEwXJnTTZ3fjVes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Michalec <tmichalec@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 175/515] usb: typec: intel_pmc_mux: Defer probe if SCU IPC isnt present
Date: Mon, 18 Aug 2025 14:42:41 +0200
Message-ID: <20250818124505.099319096@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Michalec <tmichalec@google.com>

[ Upstream commit df9a825f330e76c72d1985bc9bdc4b8981e3d15f ]

If pmc_usb_probe is called before SCU IPC is registered, pmc_usb_probe
will fail.

Return -EPROBE_DEFER when pmc_usb_probe doesn't get SCU IPC device, so
the probe function can be called again after SCU IPC is initialized.

Signed-off-by: Tomasz Michalec <tmichalec@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250610154058.1859812-1-tmichalec@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index 65dda9183e6f..1698428654ab 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -754,7 +754,7 @@ static int pmc_usb_probe(struct platform_device *pdev)
 
 	pmc->ipc = devm_intel_scu_ipc_dev_get(&pdev->dev);
 	if (!pmc->ipc)
-		return -ENODEV;
+		return -EPROBE_DEFER;
 
 	pmc->dev = &pdev->dev;
 
-- 
2.39.5



