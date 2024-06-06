Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6866C1A0DEA;
	Thu,  6 Jun 2024 14:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683173; cv=none; b=stXqEg7fgGUlndDYDJQ1DJnC92Lbr9iBpSvWClnmYlJ7oSk9ACETRajHYYM6lwm2zY3N5hbLS1Acpr7YUTKwvbLg0WBiRBeuM7CTsxlQEEzr8NrnyZxc/CJ9m4SXPflNbyf8+zl/hJ4OxMWog4WN0KPl6jRGiedNFiYpE2A+p/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683173; c=relaxed/simple;
	bh=deoJlH3l5Q/HMzdLck8BoicEcfiIi4yM8oxT67E6IkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfadqRoyaMQqX2tkDya1wCN0nuSWOpD5HqCt0eUjvSSeJmxtKhq9NZiamVnD/8J7e8JpL2p5J0qjMLOfsMFXfQoY0DgoWOG7QM5MsxigDxf8lOXKmQUxcjvj48CFU4b511O9NhTyScdeiYRJ3rU0Reyot8DlS8CcaaChIvVjxio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xU0uTlhf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xU0uTlhf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482E5C32781;
	Thu,  6 Jun 2024 14:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683173;
	bh=deoJlH3l5Q/HMzdLck8BoicEcfiIi4yM8oxT67E6IkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xU0uTlhf/0jnNM+Y3VN8dClFdQmnAVTDyn95HrMhxBmGPy/d6vxGLkMHXoBuRsXG6
	 ZGKMhbmWxAkFVGRqoY9ZO+Fj1oGdqaHVU4SFYQxdK50qsoX8CRsSXMsZqH1RIwsmvz
	 inFv9DPURLAU4m87OYocPLMQM+0b/WI90TLIBrC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hagar Hemdan <hagarhem@amazon.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 048/473] efi: libstub: only free priv.runtime_map when allocated
Date: Thu,  6 Jun 2024 15:59:37 +0200
Message-ID: <20240606131701.472072800@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hagar Hemdan <hagarhem@amazon.com>

commit 4b2543f7e1e6b91cfc8dd1696e3cdf01c3ac8974 upstream.

priv.runtime_map is only allocated when efi_novamap is not set.
Otherwise, it is an uninitialized value.  In the error path, it is freed
unconditionally.  Avoid passing an uninitialized value to free_pool.
Free priv.runtime_map only when it was allocated.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: f80d26043af9 ("efi: libstub: avoid efi_get_memory_map() for allocating the virt map")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/fdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 70e9789ff9de..6a337f1f8787 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -335,8 +335,8 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 
 fail:
 	efi_free(fdt_size, fdt_addr);
-
-	efi_bs_call(free_pool, priv.runtime_map);
+	if (!efi_novamap)
+		efi_bs_call(free_pool, priv.runtime_map);
 
 	return EFI_LOAD_ERROR;
 }
-- 
2.45.2



