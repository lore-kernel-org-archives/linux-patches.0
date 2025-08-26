Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086182C0F60;
	Tue, 26 Aug 2025 14:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217715; cv=none; b=UeQA1HZsdQcGoANXQ1Xl0vHXsBvMRwBJfgj9DWE2aXxcmDGXrQVcHhlVSC9bUROVSD2kB7mfeN7j86vcA8fCLeUtgZvA2X6KzqONanxegGGDLYx2c4cmGXKtmUjly1oOF/94gwSOmch3q8U6K6hzJilE6KBs1WDZ3fRvPUCzimQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217715; c=relaxed/simple;
	bh=g7lUmQQm/+8q1LH1JvLI7Zg5hLGofxiFgdpAEOMocgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COdz4SN8H3zoV44fsBbVkopXjBpBKvbAbC0MYvlpeh3EFk6b9JnsgTgt5axnr/lQOeEtMJu/UOdpUB4y7uJ+/9/fKWgDhlX2bJTToc/htPKImL6qeroCwIInbfdFLi0coSA8CDEoavHiE3763hiT9Ywsu5G+1fCq2gMTzzG3+Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2l1VC4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2l1VC4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEC7C113D0;
	Tue, 26 Aug 2025 14:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217714;
	bh=g7lUmQQm/+8q1LH1JvLI7Zg5hLGofxiFgdpAEOMocgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2l1VC4O2vnVtS4wQQjJsLcyVDm/BGwxVingkrXhc8zppgLh4CmyNmuZbreUrZhz3
	 6SiiwKmPtJz/iR11JVsutp1abiOYYsCJjEVBYauHvAYMoe//B/tLKKwnrEd9GH9bGf
	 M1GM5rr/BjKINgyvSPla9tKnEjSPJDTFzols1tK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Michalec <tmichalec@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 248/523] usb: typec: intel_pmc_mux: Defer probe if SCU IPC isnt present
Date: Tue, 26 Aug 2025 13:07:38 +0200
Message-ID: <20250826110930.550974677@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1276112edeff..9b4963450fe8 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -644,7 +644,7 @@ static int pmc_usb_probe(struct platform_device *pdev)
 
 	pmc->ipc = devm_intel_scu_ipc_dev_get(&pdev->dev);
 	if (!pmc->ipc)
-		return -ENODEV;
+		return -EPROBE_DEFER;
 
 	pmc->dev = &pdev->dev;
 
-- 
2.39.5



