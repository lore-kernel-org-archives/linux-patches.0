Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4127340DBF;
	Tue, 26 Aug 2025 11:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207823; cv=none; b=iiYxv+ZxUiJ+6v/VFlUfflg/HqVMBNLMrmofGKvKhZ2146E6k1+ffH2TRwbfs5+JuLFsBrVYmS4DImdtHRLvXp/LPRy9M+75PtJtuUjHNN7ppZ5Al6KYCvf8y1KJVAw65GXNaQuOVUrp8Z5qwS0GBr8r09d+9i6AxEDjjyUDx+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207823; c=relaxed/simple;
	bh=sY7ECgz31TzjngHw9ak5xMC+LeKZYK5Va/pRd/uvfKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGuaWzB6FLLdsxVVcYIAoQHt+ZdSyji2ODS++YwR1heXjXEGU5o8QhcAjBW60rtM3Xb8S6kkKwH2n8+d70fZGny6hMYrVYoqkxOtuA8Yy1HCF3wFkjkj5OhTanPdYaccCe+MTkr8g6flCnsQMJyl3ltwKqpY1OzR8w1NeaqSeZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TigA1Qa/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TigA1Qa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAC7C4CEF1;
	Tue, 26 Aug 2025 11:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207822;
	bh=sY7ECgz31TzjngHw9ak5xMC+LeKZYK5Va/pRd/uvfKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TigA1Qa/yk7xGnl3lELoAfuYcrZtUF9D0K4TZ/R9Vp/+xfQupUDX+yzwm97vwXwYx
	 +jQfXRNtmscRfqgmUuU/oZt5s198+UNXfwfJdhexSloDnpvzao5R3djPSaXCaOpQb+
	 NNKo+yXnTSENpgoPshe7B9ThzB4VcNQWusH45nqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Libing He <libhe@redhat.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.16 331/457] x86/CPU/AMD: Ignore invalid reset reason value
Date: Tue, 26 Aug 2025 13:10:15 +0200
Message-ID: <20250826110945.521205256@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit e9576e078220c50ace9e9087355423de23e25fa5 upstream.

The reset reason value may be "all bits set", e.g. 0xFFFFFFFF. This is a
commonly used error response from hardware. This may occur due to a real
hardware issue or when running in a VM.

The user will see all reset reasons reported in this case.

Check for an error response value and return early to avoid decoding
invalid data.

Also, adjust the data variable type to match the hardware register size.

Fixes: ab8131028710 ("x86/CPU/AMD: Print the reason for the last reset")
Reported-by: Libing He <libhe@redhat.com>
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250721181155.3536023-1-yazen.ghannam@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1324,8 +1324,8 @@ static const char * const s5_reset_reaso
 
 static __init int print_s5_reset_status_mmio(void)
 {
-	unsigned long value;
 	void __iomem *addr;
+	u32 value;
 	int i;
 
 	if (!cpu_feature_enabled(X86_FEATURE_ZEN))
@@ -1338,12 +1338,16 @@ static __init int print_s5_reset_status_
 	value = ioread32(addr);
 	iounmap(addr);
 
+	/* Value with "all bits set" is an error response and should be ignored. */
+	if (value == U32_MAX)
+		return 0;
+
 	for (i = 0; i < ARRAY_SIZE(s5_reset_reason_txt); i++) {
 		if (!(value & BIT(i)))
 			continue;
 
 		if (s5_reset_reason_txt[i]) {
-			pr_info("x86/amd: Previous system reset reason [0x%08lx]: %s\n",
+			pr_info("x86/amd: Previous system reset reason [0x%08x]: %s\n",
 				value, s5_reset_reason_txt[i]);
 		}
 	}


