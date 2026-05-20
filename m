Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6F33F4DDB;
	Wed, 20 May 2026 18:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300001; cv=none; b=l/HSfcXi6X132jDuuY2IYLlIy6c/cwl+WrwisilWIi4I7S8xB+hmGW56KJY2jAphCAZq9X0klD/7O4Z9vI1GtwkxOHVVH0jygi2EkYh/y/wDmOcCjbA3BkOqV7SEVdrEHQIReyz3x3qLSRBFfJsc7UBAu8jcU9bA5D/PoAk0y4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300001; c=relaxed/simple;
	bh=Cs6wglBiuB6ZviHfr7M4jqS3UMVzRoiVFqOdYDiZ9Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIpKLKiRTrkts3RXGnS0hWi4txzqDK6hoLoqXc6oqONRhZhBC/23qfe8puNt4SMTN/s88J+Bzgz5aGtvJ0tlqVEqOnfJ7xokykB4cPUyysqIoXgbVpVtnVbVltWBbp6dhqH82LoOEi+QoeVadsupo7BpX755vIXcktQtTjTGSmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lnr5mdHf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lnr5mdHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819161F000E9;
	Wed, 20 May 2026 17:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300000;
	bh=fKbZDcyYHAut6WEupVzw+3m8g7ajtzvIWa9UFebvkGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lnr5mdHf0faoXy49hxElOW5UxxxKVaxmPDRFgfXiOH0H8wuZziQHxGaGPQm9l6GD9
	 aCPTd8IAUOR2DvJM8H2WPeVVtDLpyzN4BhzEFN6SCyGZ83FepXRpn9zxJ4/hPqRx0Z
	 m5VYFwuBGBc7Via3qNkSuiRU6w4CnfmjCF8RdmAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cole Leavitt <cole@unwrap.rs>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/666] pstore/ram: fix resource leak when ioremap() fails
Date: Wed, 20 May 2026 18:13:41 +0200
Message-ID: <20260520162111.454417941@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cole Leavitt <cole@unwrap.rs>

[ Upstream commit 2ddb69f686ef7a621645e97fc7329c50edf5d0e5 ]

In persistent_ram_iomap(), ioremap() or ioremap_wc() may return NULL on
failure. Currently, if this happens, the function returns NULL without
releasing the memory region acquired by request_mem_region().

This leads to a resource leak where the memory region remains reserved
but unusable.

Additionally, the caller persistent_ram_buffer_map() handles NULL
correctly by returning -ENOMEM, but without this check, a NULL return
combined with request_mem_region() succeeding leaves resources in an
inconsistent state.

This is the ioremap() counterpart to commit 05363abc7625 ("pstore:
ram_core: fix incorrect success return when vmap() fails") which fixed
a similar issue in the vmap() path.

Fixes: 404a6043385d ("staging: android: persistent_ram: handle reserving and mapping memory")
Signed-off-by: Cole Leavitt <cole@unwrap.rs>
Link: https://patch.msgid.link/20260225235406.11790-1-cole@unwrap.rs
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 7b6d6378a3b87..95675d4bab141 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -489,6 +489,10 @@ static void *persistent_ram_iomap(phys_addr_t start, size_t size,
 	else
 		va = ioremap_wc(start, size);
 
+	/* We must release the mem region if ioremap fails. */
+	if (!va)
+		release_mem_region(start, size);
+
 	/*
 	 * Since request_mem_region() and ioremap() are byte-granularity
 	 * there is no need handle anything special like we do when the
-- 
2.53.0



