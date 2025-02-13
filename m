Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D0C14A605;
	Thu, 13 Feb 2025 15:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460818; cv=none; b=nDfCqKcxLp52A6Kzl+PuMzxdNQcOSrf3hrh/ZaEv0Tzqtheu+ScWgMdf/dwOq2tJd3zcL8e1M48qCqJOd99z0KXxghMYXQdvem3C1GHTjpMLJ5qXRRIdllGxyMwesionmMfqtPEcU6KrhwfsYD0ExvILiZyIU+JtTxjRYaVDFiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460818; c=relaxed/simple;
	bh=+NLJm0nmJ7U3qpVbXyLsbUnd8s0C29aCuVjEgaXUg7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjQyWOYFBtVPz7O4jmrMmseoKx9dSA+5HIlA2TUzdpKh7amPexPDVKg9HITq66v4mHupNJ0LrjV3Z2VLHaPbO/mVNPSsi2n6pdHKdkNuHCSFDesuyqPW+1VkNMcxxcvX2npJAC/IwWEvsO6ALNz3Eq4jaYXY+MM4upyK5F1OmQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lmm7v5IH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lmm7v5IH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167AFC4CED1;
	Thu, 13 Feb 2025 15:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460818;
	bh=+NLJm0nmJ7U3qpVbXyLsbUnd8s0C29aCuVjEgaXUg7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lmm7v5IHG07yyp87XARC532Vsu/v6Y5xtyQeGpnpCCrwZu0/0jeCRoUujp99RjL6M
	 Cp2XKoM8LOWXFTUvBNM2qAZ/DtmQlqM3KBJt/G3UAfvr33TE5oDxS+3bxQr+m2zxk6
	 q2Y8NfT29aUYUdYWvXgO6vFn2nsqvVDhGNwye+hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jennifer Berringer <jberring@redhat.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.6 222/273] nvmem: core: improve range check for nvmem_cell_write()
Date: Thu, 13 Feb 2025 15:29:54 +0100
Message-ID: <20250213142416.085107306@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jennifer Berringer <jberring@redhat.com>

commit 31507fc2ad36e0071751a710449db19c85d82a7f upstream.

When __nvmem_cell_entry_write() is called for an nvmem cell that does
not need bit shifting, it requires that the len parameter exactly
matches the nvmem cell size. However, when the nvmem cell has a nonzero
bit_offset, it was skipping this check.

Accepting values of len larger than the cell size results in
nvmem_cell_prepare_write_buffer() trying to write past the end of a heap
buffer that it allocates. Add a check to avoid that problem and instead
return -EINVAL when len doesn't match the number of bits expected by the
nvmem cell when bit_offset is nonzero.

This check uses cell->nbits in order to allow providing the smaller size
to cells that are shifted into another byte by bit_offset. For example,
a cell with nbits=8 and nonzero bit_offset would have bytes=2 but should
accept a 1-byte write here, although no current callers depend on this.

Fixes: 69aba7948cbe ("nvmem: Add a simple NVMEM framework for consumers")
Cc: stable@vger.kernel.org
Signed-off-by: Jennifer Berringer <jberring@redhat.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20241230141901.263976-7-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -1725,6 +1725,8 @@ static int __nvmem_cell_entry_write(stru
 		return -EINVAL;
 
 	if (cell->bit_offset || cell->nbits) {
+		if (len != BITS_TO_BYTES(cell->nbits) && len != cell->bytes)
+			return -EINVAL;
 		buf = nvmem_cell_prepare_write_buffer(cell, buf, len);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);


