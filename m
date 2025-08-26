Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D4C224B14;
	Tue, 26 Aug 2025 12:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212930; cv=none; b=HsyNIFViDNwxYrWAGqExdJVTdmx0cdudMo52hG1soEGzfdwlQU9y1lBDkwhXZSGn4rcJYrT5fwwd+2Rj8Xdx7u8HkM6Rd4msykf/yk5I98uG2oFMPTUg+GSi8gv9/F4BWJ++0d04jv1Ygj7D3qYnig7BZd7RbuFSGRYgapoPpDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212930; c=relaxed/simple;
	bh=BkYxWaO/JhwLpgkEWQr3hgKIJ3UfwsojtlUTsqucVsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TN8CMXhcMDbbY1eioaO3x8CZs0zCgZA7WaIB3stDVpzjGlsIefGcXHral7aU9CInnn4fNYemlmbbJVegXVsJ5YztF1b6th+e0mvLOflXGV9oU5YSloxjh7A8LLmkc4j5OskA1Sbpta0GEcu3fNf0QoLPRtowP5vJaoO6xcCMI90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PX0X4zHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PX0X4zHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3236EC4CEF1;
	Tue, 26 Aug 2025 12:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212930;
	bh=BkYxWaO/JhwLpgkEWQr3hgKIJ3UfwsojtlUTsqucVsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PX0X4zHBQmBb6UGNQlLPNfW2DKBG64gD2RFk2IHQw/KOQCDH1kFKR7+52N4tG3HAR
	 tOCp/gkufGtMXk+fy+XYIT8tmvwQVRHNjIHnWDggHP+adN7z4O15c0VegHcwNG1l1I
	 PJ0BqkdCwoFmpwp7luB1X8bqfPpJm2FFAiRW1cuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Michalec <tmichalec@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/587] usb: typec: intel_pmc_mux: Defer probe if SCU IPC isnt present
Date: Tue, 26 Aug 2025 13:04:35 +0200
Message-ID: <20250826110956.159589995@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 60ed1f809130..a174ff7a9abd 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -730,7 +730,7 @@ static int pmc_usb_probe(struct platform_device *pdev)
 
 	pmc->ipc = devm_intel_scu_ipc_dev_get(&pdev->dev);
 	if (!pmc->ipc)
-		return -ENODEV;
+		return -EPROBE_DEFER;
 
 	pmc->dev = &pdev->dev;
 
-- 
2.39.5



