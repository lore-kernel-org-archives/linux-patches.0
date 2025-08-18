Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B920335BAF;
	Mon, 18 Aug 2025 13:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525206; cv=none; b=QKRHe/JKl1P9UXRLjqrSFEqH9c7rOyVMeVsEIMpu+d57bUo87bo/6bPV0Wq5/FTbCqndIjEXatXh45LYJeHJgkbR9qcVjvEosht4GACjHc4y6xLlloSJ/B4FKTksxJDEODkzPfj369xYCoU8nBR6c2jfOIaM3e0Uf1fYF8ql/bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525206; c=relaxed/simple;
	bh=rQYtm2cfGwY9Wg82XfzmHUVuEuEtobcDJkor3Sa4fdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4A6lcXJkc0qDOyS2RuMIPcSTsPe0zBQsmKAcroXKnEdaMQvO0nSdr2egy0UuCCKxbjHVtC+xSfHIqFL8YNZX9mMxSZcv4d93lAEsuja+q67maF6qLyv/9Y2sMema+jeU+HSAblyGYorxMPLzkjDULzUqHvu4tk2DuFEXMnRNPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPNib3+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPNib3+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8491FC4CEEB;
	Mon, 18 Aug 2025 13:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525205;
	bh=rQYtm2cfGwY9Wg82XfzmHUVuEuEtobcDJkor3Sa4fdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPNib3+HVQ9EtnwUFVGiXUbi+f3Of+Z0cReKZtjdlrhFh/VbcGAwqEJC7BihrQdcW
	 S6PYbOCJdxU1RbccYPWDFMKDo8p+kEG/4BSNkoDTiQ8SyQLn8XZIrr+Q8bCyoUUkNv
	 Ff3KOMplsQ4zq7kldKWaxc+/GSKmFCs7nA9bkEQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Michalec <tmichalec@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 191/570] usb: typec: intel_pmc_mux: Defer probe if SCU IPC isnt present
Date: Mon, 18 Aug 2025 14:42:58 +0200
Message-ID: <20250818124513.162433936@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



