Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062657;
	b=impZMmx1vXtFxJbHwsftfmnBIhbyr382SybEVioktnYQ0jIzqKLevbxB1ykaziVmKVj3
	 hJbLd8QBjL5yzFcNom3AVaFuwURprhHRRl3/GqWy9MxKgq/3n3KW1OY8xBVY9itloQcUH
	 UwjGyUsMTfX9i4YXttetm00twjlscH52M2syrLukTm9xlHdkGzLdSDzXt2rv0lyONZx6s
	 Kd3e3WRYq22/LrSLcMwRhpM9XB1jXTEwKkZiEUTWNZ9mTzcOp05hJx4WBiYFBJJxV06U8
	 9zmvRaWXvkOqtksjWEEzC9gl3LFNwPf0pdwc+kspw5h1+h4CCPbrjBmAkB54AJsB2XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c7a4s0P8nKjfNl00FVou9Fz1Q9GPldyWIwrjk78z+Fk=;
	b=UEsTu5EbT1jNOeObqFqxIfTDarHvKfeysWb4Q6+aIS0hH4lMovXZTkUApSDIZ5YoAfQt
	 E6uMRolYgqgEAikVXSU2hBpSumhswq0wK31uacYbQ6OhGH+qBEX0zqE3LX1mX6ru1q6j9
	 zl81RzwmDAG5O+c6eav3jEgI+Tx2h3f/O1DAZeOJpuqCXnDQ6nBz6XSqVoD3Gj758h13r
	 ikpPD1XTyWSTSgN//KotdjupL5IDzDKjPc+6pgJzS1kRIh/7srSiTdRJbbn1WJAzeDHC2
	 Ub6fjmFJQxxRESgROnCZxaR/p25qnpsozDLq4suggadu0EMOd+g36dc/pGc7sQlwFRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RvJv+Mt2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD25B606A32F;
	Sat,  7 Nov 2026 14:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RvJv+Mt2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F971F0089F;
	Sat,  7 Nov 2026 14:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062656;
	bh=c7a4s0P8nKjfNl00FVou9Fz1Q9GPldyWIwrjk78z+Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RvJv+Mt2W0YQiI1JS+O1iQgnz3dK6q4OnetNJAldd6Ohpd5/EPGZ2znWiD27gaO2i
	 dC2p98exQNo7XLULZRbzVMQj2QNiJ+bYxaI+UwcHmSfruhsoQPcNYOECXCTZH5Cvu/
	 kjxsdkka8a8pE0hVZqEg5SgEdOM/a105u+tDtz3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1520/1536] irqchip/irq-msi-lib: Free wired MSI descriptors
Date: Sat,  7 Nov 2026 08:58:56 -0500
Message-ID: <20261107135040.564785701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 1c16bc2b1122f78f9d51c5785f7a78b36d44972b ]

msi_device_domain_alloc_wired() allocates a descriptor for each
interrupt, but wired MSI domains do not set MSI_FLAG_FREE_MSI_DESCS.
msi_device_domain_free_wired() releases the IRQ without freeing its
descriptor, eventually exhausting the domain. Failed allocations also
leave descriptors behind.

Set MSI_FLAG_FREE_MSI_DESCS for wired MSI domains so both paths
release the descriptors.

Fixes: 64a855324311 ("irqchip/irq-msi-lib: Prepare for DOMAIN_BUS_WIRED_TO_MSI")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261025122058.2180685-1-thnkslprpt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-msi-lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-msi-lib.c b/drivers/irqchip/irq-msi-lib.c
index d8e29fc0d4068..34707593df49a 100644
--- a/drivers/irqchip/irq-msi-lib.c
+++ b/drivers/irqchip/irq-msi-lib.c
@@ -71,6 +71,7 @@ bool msi_lib_init_dev_msi_info(struct device *dev, struct irq_domain *domain,
 		info->flags = MSI_FLAG_ALLOC_SIMPLE_MSI_DESCS | MSI_FLAG_FREE_MSI_DESCS;
 		fallthrough;
 	case DOMAIN_BUS_WIRED_TO_MSI:
+		info->flags |= MSI_FLAG_FREE_MSI_DESCS;
 		/* Remove PCI specific flags */
 		required_flags &= ~MSI_FLAG_PCI_MSI_MASK_PARENT;
 		break;
-- 
2.53.0



