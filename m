Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443641DB125;
	Mon, 29 Dec 2025 16:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025611; cv=none; b=eeDIopQwQ+ymxP9wIzuwu3cudXfzpMd0o0bFfDteRj/KJQuWpmdflUUt7qgNme2pbjsSrwKDgLm2RAjf6hBgI/4zidSwB7iRJB74Xf1a0lmwGVPNV+UsjZUWNzvxFcjF5bcmJl9ugDuPOUW0kc5qF+JJKsj+mE/3/GbALJHYCv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025611; c=relaxed/simple;
	bh=N/dZTiMZ1bT2cwzh2Lue7ri5DwezAo47haKUE7aZ51U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBUbkKJ4vYJhjX5lXojYfPJqXr8RSltbAZm+Ac6cnXGDtmM+GZfXLqqspeYG+4XHbFjGTtlH/ZwxP7ksYxBV1cmd5cS9UM7dsgXlvdqzwXf9zKmuvy9PpzsThq9R0dhFDC5b+yOYgqEpN0zqAKKZ9OkCXLlKRUkXJq5yCdFCXMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sP688GnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sP688GnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C169AC4CEF7;
	Mon, 29 Dec 2025 16:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025611;
	bh=N/dZTiMZ1bT2cwzh2Lue7ri5DwezAo47haKUE7aZ51U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sP688GnQRAhMIbFGzKbDBBHwQ3227t42cKNXDfFvrjKGbTaAg3I0mGTKJncQf4ZSK
	 rYil1l2v168WEZ4NyVgGYuM9k+QuL+3byw4957XnakeoNZbu4PiEgB4UQ11HKAdewx
	 Dq5k99rWTote6ApwB/fWjIvVsCX5hnG0AboExMV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.18 241/430] efi: Add missing static initializer for efi_mm::cpus_allowed_lock
Date: Mon, 29 Dec 2025 17:10:43 +0100
Message-ID: <20251229160733.224728439@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 40374d308e4e456048d83991e937f13fc8bda8bf upstream.

Initialize the cpus_allowed_lock struct member of efi_mm.

Cc: stable@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/efi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -74,6 +74,9 @@ struct mm_struct efi_mm = {
 	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
 	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
 	.cpu_bitmap		= { [BITS_TO_LONGS(NR_CPUS)] = 0},
+#ifdef CONFIG_SCHED_MM_CID
+	.cpus_allowed_lock	= __RAW_SPIN_LOCK_UNLOCKED(efi_mm.cpus_allowed_lock),
+#endif
 };
 
 struct workqueue_struct *efi_rts_wq;


