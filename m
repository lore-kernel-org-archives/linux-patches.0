Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A64225DCFA;
	Tue, 11 Mar 2025 15:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706964; cv=none; b=KhvAPSn80of3GBTHltYmc/qAdz2JhFuLh7XdVVmD+CQVAbiVOnBmTky7JkpaKbnwdkOPkvYGWFTrO7dMU8+NnmPrHIge7r/fkNlxT9xm6TdFsUPRHC84Q6lPMPjWQUxUEWZrTQDeqLLcsT2/8rRqQswjTkx3fP5jD2rtrsbbPhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706964; c=relaxed/simple;
	bh=lAmmVv3XdMEtAcqCkvN/o2/MFSTDUnSIb8abyR2vz1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buusgM+KiLImqGurKuKFVGiaIvIXH4soHMl0j4zAf6BkqnIc1Jo6JjI23CHrGPhg/aV8gdG0ytSBMhLZkCHcdxnYx/Ltjb8CFSx/A917ZY65ml0N+kEh3ltQKdcW5y1C4rklo7RQwyTjzSlWseg70QXosg8bXlMws4NLt7iMEd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0ucV9Xw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0ucV9Xw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220D1C4CEE9;
	Tue, 11 Mar 2025 15:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706964;
	bh=lAmmVv3XdMEtAcqCkvN/o2/MFSTDUnSIb8abyR2vz1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0ucV9XwD+8Q/FyOYTfUKauU4ij+pGA5CayVmKK+pxi3WI6WpdhdFb3jMp5jorTY0
	 fwXVQQKocaiaWFQvsdSWWJkHC0g0y06rTMSTIIxHk2yc0EGnE0+G/tDXCZ3L7oYSkj
	 lUM0n9PS953AILTqFyFrJMLRlSH15Nlu9T+g68kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jennifer Berringer <jberring@redhat.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.10 211/462] nvmem: core: improve range check for nvmem_cell_write()
Date: Tue, 11 Mar 2025 15:57:57 +0100
Message-ID: <20250311145806.698257779@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1362,6 +1362,8 @@ int nvmem_cell_write(struct nvmem_cell *
 		return -EINVAL;
 
 	if (cell->bit_offset || cell->nbits) {
+		if (len != BITS_TO_BYTES(cell->nbits) && len != cell->bytes)
+			return -EINVAL;
 		buf = nvmem_cell_prepare_write_buffer(cell, buf, len);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);


