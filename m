Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5203251793;
	Mon, 23 Jun 2025 13:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684504; cv=none; b=FBwCubErHRcts8xeKAHRKS0hMR7+idRhNQXjCgg9fxwpZ7P5Wndj8H+PHfyXvMApAVeb/mRNuqIaHcMkyW+Z+9VT43Q0Ah8t0ddXBztHUgCVE+v2rX0qZJNZMuq/6g5EPzkubR/pVuXu77DxCL/p9mXJZK+NtlYoThIXqTAYvuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684504; c=relaxed/simple;
	bh=umIh7b7NJdAOZ+djeQdX7M7gJGR3phhQ1NtOUgqIwwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbDKA9/r5uTRGe0EXovH0f73u6A1G9iWW4aZhNCwCME7kTB36yiEqXVWGxAPNgz5cwfVmexBAeCT0DlZYD1EzCsUHC1aoIoMH7kVO2617V2hrsyssZSLfGca6tYdT1sZesfOwlddmkjmYTrukjGpyrPunj/dQgw+3zOHmeEvJvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDNEd58B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDNEd58B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AE7C4CEEA;
	Mon, 23 Jun 2025 13:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684504;
	bh=umIh7b7NJdAOZ+djeQdX7M7gJGR3phhQ1NtOUgqIwwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDNEd58BWWI+9hB+M47qgkgW/DcJHVFATOlbcI7mgpC1lH86aZkeDX9Y4ZxDso+C/
	 Oy7iORfcZi28tAKu4De9CTiRAaoIFPu3hVG1FxFavyDFSvxK1P86qYWwZVOl837YtC
	 qvMsNfMMiXpl4PYf50OPfIoJipCWQ5QngoB00lxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Kevin Hilman <khilman@baylibre.com>,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6.15 094/592] ARM: omap: pmic-cpcap: do not mess around without CPCAP or OMAP4
Date: Mon, 23 Jun 2025 15:00:52 +0200
Message-ID: <20250623130702.515693579@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Andreas Kemnade <andreas@kemnade.info>

commit 7397daf1029d5bfd3415ec8622f5179603d5702d upstream.

The late init call just writes to omap4 registers as soon as
CONFIG_MFD_CPCAP is enabled without checking whether the
cpcap driver is actually there or the SoC is indeed an
OMAP4.
Rather do these things only with the right device combination.

Fixes booting the BT200 with said configuration enabled and non-factory
X-Loader and probably also some surprising behavior on other devices.

Fixes: c145649bf262 ("ARM: OMAP2+: Configure voltage controller for cpcap to low-speed")
CC: stable@vger.kernel.org
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Reivewed-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20250331144439.769697-1-andreas@kemnade.info
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-omap2/pmic-cpcap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/pmic-cpcap.c
+++ b/arch/arm/mach-omap2/pmic-cpcap.c
@@ -264,7 +264,11 @@ int __init omap4_cpcap_init(void)
 
 static int __init cpcap_late_init(void)
 {
-	omap4_vc_set_pmic_signaling(PWRDM_POWER_RET);
+	if (!of_find_compatible_node(NULL, NULL, "motorola,cpcap"))
+		return 0;
+
+	if (soc_is_omap443x() || soc_is_omap446x() || soc_is_omap447x())
+		omap4_vc_set_pmic_signaling(PWRDM_POWER_RET);
 
 	return 0;
 }


