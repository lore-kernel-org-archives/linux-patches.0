Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F852C15AB;
	Wed, 20 May 2026 16:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295215; cv=none; b=kkqeqAXsyJYM2jgYupwHLHcdhttkUChJwTS56DIYvgJMTFi915D+EqKf6tjb+CUdcH+vNHs7eWk6Zp2a/CVaBlnVZhDvuVEG41fW80JXLfhMjyJ+R5FOeQYe2EZuANuiTLaVal6GSZP5qqOlPURONsc+Eh/500jvqT59ENciD60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295215; c=relaxed/simple;
	bh=aFSgwPogAO1LIBDjFyKs4h5G+6M5c6vsivEiKtVnV64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EknkArH7PcdeDR/Z49zt/hdd4f3PuNSZvj9/qpomnDCpxu8qM8vhQZZ6MMPqqiTbzu5zqfGPsdaEhCqsRq5/PbqQ2lrZRhXENyVwp324fMMBcAYerer4tuoRAr7alcQ0O4+Eh76D5HUS+LCd6uG8leOZE+cj4gtM31luY7jZbDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXSmfPGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXSmfPGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9741F000E9;
	Wed, 20 May 2026 16:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295213;
	bh=tTSU4S5vV/DRsEYYwGR48CMd5r/7JCXTc2FJG4HRUOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXSmfPGxbIC3NzTxYV9ZDo5vo6ifxWhNlG/v660hdVgTSZ/xJKWoYo56Gd8A2emCb
	 pNx+AWPQKz8BlH+XFHd74j4QIAJase8JKgB1FOPru173DO1Rhor3/Q7jPnagRZhU8E
	 iCZvuJsezgtjLs+NiiLN7L+aKGNZROp26+V4LM58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Xifer <xiferdev@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0333/1146] PCI: Fix alignment calculation for resource size larger than align
Date: Wed, 20 May 2026 18:09:43 +0200
Message-ID: <20260520162155.735740400@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 8cb081667377709f4924ab6b3a88a0d7a761fe91 ]

The commit bc75c8e50711 ("PCI: Rewrite bridge window head alignment
function") did not use if (r_size <= align) check from pbus_size_mem() for
the new head alignment bookkeeping structure (aligns2[]). In some
configurations, this can result in producing a gap into the bridge window
which the resource larger than its alignment cannot fill.

The old alignment calculation algorithm was removed by the subsequent
commit 3958bf16e2fe ("PCI: Stop over-estimating bridge window size") which
renamed the aligns2[] array leaving only aligns[] array.

Add the if (r_size <= align) check back to avoid this problem.

Fixes: bc75c8e50711 ("PCI: Rewrite bridge window head alignment function")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/all/b05a6f14-979d-42c9-924c-d8408cb12ae7@roeck-us.net/
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Xifer <xiferdev@gmail.com>
Link: https://patch.msgid.link/20260324165633.4583-11-ilpo.jarvinen@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 9506845c112c4..8f2830c6d34f7 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1333,7 +1333,14 @@ static void pbus_size_mem(struct pci_bus *bus, struct resource *b_res,
 			r_size = resource_size(r);
 			size += max(r_size, align);
 
-			aligns[order] += align;
+			/*
+			 * If resource's size is larger than its alignment,
+			 * some configurations result in an unwanted gap in
+			 * the head space that the larger resource cannot
+			 * fill.
+			 */
+			if (r_size <= align)
+				aligns[order] += align;
 			if (order > max_order)
 				max_order = order;
 		}
-- 
2.53.0



