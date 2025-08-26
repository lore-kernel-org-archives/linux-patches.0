Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E9534A33C;
	Tue, 26 Aug 2025 13:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216218; cv=none; b=nSDIybuJxwcKuu1lJaFvI37i/UMWIBjwG2YH4m+Xj6pj64S76qLpBpLzfoj7JpmkSAzOZvlyHVpUkjHVRFVu9lWwr2Uwv8JEZDqd00kOilCcHqTEk7xjoTXAO7ysxvP4ZD7EunzWghVsAZ+Oa3t5sKXxvDgkQxzMan9jdGZR4t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216218; c=relaxed/simple;
	bh=kHTG9QdfXLZYYwun/ILmerR/t+nCwV/YX3yUxdyzvjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3LjwiwgWNx+YJgqoDb99q5+KriIWlzo2UTdJeTy8InomqGvA19wz3fu0Pxi67YjMZyttJ4crmhgZZSqMOfvMHBknaWKQUctujItVe4pekQQJYmhM0pgKrfYecYQRxdzG5l8S49QRxz3SR4qXwkGTN3n/bcyV5ynEpw1yTzHiAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BajJfy/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BajJfy/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F89C4CEF1;
	Tue, 26 Aug 2025 13:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216218;
	bh=kHTG9QdfXLZYYwun/ILmerR/t+nCwV/YX3yUxdyzvjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BajJfy/gBTTQtvVDs0NYDiTVdXqqPen91jzNF6CZOoUt7d7VCoOH4C+84yk77xf90
	 c3IHJrOuy0aQry4xfNrtipmRrtchHyskt16WT72YYJhLECYQKptsYJhSfV7hnTd+C9
	 Cna/SAMTJv2ehICGF8SP3pUp6eukFnQCViBvEwyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Michalec <tmichalec@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 327/644] usb: typec: intel_pmc_mux: Defer probe if SCU IPC isnt present
Date: Tue, 26 Aug 2025 13:06:58 +0200
Message-ID: <20250826110954.489107551@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a7313c2d9f0f..806ffeacdecb 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -650,7 +650,7 @@ static int pmc_usb_probe(struct platform_device *pdev)
 
 	pmc->ipc = devm_intel_scu_ipc_dev_get(&pdev->dev);
 	if (!pmc->ipc)
-		return -ENODEV;
+		return -EPROBE_DEFER;
 
 	pmc->dev = &pdev->dev;
 
-- 
2.39.5



