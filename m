Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5729D352096;
	Tue, 26 Aug 2025 14:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218567; cv=none; b=MRopi5B/667xn2VT1u/J5tJbE136VbI7qpqPc9BWtcbqU1OqisheZfMD8JccVcxzohj7p1onV+arsLpVegDx7zGJF5jpy+TSAe7z7uBv7SHlKa9Gq8Deg/4gKO5XOvQr4VublhNYhXZ18uNNscOEiiOGpkmRbHDIcIBiuHZfHRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218567; c=relaxed/simple;
	bh=YKrkwnxzQcCIhQxDTM+Vlr+qDGRn2HtVf9HaJOUg3Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtsHzjUKSuT95I3stPHrFXJ5wq0ATpWvEGGHxnCF9ZB6hqiap2Z1f0LxZ47fUgg25cl1z1NlTi8XVm7PiB2t1zl6r6Np7AVmmlTo24eYRPh7UQSSTpe3VpfzWn8j3TcoJmoHBZwQ46UGn1k9/BE4H11Qf+2Kh199tvhHedIgQLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2TRAr02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2TRAr02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E225EC113CF;
	Tue, 26 Aug 2025 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218567;
	bh=YKrkwnxzQcCIhQxDTM+Vlr+qDGRn2HtVf9HaJOUg3Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2TRAr02EZjuUjwbghqCq6u/CqVCTLBVKJPPWTNyM+PuGn5C5Is1aEY/TVxX8S1Wv
	 U940THisxid/3OPLy5HnDR2hOkDRRqwxQo9J9LKhLWttCo4/b4CqW5to4bHlIhgks5
	 422ek6gQcOBslzYqyXcFeIMlmT9Bj+vWgWJGWXxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 018/403] mmc: sdhci-pci: Quirk for broken command queuing on Intel GLK-based Positivo models
Date: Tue, 26 Aug 2025 13:05:44 +0200
Message-ID: <20250826110906.269784936@linuxfoundation.org>
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

From: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>

commit 50c78f398e92fafa1cbba3469c95fe04b2e4206d upstream.

Disable command queuing on Intel GLK-based Positivo models.

Without this quirk, CQE (Command Queuing Engine) causes instability
or I/O errors during operation. Disabling it ensures stable
operation on affected devices.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Fixes: bedf9fc01ff1 ("mmc: sdhci: Workaround broken command queuing on Intel GLK")
Cc: stable@vger.kernel.org
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250626112442.9791-1-edson.drosdeck@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -972,7 +972,8 @@ static bool glk_broken_cqhci(struct sdhc
 {
 	return slot->chip->pdev->device == PCI_DEVICE_ID_INTEL_GLK_EMMC &&
 	       (dmi_match(DMI_BIOS_VENDOR, "LENOVO") ||
-		dmi_match(DMI_SYS_VENDOR, "IRBIS"));
+		dmi_match(DMI_SYS_VENDOR, "IRBIS") ||
+		dmi_match(DMI_SYS_VENDOR, "Positivo Tecnologia SA"));
 }
 
 static int glk_emmc_probe_slot(struct sdhci_pci_slot *slot)


