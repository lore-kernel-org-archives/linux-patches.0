Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FD1481C0;
	Mon,  1 Apr 2024 16:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987468; cv=none; b=Lau/ZiBcioW4rxOYrUEv5Je9Lv5/Pfyg1Mh9HbUZS5p9P1sQOwno04Z/kTKu4qcyOVgxKqpPhPFmZkh6zMp5alYYwbR6PI82G0jmAwgreCHijAuz5CRq7cb1ZS7BsbmjZVT8SVAn/IkMALcUYvOabyRi7GiN0UkQAZ0atymnmU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987468; c=relaxed/simple;
	bh=j5QyFTavSqyyOZ9atTWw+BtkpVQoZpsdWgskeqlqTRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVAEnCNnMJsEfsFBNk/JEWzZUr9ApxitrjdIjI7Jt197172aATOvlTjtFQPKB286AqRduQ5urQrVe9IRVByiFcdnAeZtPNtB6YaVhizqdb6NKfFX7aGz+2+5NNRWMPH//jybFKHeoOnEjCI4We0o6CBo2wnlbSFerHo2aQsaUq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ai5lp7r9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ai5lp7r9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58751C433C7;
	Mon,  1 Apr 2024 16:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987468;
	bh=j5QyFTavSqyyOZ9atTWw+BtkpVQoZpsdWgskeqlqTRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ai5lp7r9ttqS7Xe5SjJxLBCa1Ku1bgQMdE8lfQDjEYXS2A7YWXe863WqwscaBFEWs
	 9kjbmQ/Rtxjvr7wv9jz1bReKDjPP6DDPeLGMDXZYsLi4Fk7eFM+ZlcCCm/W90iCM5m
	 E5WucWALm4AszbN/m/Gy3whRE2IKjkxzJnUrCv6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 268/399] x86/mpparse: Register APIC address only once
Date: Mon,  1 Apr 2024 17:43:54 +0200
Message-ID: <20240401152557.185828558@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit f2208aa12c27bfada3c15c550c03ca81d42dcac2 ]

The APIC address is registered twice. First during the early detection and
afterwards when actually scanning the table for APIC IDs. The APIC and
topology core warn about the second attempt.

Restrict it to the early detection call.

Fixes: 81287ad65da5 ("x86/apic: Sanitize APIC address setup")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20240322185305.297774848@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/mpparse.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index b223922248e9f..15c700d358700 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -196,12 +196,12 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 	if (!smp_check_mpc(mpc, oem, str))
 		return 0;
 
-	/* Initialize the lapic mapping */
-	if (!acpi_lapic)
-		register_lapic_address(mpc->lapic);
-
-	if (early)
+	if (early) {
+		/* Initialize the lapic mapping */
+		if (!acpi_lapic)
+			register_lapic_address(mpc->lapic);
 		return 1;
+	}
 
 	/* Now process the configuration blocks. */
 	while (count < mpc->length) {
-- 
2.43.0



