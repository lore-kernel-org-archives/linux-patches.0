Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6738827;
	Mon, 23 Dec 2024 16:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970601; cv=none; b=XHN73RGCcVYqeUvI8B5tFj0EilpByQtQju27nGdR3Aa8HC3Euk1keqBrwh7Oj5P7BZ0S2kdhKdfmOuW3aHpJbVRcRsoN1rlKqCLClUL4ogQVrIAbR0YhOcnNqHZ24z5j7xl+invVvwnVrthDfm5OLq7fg5lhkQ/Ok5Ccn7NQOG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970601; c=relaxed/simple;
	bh=7eHUBS9r/nJYxSqX1myyx/F5N9/ramboR7GXB50q7Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F/h8xCkrMufFnNuSYoqI5qPZBeuo3mjDygq5TuzDimW5q0PSXmWcpmQbME9fB+dR/WZiUU1hhQkxLiKcr41EpYVp7voNtLw/vkIcs96cVy1EgxJgT7HZ+ADaGPbS/hGdGEgXGYwUiQD1g56UWNpuZoeDpW+Q6O2KxVTN7ov0+Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwDnBOjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwDnBOjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA5CC4CED3;
	Mon, 23 Dec 2024 16:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970600;
	bh=7eHUBS9r/nJYxSqX1myyx/F5N9/ramboR7GXB50q7Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwDnBOjW9nNlwnHZ6YSYFoUC1deSniek32SSpw4HoPPgrv4yH/nOm0oaGUf0bNJyv
	 AzSMx8M60Ltq/vWBc9a8laXTAynthhfSzjjaYn2nfY8/7VAlrrZ5DvmT33bWnHN/lf
	 kdocebNIsJFNI+eGfz0AYsCPgHoeHk2liQNAYG8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 14/83] p2sb: Introduce the global flag p2sb_hidden_by_bios
Date: Mon, 23 Dec 2024 16:58:53 +0100
Message-ID: <20241223155354.184101560@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit ae3e6ebc5ab046d434c05c58a3e3f7e94441fec2 ]

To prepare for the following fix, introduce the global flag
p2sb_hidden_by_bios. Check if the BIOS hides the P2SB device and store
the result in the flag. This allows to refer to the check result across
functions.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241128002836.373745-3-shinichiro.kawasaki@wdc.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 360c400d0f56 ("p2sb: Do not scan and remove the P2SB device when it is unhidden")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/p2sb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/p2sb.c b/drivers/platform/x86/p2sb.c
index d6ee4b34f911..d015ddc9f30e 100644
--- a/drivers/platform/x86/p2sb.c
+++ b/drivers/platform/x86/p2sb.c
@@ -42,6 +42,7 @@ struct p2sb_res_cache {
 };
 
 static struct p2sb_res_cache p2sb_resources[NR_P2SB_RES_CACHE];
+static bool p2sb_hidden_by_bios;
 
 static void p2sb_get_devfn(unsigned int *devfn)
 {
@@ -157,13 +158,14 @@ static int p2sb_cache_resources(void)
 	 * Unhide the P2SB device here, if needed.
 	 */
 	pci_bus_read_config_dword(bus, devfn_p2sb, P2SBC, &value);
-	if (value & P2SBC_HIDE)
+	p2sb_hidden_by_bios = value & P2SBC_HIDE;
+	if (p2sb_hidden_by_bios)
 		pci_bus_write_config_dword(bus, devfn_p2sb, P2SBC, 0);
 
 	ret = p2sb_scan_and_cache(bus, devfn_p2sb);
 
 	/* Hide the P2SB device, if it was hidden */
-	if (value & P2SBC_HIDE)
+	if (p2sb_hidden_by_bios)
 		pci_bus_write_config_dword(bus, devfn_p2sb, P2SBC, P2SBC_HIDE);
 
 	pci_unlock_rescan_remove();
-- 
2.39.5



