Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725E9330B2E;
	Fri, 17 Oct 2025 15:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716443; cv=none; b=VpLJKLaitIuJB58VAsGXSvA0YehKT+LWxfkZGMNTtdwp7VV29jrXmPp/NqWiImEZhXkm/SkDELx0hsKg/JR+PfUDwvTaaIr7etjPo6HepVXbokG770qx8Fg1VRSjYYCw8MkdHIUPo10OmuAkZAouxHjyb78leHEMHUfTtJh/Xa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716443; c=relaxed/simple;
	bh=wCWNrplAWrCETRAxHvl0zqyAlpoNxnHFUo9ORm7qaUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BEG9NWDhStM3afyL1fLWkoqI98TlHsX61BoxbGdXcRmtc6Sft/kJ7MeyVmF0puvr4hakKSl6WwDlxlhnfSr5zOs6gJW9e15A4UaQPbPspwt/jgDXxTP4LkF0HaINJtNXPMJAXhQd8jp9k2EkRS0p46RvvjKNeQzez9oJEURiQF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FngWZ6fL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FngWZ6fL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19BAC4CEE7;
	Fri, 17 Oct 2025 15:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716443;
	bh=wCWNrplAWrCETRAxHvl0zqyAlpoNxnHFUo9ORm7qaUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FngWZ6fL5rp+XkIkNBkR8IZ+6aW0Rnqyo9wQ7t4gL0DJRMGogUmnY2MXYxPtsNFPa
	 pTY21cTIht5Im30GukdSYFvNgOGcLMuFT3VkElmS2GqNhZcTVMhlWWnLBRMYGgHwA8
	 WurXBU/zzo9IrFpx77g7xkdN7xTWyMokvWa9Mu48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 5.15 193/276] powerpc/pseries/msi: Fix potential underflow and leak issue
Date: Fri, 17 Oct 2025 16:54:46 +0200
Message-ID: <20251017145149.515623315@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 3443ff3be6e59b80d74036bb39f5b6409eb23cc9 upstream.

pseries_irq_domain_alloc() allocates interrupts at parent's interrupt
domain. If it fails in the progress, all allocated interrupts are
freed.

The number of successfully allocated interrupts so far is stored
"i". However, "i - 1" interrupts are freed. This is broken:

  - One interrupt is not be freed

  - If "i" is zero, "i - 1" wraps around

Correct the number of freed interrupts to 'i'.

Fixes: a5f3d2c17b07 ("powerpc/pseries/pci: Add MSI domains")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Cédric Le Goater <clg@redhat.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/a980067f2b256bf716b4cd713bc1095966eed8cd.1754300646.git.namcao@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/msi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -607,7 +607,7 @@ static int pseries_irq_domain_alloc(stru
 
 out:
 	/* TODO: handle RTAS cleanup in ->msi_finish() ? */
-	irq_domain_free_irqs_parent(domain, virq, i - 1);
+	irq_domain_free_irqs_parent(domain, virq, i);
 	return ret;
 }
 


