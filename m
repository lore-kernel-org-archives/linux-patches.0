Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B749175549;
	Wed,  3 Jul 2024 11:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005841; cv=none; b=O/Cy5GcDeGe1ICPNDVpuWOpe8RXSya2zQy4nhcDrjkFCVret7+DKkZjlHmI8ovBeP1XWk4fGeD4aafPluspOQQC/5deQ1VBL07KBl+9MdZRGBmcglYDzg9tFH0ThsKi+DNfhVsGIjwVmVNSjlrM9R0VqgpIwu+KxXTwBAIcG/vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005841; c=relaxed/simple;
	bh=iNyz110a99kzD2uR5s15iaYWWPG6359c3R8YO4yVUMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gLejO6GSBgh8yaFppnVUmW1DgNZqviZrxe6g2pKkUOk8NxXSXuCGr/h73I1izGsLfo6aNrKkRvep5BCkW0TmEiogDdpoUhH8NiHt032A7+1t1+Nf5TXfSY7tJU3y75DWFWJ+0ax1bH7F3FQanDK1pWzpCnaQ088ODwnT9RBqZYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPjfGvzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPjfGvzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAE3C2BD10;
	Wed,  3 Jul 2024 11:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005841;
	bh=iNyz110a99kzD2uR5s15iaYWWPG6359c3R8YO4yVUMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPjfGvzoxg5VmY+L+h41n5dxjMdAjfGoVgaJ0SJr52BszcGFJ9jVRE3La624K0aig
	 Pj0Bvt56pnAnBWJIDiL1xZe198CiU3zwkudetu+fqdWZZpC1LF7Ki5aeWeCMXxqVYW
	 hft/vbZythdMZak6UVaq9umsyZwnacYW6THhxQ0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 183/356] MIPS: Routerboard 532: Fix vendor retry check code
Date: Wed,  3 Jul 2024 12:38:39 +0200
Message-ID: <20240703102920.028593814@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



