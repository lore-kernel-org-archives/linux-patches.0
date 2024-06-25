Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65111465A8;
	Tue, 25 Jun 2024 09:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309523; cv=none; b=RMWZfrx6IqDvQjpfQheRyl9/kEMT3DtAxH51nqcPvxHh2HEXlWewc+hpWw4+7oBLIMGO6zrHHaHeBsW+FPTdDCqANb561KeRgyqOozx+e4oDltuP/dNk32b/y8e4VUrnlEy6tnZaJduDfj7XNDvHxlXCGLi+gyht2IFy8YmnCu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309523; c=relaxed/simple;
	bh=cNkkz1YDigUxIvfkxZDfOVdsd/a+Rheabcqwzf9wH3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u3hTxkjpqffTogMf4Nr4u3q3mBZiAYrRyMR38KPuWV99d6tRiYXEJqe1aPUxlIEPjagiSECCOzSwN4dq8yk/GQ9jd1r4llqVmxhvUXGjAqI50c83ghzd11HgqYIgbB6CXqRIzT3lTg8a4S4f+UG1CvXUuGd3seDRZbV6i04H6Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0/D3snq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0/D3snq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C45C32781;
	Tue, 25 Jun 2024 09:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309523;
	bh=cNkkz1YDigUxIvfkxZDfOVdsd/a+Rheabcqwzf9wH3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0/D3snq9zRT24AdTKwN1ZoYTKI5h00j8Oe6pCjS2RTv0Xj0lHanqNIwEpRTp2ccj
	 Qm4kRnEYFtQhpKX/3DspWxUtQZnAxPYwf8RtsOFXSw/JWJMqSanxencdEJs8XYy6mF
	 Q/6h9b4dGwAKEtDPoBS5fyE+Ew0xBk9Dr7mWVksg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/131] MIPS: Routerboard 532: Fix vendor retry check code
Date: Tue, 25 Jun 2024 11:33:20 +0200
Message-ID: <20240625085527.664026264@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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



