Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E372B26B091;
	Thu, 13 Feb 2025 15:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459873; cv=none; b=EIW+h/exCBqqC+JdsDrlEntRF3y9Na+RCYfQU2oOHN44PvKDw+aPDOoyorB54FQu0KPtQzK+1Oj+xDD7PeEeP0fEm5walgHp6fmTA4+E+qR0w3ksTQZx9Kc3GuYxxNhge7wpAffgSBltO80XgzaprhN5LiT3pp8fPtmQoLVR/ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459873; c=relaxed/simple;
	bh=bH2AOWBQEAicl357caICKCziehF7LwNqlqWTHtsd7EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/iVGbGaVEEnmCVY+JMvTqdsZA2F8YoGDnsFnP6oDJAQVLDqeX+3dGCpPABPpY1Unxdgtx9Vg/Z4pbEmcX86m5yRXkdK9IvmvPYqXz0YlUw1T77xb9iKoeeGIdlvhEP4D6shSrvgPBJao1MGX+CPG2Tw7OTuzbVQWQWqncgUiWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vu/skTaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vu/skTaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B978C4CED1;
	Thu, 13 Feb 2025 15:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459872;
	bh=bH2AOWBQEAicl357caICKCziehF7LwNqlqWTHtsd7EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vu/skTaBjuHY52UQteQXYEmP9rszaNYQKQwxCIWO0m+tsn1hkBrxRLguvMApfdA7o
	 Ftaw5qIKs/xWRldY0zYxdv3F1htmNnSw/8Gg4bpfTkBCd+rYSVC5LiNgW6LMldPceS
	 TnBkVFY7NugRiqs83RrHCMoBjZ8IKYz97PqwvOeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jennifer Berringer <jberring@redhat.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.13 389/443] nvmem: core: improve range check for nvmem_cell_write()
Date: Thu, 13 Feb 2025 15:29:14 +0100
Message-ID: <20250213142455.620693090@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1790,6 +1790,8 @@ static int __nvmem_cell_entry_write(stru
 		return -EINVAL;
 
 	if (cell->bit_offset || cell->nbits) {
+		if (len != BITS_TO_BYTES(cell->nbits) && len != cell->bytes)
+			return -EINVAL;
 		buf = nvmem_cell_prepare_write_buffer(cell, buf, len);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);


