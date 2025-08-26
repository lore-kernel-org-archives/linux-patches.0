Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85959405F7;
	Tue, 26 Aug 2025 14:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218557; cv=none; b=GMlHbDpL+SeJslVLPNGtJlpllcOFFkmeWnqrL377LIAAei5zww42Ea7Fmfm2qq5JRv6xyVPSJrLb7uUI7J+G0edI4zfhmtUs6jouzb1aYhe3YKjCMbqE81+obCBHeTnwmtbebrhGDnxU4OD1KCpqY7e6jktulsJ8QqrxLYUl5yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218557; c=relaxed/simple;
	bh=qO5zuwbXz7zMwSmKt3nrWfc7y/+pxQwmpQUM62eTQoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q95aYeaCgYTAbSU/tZnTY4+xNS36xduePty51kz9bozwB+0HL5kItwoiMAgV8vT0QswJ3yIC7ooUXULklWcTBWANV5avkkiP/jPZ4oaqdGwHXYhdxGOSAtiNTkhCng5+SL5GV7x/ggCXiGvXMUR7PzXjJOyrr+uiqk/M6hWdOtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7nVhLrd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7nVhLrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2223C4CEF1;
	Tue, 26 Aug 2025 14:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218557;
	bh=qO5zuwbXz7zMwSmKt3nrWfc7y/+pxQwmpQUM62eTQoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7nVhLrdeKoyM+3wxELNYzWZa0qQ2IyH5xhx9KKlXT6a961fkm0nyHaeLncz1kULw
	 KAsYIba9RtNXl5qrurARzMwzRS0398XV2L+xZolzHuBiBLwVHeW2cVjY2Kb2Abgmy2
	 /uubpVQN8iw99DlH1AqVwf1h+FcCNP5nhoEIpSWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hongyu Xie <xiehongyu1@kylinos.cn>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/403] xhci: Disable stream for xHC controller with XHCI_BROKEN_STREAMS
Date: Tue, 26 Aug 2025 13:06:10 +0200
Message-ID: <20250826110907.045835620@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyu Xie <xiehongyu1@kylinos.cn>

commit cd65ee81240e8bc3c3119b46db7f60c80864b90b upstream.

Disable stream for platform xHC controller with broken stream.

Fixes: 14aec589327a6 ("storage: accept some UAS devices if streams are unavailable")
Cc: stable <stable@kernel.org>
Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250627144127.3889714-3-mathias.nyman@linux.intel.com
[ removed xhci_get_usb3_hcd() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -333,7 +333,8 @@ static int xhci_plat_probe(struct platfo
 	if (ret)
 		goto disable_usb_phy;
 
-	if (HCC_MAX_PSA(xhci->hcc_params) >= 4)
+	if (HCC_MAX_PSA(xhci->hcc_params) >= 4 &&
+	    !(xhci->quirks & XHCI_BROKEN_STREAMS))
 		xhci->shared_hcd->can_do_streams = 1;
 
 	ret = usb_add_hcd(xhci->shared_hcd, irq, IRQF_SHARED);


