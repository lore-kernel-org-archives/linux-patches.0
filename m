Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F031822EC;
	Wed,  3 Jul 2024 10:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003503; cv=none; b=cmckWLY05QcuY4M60QlJpuNRj7rwqbNLDJYPPmsi0D9sYDGQTLRRv5GeEFJuQJ3Dfp/WP7/Y1vrw2CnAUFm7cmwSMkW8fZtbaWQmlealWH8zZ2A9S7eJ+50GXmp/O72dK+O5MYDuiSx697w++DP/OeHifqgCyksboP6HwnecnzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003503; c=relaxed/simple;
	bh=VWcb0uBWqkDTpC2u3eWfAmRXMMs96iXojgQ/K8z5zlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RSrywqaDuV/tF1qxcKHEsIQqAAL0W6DUHkK0/yxN4tPXM6Pbr8Jfj/OYK9d06BCmrlZIZ0zICdUzge5jO98rC8IMJt6p4u6X8Omk/GaOFo5E4EY62EATNJT6SVD65x/mbmlju5Z3es3pWHICjPQyzKx7F8Ez5GMvMf8Uo7bCc/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAw8lu0V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAw8lu0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334F2C2BD10;
	Wed,  3 Jul 2024 10:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003502;
	bh=VWcb0uBWqkDTpC2u3eWfAmRXMMs96iXojgQ/K8z5zlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EAw8lu0V/FyPm323gCz9j5ncDoFuWa2ZvcVZSwxLqqkXC6lLRRFoSZvPvurrhuqNr
	 sWHDLXDTCeLZJ8PGM74SbwtIezyXRNrUmUtnoiub3Al+yR4svBdidAxisv/AdwuU12
	 Djh0NwLwiyZHu7z6B5cAd/FVDfx2cEERRuDGej2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/139] MIPS: Routerboard 532: Fix vendor retry check code
Date: Wed,  3 Jul 2024 12:39:27 +0200
Message-ID: <20240703102833.085255597@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit ae9daffd9028f2500c9ac1517e46d4f2b57efb80 ]

read_config_dword() contains strange condition checking ret for a
number of values. The ret variable, however, is always zero because
config_access() never returns anything else. Thus, the retry is always
taken until number of tries is exceeded.

The code looks like it wants to check *val instead of ret to see if the
read gave an error response.

Fixes: 73b4390fb234 ("[MIPS] Routerboard 532: Support for base system")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/pci/ops-rc32434.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/pci/ops-rc32434.c b/arch/mips/pci/ops-rc32434.c
index 874ed6df97683..34b9323bdabb0 100644
--- a/arch/mips/pci/ops-rc32434.c
+++ b/arch/mips/pci/ops-rc32434.c
@@ -112,8 +112,8 @@ static int read_config_dword(struct pci_bus *bus, unsigned int devfn,
 	 * gives them time to settle
 	 */
 	if (where == PCI_VENDOR_ID) {
-		if (ret == 0xffffffff || ret == 0x00000000 ||
-		    ret == 0x0000ffff || ret == 0xffff0000) {
+		if (*val == 0xffffffff || *val == 0x00000000 ||
+		    *val == 0x0000ffff || *val == 0xffff0000) {
 			if (delay > 4)
 				return 0;
 			delay *= 2;
-- 
2.43.0



