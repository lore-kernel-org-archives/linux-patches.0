Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C99E32E15E;
	Fri, 17 Oct 2025 15:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713761; cv=none; b=PepPftObcdt5QLR8S0TjdNsOv7iHjG3bqg6aZDVrUz7+EkqHghxWLWziOxugdl6ZMtdEyEgvay5VB90NcrhJoW9osqFoua7nHBSo3E2wLKyUxixBqFG0UmWcpmMTf1eJvhF5Ctdgudr+pYZtUdG1RfjKLxGfiUzmQMo7MQkYcPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713761; c=relaxed/simple;
	bh=Cpljdfc9g6ldsA4gLajGxkquFyWO1UMVVWKUFzb6RtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n6RWZHi5ZfzmcFNhOmy9vTpD0wdFvGRfbxf+Yh88vP3G3IOAjxLeeYqq97P//3fh77aE3fWx3xEKdso5H5zgVnstYDUxxS3Fi6UkcpXakIhIjqeGeuS/HKHza95sN5uFqfxNvrzKqdL54420vCuDxcRf2DNhm+Zlrh1y/GvuIGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzRBF7qG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzRBF7qG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCE0C4CEE7;
	Fri, 17 Oct 2025 15:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713761;
	bh=Cpljdfc9g6ldsA4gLajGxkquFyWO1UMVVWKUFzb6RtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzRBF7qGT4S2l4qPa0zZtwRmbBgCWbfxdlPnTeI0zYp9TruHuScsP+4sMja3P0if5
	 RtgqKZJg294Wp19lH92v1TQ3QQarPO4dHRJdOOcPNCPoyxEWGlklsb1mllsgjRRIXr
	 2OT3UvqFRL6EOlzok6bM3Yi+beXnZznaFKcbCm/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.6 109/201] powerpc/powernv/pci: Fix underflow and leak issue
Date: Fri, 17 Oct 2025 16:52:50 +0200
Message-ID: <20251017145138.747854379@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1895,7 +1895,7 @@ static int pnv_irq_domain_alloc(struct i
 	return 0;
 
 out:
-	irq_domain_free_irqs_parent(domain, virq, i - 1);
+	irq_domain_free_irqs_parent(domain, virq, i);
 	msi_bitmap_free_hwirqs(&phb->msi_bmp, hwirq, nr_irqs);
 	return ret;
 }


