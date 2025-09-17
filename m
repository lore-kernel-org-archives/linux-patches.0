Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AA6330D20;
	Wed, 17 Sep 2025 13:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114024; cv=none; b=nMktsOuZVxADbfwIz0GYPjkQjOtM9uaVPFQJLgGa4lFELhQBiMz+IQktxICHFsMW92POi5piyyB08IPamT2tit607Pw2BU/cDnpMLbEVRDp1fARt4+Pfy/VhIdVEk7270NPY0Nsb96Fs+dof694cEppHvEwJWJU+Ctb9XlGDK4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114024; c=relaxed/simple;
	bh=U0ylFEHAtGkSj7A/hHgd6FyS4/MnRR8dSj1fFw3peJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhcF2tuBUkE2z6DaEdRDVA9/cCeEyLclSgVVDPQWuY+3K8CYYS0+pfL4oM0QNDJWA2xmkX8SPVLWvo9rrBd6QKV7xi2VUoKYa5fcauImrvDizmGmE+E9Pcj0SyXu9jJQ9k69dKN2qspvWKR200Yq3rpmU4RJcJC8b2AamF0B6SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fng3aIq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fng3aIq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A54EC4CEF5;
	Wed, 17 Sep 2025 13:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114023;
	bh=U0ylFEHAtGkSj7A/hHgd6FyS4/MnRR8dSj1fFw3peJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fng3aIq4TUQBkdKpGHJRjF5Q/oZlRKXP7bYSmh7DCkZh3g7sFG+vSYbEer0pExq1j
	 2OL/9UvXOmHMUoIFWGgr4enhnMc4/UlolwXoe98Bga7LR+uvHnINwnlWz9+ZQhQ9cw
	 mkb4UXrDGDlrOWPTdn5EwDqaH7PAtj2KAS7i/13I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.1 23/78] EDAC/altera: Delete an inappropriate dma_free_coherent() call
Date: Wed, 17 Sep 2025 14:34:44 +0200
Message-ID: <20250917123330.132206374@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit ff2a66d21fd2364ed9396d151115eec59612b200 upstream.

dma_free_coherent() must only be called if the corresponding
dma_alloc_coherent() call has succeeded. Calling it when the allocation fails
leads to undefined behavior.

Delete the wrong call.

  [ bp: Massage commit message. ]

Fixes: 71bcada88b0f3 ("edac: altera: Add Altera SDRAM EDAC support")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/aIrfzzqh4IzYtDVC@pc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -127,7 +127,6 @@ static ssize_t altr_sdr_mc_err_inject_wr
 
 	ptemp = dma_alloc_coherent(mci->pdev, 16, &dma_handle, GFP_KERNEL);
 	if (!ptemp) {
-		dma_free_coherent(mci->pdev, 16, ptemp, dma_handle);
 		edac_printk(KERN_ERR, EDAC_MC,
 			    "Inject: Buffer Allocation error\n");
 		return -ENOMEM;


