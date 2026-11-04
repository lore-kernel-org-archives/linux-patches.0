Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827063;
	b=5lJj4Zn8iWfZJYmgw/BjfoYYNwVxCZcW70uQU560UGClPTZnr6WSy6C8SPwCWxH/Eopx
	 AVmwDpBDI4LfLlKo2ZJWJ1rzGmiuz4kDw9eW1f/uL2mDxqU0Bb1133Koj2HPTwVgqU5dw
	 Q6mg62DDHKeNhyTmE8aAkxEVVKXLjAYeyPzRQOTGWjtssS0ABK0jvkV0w4waSaUSubZyg
	 bMawr9K5g6N2rgw3R3OwlP7DS0dN6hRtXRvM3vDaqHDDuONW6kZbzY/56VaWfezTf1JRF
	 Kl3TMsTjv0TgsvisJdBEpVD4SExjqhUfmUmZ5NU8zAclOsAi704Df0JaN0QWCy+3a3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pM52fU7HsiAflvYvIK8QdmmqRWXX5NnVKLqLiC2g2Q4=;
	b=JSmpCf62c0ZtPZFgjy6+CYaWkzN8E43uO8SzbqaEXI/fRkeMyIrK9n2UgaIMgrrzlOci
	 t94JvdJSBYOZVXjxQwrRb364mDtGMV7eYFwc7IeKwxqfGY0Sp/GSztjKVxrmzITXbcGav
	 /2cEdwkYKXmMWmduG2VKHQQpDwVbQ2WqKjbvP29pjqU/ooAYmOeeTx17c/pIe6W+Njj7t
	 kzugZzlHRuEaDLFiuF9wHw/xkfIMDdPH355/73M6BCdicvjJHRJDzy6BuyyGmMzdcsrsy
	 j/TxnX15FgOn/kdwpCBoqL8+xRy8eBjWJFyVGfSMIpfZmGFrUBknsQ/uwYXAZF89s2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=suDvdfFy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E30606AE17;
	Wed,  4 Nov 2026 21:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=suDvdfFy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CC91F00A15;
	Wed,  4 Nov 2026 21:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827062;
	bh=pM52fU7HsiAflvYvIK8QdmmqRWXX5NnVKLqLiC2g2Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=suDvdfFyGULoaos8D6VP7J7J/6pMqmXkwOMMSPxkMrwjYkojYy/VAsz8BwvpUoETi
	 EqCxUco7Tyymz+FMWDyCzTnt/k3G4Dv36qLHGTehFo1iI2PMdNQ7yiLUabrpedFfXc
	 Y2J2Ha4DeK5l43mlDasdYkapIp7txBSkTRwKYSQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Tobias Schumacher <ts@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.3 171/547] s390/pci: Fix resource leak in zpci MSI setup
Date: Wed,  4 Nov 2026 16:05:55 -0500
Message-ID: <20261104211043.007362023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Schumacher <ts@linux.ibm.com>

commit 4a185d99179a307d856dc43610cfe72395d0c42a upstream.

If airq_iv_create() fails in __alloc_airq(), the zpci_sbv bit allocated
by airq_iv_alloc_bit() is never freed. This permanently leaks one of the
ZPCI_NR_DEVICES summary bits, reducing system capacity with each failed
device hotplug. In systems with repeated device insertion failures or
under memory pressure, all summary bits can be exhausted, preventing new
PCI devices from being added until reboot.

Add proper error handling to free the zpci_sbv bit and reset zdev->aisb
if the AIBV creation fails.

Fixes: f770950a4709 ("s390/pci: Migrate s390 IRQ logic to IRQ domain API")
Cc: stable@vger.kernel.org
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Tobias Schumacher <ts@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_irq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index c9520a16ca75..134f8f4a5cfa 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -313,8 +313,11 @@ static int __alloc_airq(struct zpci_dev *zdev, int msi_vecs,
 		zdev->aibv = airq_iv_create(msi_vecs,
 					    AIRQ_IV_PTR | AIRQ_IV_DATA | AIRQ_IV_BITLOCK,
 					    NULL);
-		if (!zdev->aibv)
+		if (!zdev->aibv) {
+			airq_iv_free_bit(zpci_sbv, *bit);
+			zdev->aisb = -1UL;
 			return -ENOMEM;
+		}
 
 		/* Wire up shortcut pointer */
 		zpci_ibv[*bit] = zdev->aibv;
-- 
2.56.0



