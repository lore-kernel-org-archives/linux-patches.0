Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30493202C3A;
	Thu, 13 Feb 2025 14:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458277; cv=none; b=qcKx2XaGtrPi99Bgbn5EDVRTEs0Ph7xDmdkwFmaAqK5K285cXPEljJfXLQJsANrby3fTkYtk9K6eIkaHZdKzf+jNQByA3OAnuOaHddWdRmea/3GI5kEO27ZbeQhKH2umBv2nc1iZBLoUPcKOaIvzw/WC6m+0lf4aDW/3NWBlB1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458277; c=relaxed/simple;
	bh=fGCY5YH9/X/hwzNgdw3GMrj1BRPixBR1s8pScvqrQb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prH/I4reGxD9CeazceyYzBiXq7eGu7JCAhndc27Lcmso6CDCoXBemBuYTGcYY/auiQBpWcN38XhgJ+HemwjgCSYB7XDHells/vsZ59aM7lV1ZY8JPgnsJohwpcbATr4TNSURgiGTdVQPPxxYRlHHWc/9w6beAczh7bIXbYKQOnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWTfg9pV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWTfg9pV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1C4C4CED1;
	Thu, 13 Feb 2025 14:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458277;
	bh=fGCY5YH9/X/hwzNgdw3GMrj1BRPixBR1s8pScvqrQb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWTfg9pVRs5nigLXLrNLqeqpmJl0BQua0v6mTVcMuYiB9ABDTHJfp9MGJjLLaREBL
	 V/TMXTp12A/VLCn+YwkENktCQVBbfmgT0j6+Vz2cBt+jE2hpVt15lXKnuoxEmiTyNo
	 A8XsNFpuR45mf1J3eujyT/IixO+Zys1CIiFAnP2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jennifer Berringer <jberring@redhat.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.12 352/422] nvmem: core: improve range check for nvmem_cell_write()
Date: Thu, 13 Feb 2025 15:28:21 +0100
Message-ID: <20250213142450.137021106@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1780,6 +1780,8 @@ static int __nvmem_cell_entry_write(stru
 		return -EINVAL;
 
 	if (cell->bit_offset || cell->nbits) {
+		if (len != BITS_TO_BYTES(cell->nbits) && len != cell->bytes)
+			return -EINVAL;
 		buf = nvmem_cell_prepare_write_buffer(cell, buf, len);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);


