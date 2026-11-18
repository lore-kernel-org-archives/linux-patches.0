Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018817;
	b=TpP3B7DlJacrVQWJzBQwIwc1krqCuMzQn6/c11IEzEEVAXv4KbnYKHA7y+V8lA2nvfIC
	 6Giw82mTHA50bM+lP/dfdS/26DoEyKRmbQJIGZ3kk3ZoEluYQMpx89h0BX0wxb/2D9qRj
	 3RqCkEQ88NtkJjoGQUviO4BuzNNYJY1lacGoTxwDB4ZC+y1GfL6dE9vAir+/3DHc/hOJ1
	 YDaqpP7rbx0kYqg+cydj+2ojTDeMkKYuxQ9yyYtOmt/+aMRiUsHfyW1JJACxw9rA2nOqp
	 UIdHk8cQgEkVivJCmzylURsQkiu6zOAPnigPYhHb2pT0HdiHtTIPbsVDIALg8hGfErg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yjahYSwWamLtSxwvLEWbXjn8K3H1oLlhyiRm+iqjjzE=;
	b=KJDfP74vR4dcLmbacHyWKRH8N/fP6GKtZSoTAzLPsh6CyVu6/mEOC7qIbfbMC7rzdvWO
	 jx8Ik30LrPXbZmpnoAgTOSexdEZWeMUr4tzB9sIs0da1upE/QBEmgISVve6LrZ0axn05x
	 ujbJTHj+DSTYq6FEaQBEgMFYs7HH569rAPkI9Larp1espA1FR61iX6L17arFMvE1fBrSw
	 meX85p/ddoZ70F78lV6Og4zVnHmhTDsyyuKXrW8I5E1du2yUz0/gedv+m4EZrGBGKHL74
	 J0LTlZiweAxrAt76Egr//ltC87Wd6bb2QqEh3JmMeDAklHJ84to5QdMa+OEtzJNdH5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T/onHmu0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F7B606A337;
	Wed, 18 Nov 2026 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T/onHmu0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336001F000C4;
	Wed, 18 Nov 2026 16:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018817;
	bh=yjahYSwWamLtSxwvLEWbXjn8K3H1oLlhyiRm+iqjjzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/onHmu0Botk9nrPuNrVPAQNoG5kFDra/IfKWdnB8dr9T/i8vzLfIiobNWQkX3bg8
	 CRcn+bnHLMmTgOKLiXaTWlAEgmJyR5ayBZdOMKUeC7jED9/nio+KNZcb+szZczhOM2
	 MX5PIROc6y5QsTVkKX2it/PccZvkpgIgS3RNN+ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1375/2651] efi/libstub: Free cmdline_ptr in efi_pe_entry
Date: Wed, 18 Nov 2026 15:43:35 +0100
Message-ID: <20261118150337.534464585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 8ea857a2bb547e388e86ca42c58a97e162e09f83 ]

Sashiko points out that efi_handle_cmdline() allocates this memory and
hands it over to the caller. If efi_pe_entry() ever returns it should be
freed. Add a __free annotation.

Fixes: 42c8ea3dca09 ("efi: libstub: Factor out EFI stub entrypoint into separate file")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub-entry.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
index 8ecd8cd72561f..efa3ab8ad1c66 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -41,7 +41,6 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 	unsigned long image_addr;
 	unsigned long image_size = 0;
 	/* addr/point and size pairs for memory management*/
-	char *cmdline_ptr = NULL;
 	unsigned long reserve_addr = 0;
 	unsigned long reserve_size = 0;
 
@@ -63,6 +62,7 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 		return status;
 	}
 
+	char *cmdline_ptr __free(efi_pool) = NULL;
 	status = efi_handle_cmdline(image, &cmdline_ptr);
 	if (status != EFI_SUCCESS)
 		return status;
-- 
2.53.0



