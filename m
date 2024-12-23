Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4AB1AF0C7;
	Mon, 23 Dec 2024 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970204; cv=none; b=IJjeFkRQTWbNYUQQmcfJ+m0jSRh5DpHHhUy0WXau3tleCHU7Dks0R6IXqzIpZTQxgEhKpSm4CREmpIajR6aDkGd4AoEJuvSAPdCAHghh3ebWLjAQ7FLf5CfFymClKgZEtXE+PkFsdtOF30H2kcef1W51Vlzd9jbI7HRiqUcdVkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970204; c=relaxed/simple;
	bh=QXkNymxouo8ZnKfHKabaIj/tge7zmpEAvEH8mhdsgL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qf2eoa6W++mIoCh+i4xbwZa2HUCREyciivl3uBzf4wvn7cBZtV3S7mbrO4i2EoIH3HLIqe0ZHomBo2jSUgS2p3vAKjnQg5DXKDeEbh64MkUmu/RrwCD33PnFKElhkc/16RRzfmwpXgRGVBgrPOWTz0VCiRzKeAjAqpHugdvuRkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bc/5yU86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bc/5yU86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBFAC4CED3;
	Mon, 23 Dec 2024 16:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970203;
	bh=QXkNymxouo8ZnKfHKabaIj/tge7zmpEAvEH8mhdsgL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bc/5yU86uDuVXrgJqTC62I8OayJW9yuFu8S08xVvlVr9N6uSM8hL4JK6dy6Zptezz
	 DQ0I5xQe2YbILqP8EJ6Y5cHyDRHYZGM/oZnvsqvEIpmfwX6ytLv5KOIT2MPRlzOBAV
	 xfwmSr2QgJFhcbj5V6CQVpfws+PB9JrW15yLbH5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/116] p2sb: Introduce the global flag p2sb_hidden_by_bios
Date: Mon, 23 Dec 2024 16:58:05 +0100
Message-ID: <20241223155400.147062288@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



