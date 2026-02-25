Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298111E2834;
	Wed, 25 Feb 2026 01:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983627; cv=none; b=KoSV9FQUxoQogXtqmNXxGHziH6S2Igo4C7A9fmlCsrmbcOwqF4jRAwismplw8rowtUNkT7bk9TiFaXOCtlmQDCqkBoSDOe7n0QR3x8HrAQVvPuoQaM3j0uFzyGL2ZyD1x3ESfAwLjn1MIzH1SzDuRUg5NQzAS4VwyF4CtBNXHog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983627; c=relaxed/simple;
	bh=stKaKHghAk4+C9RP/lCMY7JHw01tufxxCUPYzPJvRLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S3Se3tJyPSEYtej+okKh7yyxcYVna2N9PJq/AKO6H0AZamXRGx3DMcgyiTj4NAbhz9l3NCLW78KMvx6r3LZy2DtANj7qsCq0P3TtC0A2/0xfbNIDxcxK/B9Ja3yTv+nIPCA+S3QBVt8oCodvASLm8OqZ6n5YAjqFy5+DeNYjV0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olksGbhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olksGbhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBADC116D0;
	Wed, 25 Feb 2026 01:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983627;
	bh=stKaKHghAk4+C9RP/lCMY7JHw01tufxxCUPYzPJvRLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olksGbhejVtTim8vD/Fbsg+WXe/5npq2ruDQ0a4NZYcS+Sn14CSCsCFTJaWvtPsd8
	 Ny1i2Vhfy5khnF7XhNmlG+JVzaheuhXWrVdKrFVBa2LSyYH0zm1sQ1Ogu8vTrfKq3C
	 TKuSN2ockWMjzEbhFAw3JH8w+0oVrWUSxFTfCtdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 718/781] PCI: Validate window resource type in pbus_select_window_for_type()
Date: Tue, 24 Feb 2026 17:23:47 -0800
Message-ID: <20260225012417.349114080@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai-Heng Feng <kaihengf@nvidia.com>

[ Upstream commit e5f72cb9cea599dc9f5a9b80a33560a1d06f01cc ]

After ebe091ad81e1 ("PCI: Use pbus_select_window_for_type() during IO
window sizing") and ae88d0b9c57f ("PCI: Use pbus_select_window_for_type()
during mem window sizing"), many bridge windows can't get resources
assigned:

  pci 0006:05:00.0: bridge window [??? 0x00001000-0x00001fff flags 0x20080000]: can't assign; no space
  pci 0006:05:00.0: bridge window [??? 0x00001000-0x00001fff flags 0x20080000]: failed to assign

Those commits replace find_bus_resource_of_type() with
pbus_select_window_for_type(), and the latter lacks resource type
validation.

Add the resource type validation back to pbus_select_window_for_type() to
match the original behavior.

Fixes: 74afce3dfcba ("PCI: Add bridge window selection functions")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221072
Signed-off-by: Kai-Heng Feng <kaihengf@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260210142058.82701-1-kaihengf@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 902fdae73c232..09a28cfcd5b88 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -225,14 +225,21 @@ static struct resource *pbus_select_window_for_type(struct pci_bus *bus,
 
 	switch (iores_type) {
 	case IORESOURCE_IO:
-		return pci_bus_resource_n(bus, PCI_BUS_BRIDGE_IO_WINDOW);
+		win = pci_bus_resource_n(bus, PCI_BUS_BRIDGE_IO_WINDOW);
+		if (win && (win->flags & IORESOURCE_IO))
+			return win;
+		return NULL;
 
 	case IORESOURCE_MEM:
 		mmio = pci_bus_resource_n(bus, PCI_BUS_BRIDGE_MEM_WINDOW);
 		mmio_pref = pci_bus_resource_n(bus, PCI_BUS_BRIDGE_PREF_MEM_WINDOW);
 
-		if (!(type & IORESOURCE_PREFETCH) ||
-		    !(mmio_pref->flags & IORESOURCE_MEM))
+		if (mmio && !(mmio->flags & IORESOURCE_MEM))
+			mmio = NULL;
+		if (mmio_pref && !(mmio_pref->flags & IORESOURCE_MEM))
+			mmio_pref = NULL;
+
+		if (!(type & IORESOURCE_PREFETCH) || !mmio_pref)
 			return mmio;
 
 		if ((type & IORESOURCE_MEM_64) ||
-- 
2.51.0



