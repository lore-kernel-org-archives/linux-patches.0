Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AF6343210;
	Fri, 17 Oct 2025 15:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713326; cv=none; b=aRtdYYE2s85Ud2V49YEknTyFjxNXGcQIGrRJc9SjNlMTfWYPoSzkq4cQ353RX75ywTczIttIzutt3vKJY5TihXO0qhljCPjRKmmAWpG3/EtYxVVQb6W74EQjDJrybD6qSsCFqz4SCBaH+jBIoMiqgYQJ+CZ9apFFAuQYJFhokkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713326; c=relaxed/simple;
	bh=c7Llca/0NMrPhKrc8BbhJG95zlOC6nRegVZ7s2SZSkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fZaNRHtZZPw38geY4XrnOrQnRb6RoTqVPdEzrYpCOU9Uc0SMBDv5tcRJMv8epmjvUP/NMaLGmZzGWWzJ8ganM8h2IXLf6An9J1jNXLrv95/zQXHq4q1CsYhteOy6dKJuHGEvgN92HxR4X7sxL/4EWcOWaODda003kUH6rG38H0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHLG2Tqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHLG2Tqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2125C4CEF9;
	Fri, 17 Oct 2025 15:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713326;
	bh=c7Llca/0NMrPhKrc8BbhJG95zlOC6nRegVZ7s2SZSkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHLG2TqdhyV+prI7MMWo3MFMBJCn8FsuHS1QwM8AxgIXofVHH4dnMi1B+Yi7bnysx
	 wsKoMAQuL2Ya7xG2OwUT24j8mWTt/B9bIUPHPB3fudpmvt3Fwvv7VHPnzjbXt6oXBQ
	 Eb5O8TtheM2LMLRMLRU9WDtYlf1t3tGNtKS6Q8nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.1 093/168] powerpc/powernv/pci: Fix underflow and leak issue
Date: Fri, 17 Oct 2025 16:52:52 +0200
Message-ID: <20251017145132.454115039@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit a39087905af9ffecaa237a918a2c03a04e479934 upstream.

pnv_irq_domain_alloc() allocates interrupts at parent's interrupt
domain. If it fails in the progress, all allocated interrupts are
freed.

The number of successfully allocated interrupts so far is stored
"i". However, "i - 1" interrupts are freed. This is broken:

    - One interrupt is not be freed

    - If "i" is zero, "i - 1" wraps around

Correct the number of freed interrupts to "i".

Fixes: 0fcfe2247e75 ("powerpc/powernv/pci: Add MSI domains")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Cédric Le Goater <clg@redhat.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/70f8debe8688e0b467367db769b71c20146a836d.1754300646.git.namcao@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/powernv/pci-ioda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -2234,7 +2234,7 @@ static int pnv_irq_domain_alloc(struct i
 	return 0;
 
 out:
-	irq_domain_free_irqs_parent(domain, virq, i - 1);
+	irq_domain_free_irqs_parent(domain, virq, i);
 	msi_bitmap_free_hwirqs(&phb->msi_bmp, hwirq, nr_irqs);
 	return ret;
 }


