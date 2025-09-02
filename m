Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3CA311974;
	Tue,  2 Sep 2025 13:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819655; cv=none; b=Ykb+ZpA1GNj1jyiVw1BWbvrITYbguPgUef1LHWlKcRjd9OEnMD+66KEW3K6Hls60TFrAPw6/kwNTG24CGXC3HTJI2sJjAt9U+O/Hh+hc738Nga95/m6jan2wyd/oWWW8mMRwfQYHlAJ42CIVYjZxotrn3fg/nwkeYdrKbfixZaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819655; c=relaxed/simple;
	bh=IfSGbhf2qPHohyr7SYRA/YnYNYk8N2whABm2aRTFyb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrapwvqJjywrmQvqMIL7tY21fFzC8icnGDhX0iwttobIUaNXJYZNtbPgGCv06RfHQ8DEaD9a08CqotGHOlQyymt4zr/GC/kePEeUpMrbiSN+znQnShxEAAz71xYDLFRk+ngVHTTW0MGpr2avUL+HfValLDpkfWOSNlbGmT3njDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHNKDgnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHNKDgnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137D9C4CEED;
	Tue,  2 Sep 2025 13:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819655;
	bh=IfSGbhf2qPHohyr7SYRA/YnYNYk8N2whABm2aRTFyb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHNKDgnH7W5oxB3JNUjvUyw9JGv5WYOWNkQoBgiB8+DC5DEDdKCEoCIkz8rqVwHC7
	 OdjCBa2g2SZVSZFfIpto49Uuz0QCu+VJfeP/jLN4vKgGGQ1XPQD/o8D6BE8C9tA+5M
	 ZGHtJr5/ghv33CzFvA7CZYV0sXEtZ+KxThF8APeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 068/142] efi: stmm: Fix incorrect buffer allocation method
Date: Tue,  2 Sep 2025 15:19:30 +0200
Message-ID: <20250902131950.863930973@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

[ Upstream commit c5e81e672699e0c5557b2b755cc8f7a69aa92bff ]

The communication buffer allocated by setup_mm_hdr() is later on passed
to tee_shm_register_kernel_buf(). The latter expects those buffers to be
contiguous pages, but setup_mm_hdr() just uses kmalloc(). That can cause
various corruptions or BUGs, specifically since commit 9aec2fb0fd5e
("slab: allocate frozen pages"), though it was broken before as well.

Fix this by using alloc_pages_exact() instead of kmalloc().

Fixes: c44b6be62e8d ("efi: Add tee-based EFI variable driver")
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Acked-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/stmm/tee_stmm_efi.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efi/stmm/tee_stmm_efi.c b/drivers/firmware/efi/stmm/tee_stmm_efi.c
index f741ca279052b..e15d11ed165ee 100644
--- a/drivers/firmware/efi/stmm/tee_stmm_efi.c
+++ b/drivers/firmware/efi/stmm/tee_stmm_efi.c
@@ -143,6 +143,10 @@ static efi_status_t mm_communicate(u8 *comm_buf, size_t payload_size)
 	return var_hdr->ret_status;
 }
 
+#define COMM_BUF_SIZE(__payload_size)	(MM_COMMUNICATE_HEADER_SIZE + \
+					 MM_VARIABLE_COMMUNICATE_SIZE + \
+					 (__payload_size))
+
 /**
  * setup_mm_hdr() -	Allocate a buffer for StandAloneMM and initialize the
  *			header data.
@@ -173,9 +177,8 @@ static void *setup_mm_hdr(u8 **dptr, size_t payload_size, size_t func,
 		return NULL;
 	}
 
-	comm_buf = kzalloc(MM_COMMUNICATE_HEADER_SIZE +
-				   MM_VARIABLE_COMMUNICATE_SIZE + payload_size,
-			   GFP_KERNEL);
+	comm_buf = alloc_pages_exact(COMM_BUF_SIZE(payload_size),
+				     GFP_KERNEL | __GFP_ZERO);
 	if (!comm_buf) {
 		*ret = EFI_OUT_OF_RESOURCES;
 		return NULL;
@@ -239,7 +242,7 @@ static efi_status_t get_max_payload(size_t *size)
 	 */
 	*size -= 2;
 out:
-	kfree(comm_buf);
+	free_pages_exact(comm_buf, COMM_BUF_SIZE(payload_size));
 	return ret;
 }
 
@@ -282,7 +285,7 @@ static efi_status_t get_property_int(u16 *name, size_t name_size,
 	memcpy(var_property, &smm_property->property, sizeof(*var_property));
 
 out:
-	kfree(comm_buf);
+	free_pages_exact(comm_buf, COMM_BUF_SIZE(payload_size));
 	return ret;
 }
 
@@ -347,7 +350,7 @@ static efi_status_t tee_get_variable(u16 *name, efi_guid_t *vendor,
 	memcpy(data, (u8 *)var_acc->name + var_acc->name_size,
 	       var_acc->data_size);
 out:
-	kfree(comm_buf);
+	free_pages_exact(comm_buf, COMM_BUF_SIZE(payload_size));
 	return ret;
 }
 
@@ -404,7 +407,7 @@ static efi_status_t tee_get_next_variable(unsigned long *name_size,
 	memcpy(name, var_getnext->name, var_getnext->name_size);
 
 out:
-	kfree(comm_buf);
+	free_pages_exact(comm_buf, COMM_BUF_SIZE(payload_size));
 	return ret;
 }
 
@@ -467,7 +470,7 @@ static efi_status_t tee_set_variable(efi_char16_t *name, efi_guid_t *vendor,
 	ret = mm_communicate(comm_buf, payload_size);
 	dev_dbg(pvt_data.dev, "Set Variable %s %d %lx\n", __FILE__, __LINE__, ret);
 out:
-	kfree(comm_buf);
+	free_pages_exact(comm_buf, COMM_BUF_SIZE(payload_size));
 	return ret;
 }
 
@@ -507,7 +510,7 @@ static efi_status_t tee_query_variable_info(u32 attributes,
 	*max_variable_size = mm_query_info->max_variable_size;
 
 out:
-	kfree(comm_buf);
+	free_pages_exact(comm_buf, COMM_BUF_SIZE(payload_size));
 	return ret;
 }
 
-- 
2.50.1



