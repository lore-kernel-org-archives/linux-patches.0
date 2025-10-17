Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8250F32C944;
	Fri, 17 Oct 2025 15:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713329; cv=none; b=BtjgtaKCWlUYkyYTqbwfX6ZBWxGcNMUqA9knh1TlKrEDBwn5JvLd0Lsu0Ly3aPIuf8aW2JCPMnRVSFN5MjP3Bq/GmfFkgERWHx81iHC69NpzTtba6xc3wcZn/vZoVqT/7W8gWlJ+Pfe3QXI9778einuzpjsqH2lu1FfLyXnQD1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713329; c=relaxed/simple;
	bh=aKWLSm6Z2HmXO7DZ9StPRJN8Z9Yjem5z6IQOcX4qDEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qT4rzUy9RT+ucFc0LadbTyZEhyOgsjIalSKfcdqzZNsIQIRjsry3G9Of9uEXX93XIu+RuaMtIxFfyJNm0HjTte4b6Dc1brMjIKVMVvPZiHE6UOSwXcIGr1PxUdBt8512JgmG3OA0BZrIbcN+m53QVrKjbvWrwfFfQtgusZo3YMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2AULAWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2AULAWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3FFC4CEE7;
	Fri, 17 Oct 2025 15:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713329;
	bh=aKWLSm6Z2HmXO7DZ9StPRJN8Z9Yjem5z6IQOcX4qDEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2AULAWFCUxcD12pMIcA4/bZ7hOPwK/pLsNrIBNlK719JoZI8JU6DmW5FdqxcLuP/
	 Ios12P4s6WpaFm4/wu2dxYkMAn5aoY0HemlqSL1EjYUZmn/lWYNzOLZ4M8VOyQGVWG
	 hONFBe+zld11wRgnU6gbl28mAsbACzuBDsuPMHkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.1 094/168] powerpc/pseries/msi: Fix potential underflow and leak issue
Date: Fri, 17 Oct 2025 16:52:53 +0200
Message-ID: <20251017145132.490715166@linuxfoundation.org>
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
@@ -590,7 +590,7 @@ static int pseries_irq_domain_alloc(stru
 
 out:
 	/* TODO: handle RTAS cleanup in ->msi_finish() ? */
-	irq_domain_free_irqs_parent(domain, virq, i - 1);
+	irq_domain_free_irqs_parent(domain, virq, i);
 	return ret;
 }
 


