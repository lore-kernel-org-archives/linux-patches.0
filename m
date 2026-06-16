Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E4944DB64;
	Tue, 16 Jun 2026 16:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625946; cv=none; b=Iava4e7WnZ4ae/0jgJQOx+0g3FKFHGN6jOGplEOuf+HUcuJxdgiE25TAAaep3ETUtBS66BgAPPyhTHorKoSV6+HuuQpg9Go17J8LVUVBOEP6BiDdTD951oVOja+qShCt0Lr4NwFnnRnk8j3hHf4drhx6DMT0ODSIaqdXcyJbBG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625946; c=relaxed/simple;
	bh=jjO9CmCvtNU1MSA4DCeLq8b8Bw+xM2HazA2PFRxXLxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+twrtZTMzXe7WMAQv35K0FfKh/DHUfwNZzEJn+f5STwYegPwVpIiVooJ/gKqJO0ywHgI9cD6w/K1wSxzNFULFOnjQTg65zLGFkJLtEw0q4ifaTNEbtF7St1fT/Pe1cDL+iiaqYv+l5ENKQBHBm874CZqByZvRXRoWvZBCpQxWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIEcvc5T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIEcvc5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C671F000E9;
	Tue, 16 Jun 2026 16:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625945;
	bh=5S7Q+4Da8HjvmwIr/P4dKtc5KkSpTiLuIn+PmB5utsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GIEcvc5TNe0a/TAs/MPqdJbOZzRWrLEe1PYdxbJcMc7FQFdBjJhWnQc87VZtnPmlb
	 qvaP9RgGNhMRroaPTeJ/Rtlj1CHGyokZOfsV4m2WAoLkalp4QROtdZLYgxIjlgBdtj
	 7kATyB4Z6XtXKUlrD6l3t8akvBuMYfIeSxsMUexw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 237/325] net: airoha: Add NULL check for of_reserved_mem_lookup() in airoha_qdma_init_hfwd_queues()
Date: Tue, 16 Jun 2026 20:30:33 +0530
Message-ID: <20260616145110.247801033@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: ZhaoJinming <zhaojinming@uniontech.com>

commit f9f25118faa4dd2b6e3d14a03d123bbdbd59925d upstream.

of_reserved_mem_lookup() may return NULL if the reserved memory region
referenced by the "memory-region" phandle is not found in the reserved
memory table (e.g. due to a misconfigured DTS or a removed
memory-region node).  The current code dereferences the returned
pointer without checking for NULL, leading to a kernel NULL pointer
dereference at the following lines:

    dma_addr = rmem->base;                          // line 1156
    num_desc = div_u64(rmem->size, buf_size);       // line 1160

Add a NULL check after of_reserved_mem_lookup() and return -ENODEV if
the lookup fails, which is consistent with the existing error handling
for of_parse_phandle() failure in the same code block.

Fixes: 3a1ce9e3d01b ("net: airoha: Add the capability to allocate hwfd buffers via reserved-memory")
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -1172,6 +1172,9 @@ static int airoha_qdma_init_hfwd_queues(
 
 		rmem = of_reserved_mem_lookup(np);
 		of_node_put(np);
+		if (!rmem)
+			return -ENODEV;
+
 		dma_addr = rmem->base;
 		/* Compute the number of hw descriptors according to the
 		 * reserved memory size and the payload buffer size


