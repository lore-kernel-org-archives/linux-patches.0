Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CEB3328E6;
	Fri, 17 Oct 2025 15:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713764; cv=none; b=GuqcgecRMvUU+q/38wnpejcsC9prC5PJ80bPmJNs+1KB4rP/zCepMgrm/zIPYp1jLDGzKq+kdGyUB/nPj0j8MiTPkoY0x4nDzlwQrvP/IKjRPoZflgE+vlZyhVY92Xx4d0EWvIfTcCSowFxj98tf0ewsNPESJyAH0mKkgu5pUGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713764; c=relaxed/simple;
	bh=oQ/ooIRWtzzKkZVuSxdFw03M7X9jNFsvK7AhSv4XWGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TYloA0D0sX2SoqCLVXCIqpIH9bLOADWc5VncJL1JN3skUjHMGIrGlJzL5e7K2vSmecT0v0FPVU84eH6JQDij0TTj2NTBFDqJWX0qY6eN5Imzw1UlbI+MnxT8/pK+BN5lJh5CiJeXZpoYQiEbofhnWLagcCfZVmqJwrWVfE73Xgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UX5CLqXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UX5CLqXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7082FC4CEE7;
	Fri, 17 Oct 2025 15:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713763;
	bh=oQ/ooIRWtzzKkZVuSxdFw03M7X9jNFsvK7AhSv4XWGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UX5CLqXQpZVE5ZL7avoUi1adekMl9VLwJItDQlNj/2Z/mpdRGv2lMRsxLPXkcBv4W
	 DoSn7YRcqhhJ+IoJIs93LTcLwx0/Xk1rvibUSVtFGK8CfV+9gEuQXt7+8zg7Wjy8ms
	 gnNRwXpvdxarLI8DBxE4JFZX60uEWz1TjwnTxbO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.6 110/201] powerpc/pseries/msi: Fix potential underflow and leak issue
Date: Fri, 17 Oct 2025 16:52:51 +0200
Message-ID: <20251017145138.784357877@linuxfoundation.org>
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
@@ -587,7 +587,7 @@ static int pseries_irq_domain_alloc(stru
 
 out:
 	/* TODO: handle RTAS cleanup in ->msi_finish() ? */
-	irq_domain_free_irqs_parent(domain, virq, i - 1);
+	irq_domain_free_irqs_parent(domain, virq, i);
 	return ret;
 }
 


