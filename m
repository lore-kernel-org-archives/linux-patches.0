Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827061;
	b=KX3CZZkkJX6aESpxAXiNb7slU1SpFHwyr54UyyI02f04OxCSTtG74wyuNrnLGCI+zmOX
	 KAYGL2ECkKnb8KHYKo3lCjcQNuSdbV00O3S/DOWxjyKjpCDPYW6R1+lVrZF0SZlHzJ3hl
	 WzHf2RuCeGCRn1oBrhc0zE2FqDpg1tFJpEhTxqVnq0fZH1odg28MobMN2T1xcChA3/d8C
	 o/5S1GRNfD9olO08C7PtD6H6PPQ4yiqVlta6lgdk3QFWE1QDBQh0h3LyVjVGk/2n3cJ5l
	 6uoO9fH2WG8u+jFuj1o2Z1LnDuGT7Y80/y5tknwktyvzWSroUmz7u33XYePJjCNDkww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yLeqcxswYVQL4/EkLxa/TCd1fX+VQvo+Fesn2E1rpGU=;
	b=vw3UD0MzFN/JfyN/TVnlLmpHaBctswMyt6v/AVsg7dc9GoDq9JQ8bVO2V2ONF9t1Rarz
	 +wRXqZYCjILHCiWFKEilUPzXMtxhghJYJZ6zEVJoMPyaaQ3D8uJvlcKoyREOH64v2PRte
	 swd2R7xCKYUE1LBDE9AITakZXq9ACp+orRoV+To8pPXOdCtNrpwfONB4LNg/bbZHJ96Ob
	 7Dv7PrJbyYk+Z/uQScsAiG48v+c2fn8tts9sZ3MMJOq0W5qvIFIxGdCBOwLN0lOEXZ6Ng
	 MdPS6mH52gsuqf/ZUDfc0xzTi9KLT3W4RAwyIMr+pZruTJz3TP3o4SphDSPkWQ+GY4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rr8MmqAo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587F9606AE0E;
	Wed,  4 Nov 2026 21:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rr8MmqAo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7ECA1F00919;
	Wed,  4 Nov 2026 21:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827061;
	bh=yLeqcxswYVQL4/EkLxa/TCd1fX+VQvo+Fesn2E1rpGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rr8MmqAoiu5yb50KxqB4cWl0UQC96Pi6IGyHb4JE1hmtpyLfwhsmtU2e9IzM+KV8u
	 xESq47WhDULKm372BUvPDQpCgEau+MsY6660RIwlpyaDBs6kKXn05+su37pOHdbTWc
	 1VxfBl9HUnCmCAnACi4mqpbF0MoZHAalijzwHaa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Tobias Schumacher <ts@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.3 170/547] s390/pci: Fix MSI directed-mode teardown IRQ bit count
Date: Wed,  4 Nov 2026 16:05:54 -0500
Message-ID: <20261104211042.978661568@linuxfoundation.org>
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

commit 1844913582fec337c54b54fdd3c92ce225930515 upstream.

On s390 with directed interrupts enabled, zpci_msi_teardown_directed()
frees the platform's maximum number of MSI bits (zdev->max_msi) instead
of the actual allocated count (zdev->msi_nr_irqs). This corrupts the
shared IRQ bitmap used by all PCI functions, causing lost interrupts and
heap corruption. Fix zpci_msi_teardown_directed() to only free the
actual allocated IRQ bit count.

Fixes: f770950a4709 ("s390/pci: Migrate s390 IRQ logic to IRQ domain API")
Cc: stable@vger.kernel.org
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Tobias Schumacher <ts@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -339,7 +339,7 @@ static struct airq_struct zpci_airq = {
 
 static void zpci_msi_teardown_directed(struct zpci_dev *zdev)
 {
-	airq_iv_free(zpci_ibv[0], zdev->msi_first_bit, zdev->max_msi);
+	airq_iv_free(zpci_ibv[0], zdev->msi_first_bit, zdev->msi_nr_irqs);
 	zdev->msi_first_bit = -1U;
 	zdev->msi_nr_irqs = 0;
 }


