Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C9D79F0;
	Mon,  8 Apr 2024 13:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584130; cv=none; b=JaJzPIWfITPmiGDKaKVgMNedh17JZx0JFHhA/68xSfuH4f20FHsKUaQQOPAjaCrhIB4u9vDhdBELBA6br46ljCMOnixEG+ue0960QQvsK3uaiR+gPAPbHFtdyurlCrKYvCKZVe8iZhQDBmvqs3dnviCICGADN+t6gudS6+wXiHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584130; c=relaxed/simple;
	bh=/6o7Hr9LrNFzsd741WCZVFLJ0xZKSGNrkzFP6TRKtFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8Uub+cWKBqQrj/hIbNtYqlHYNUhMiY+nYaNTYZZFd+ssFcirvAuuXMlBnIN1Yqz3UyZXEz680tyk6fdGFe7SAIKJK23vlvq1gxea0soIJG1yzS3CL9Q5jApN7qtiYAVhXM0XaNUPMg32ds7cEenTORhBeI382QtDR5m6pD37NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byXG8O87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byXG8O87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1609C433C7;
	Mon,  8 Apr 2024 13:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584130;
	bh=/6o7Hr9LrNFzsd741WCZVFLJ0xZKSGNrkzFP6TRKtFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byXG8O873f6M9Iu/qMZTU/+abE8ql3+RkG2N7q8+RFatMT8NSY6/fQF0Er2FE/rwY
	 wIC4gsmAkcDI4by+ujmhHD1tO0IgTzJ2fdQAsl4gYMYT46gAQrB1QesfbjvE1jE1X/
	 N/UKdLRefeIGP5X+k4xKxILMRiwkM67n0Zcl2WYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfgang Walter <linux@stwm.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 266/273] Revert "x86/mpparse: Register APIC address only once"
Date: Mon,  8 Apr 2024 14:59:01 +0200
Message-ID: <20240408125317.757730311@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 3428faa0d675f6a6284331731b762dc041011b3c which is
commit f2208aa12c27bfada3c15c550c03ca81d42dcac2 upstream.

It is reported to cause problems in the stable branches, so revert it.

Link: https://lore.kernel.org/r/899b7c1419a064a2b721b78eade06659@stwm.de
Reported-by: Wolfgang Walter <linux@stwm.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/mpparse.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -196,12 +196,12 @@ static int __init smp_read_mpc(struct mp
 	if (!smp_check_mpc(mpc, oem, str))
 		return 0;
 
-	if (early) {
-		/* Initialize the lapic mapping */
-		if (!acpi_lapic)
-			register_lapic_address(mpc->lapic);
+	/* Initialize the lapic mapping */
+	if (!acpi_lapic)
+		register_lapic_address(mpc->lapic);
+
+	if (early)
 		return 1;
-	}
 
 	/* Now process the configuration blocks. */
 	while (count < mpc->length) {


