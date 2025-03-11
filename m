Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C31225DCE3;
	Tue, 11 Mar 2025 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705772; cv=none; b=Wzc2qsfpRA5bCfFSQvMu+y0bW0W4EbzwLTJr/FMeSk8Z1VsIuqktO17y+oZFHJ2cXBQOLC7ceFo0xwV6MCPzgZU+CaGM0ezLT8596thdfRUmTUr1t38/oUk03RpuM52o56O0vHBxXje5j/SbpJkzxExur+9oGl/ECXgOKEawHhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705772; c=relaxed/simple;
	bh=4vKpUhsk54IdKvZSdzYScGOoZlGtlfsr635KVWhV6ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBlgdKvK/eC6OUOoBQnI+nBGTsyyvX4mtQrqK7PQ+WpCzWTs/Gfpq+fkZAmT3NrXY5wWw1ltz/hFOzZIsa1MJ3+cpWlKRfJ6vfL9RTXGOjF69plJYnLNHSZVCoacgeMZAMB/ilgyY5rK60fMz5Q2XrdecrlCrux4BwN9dPiRan8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrgUh3Wq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrgUh3Wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8237AC4CEEA;
	Tue, 11 Mar 2025 15:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705771;
	bh=4vKpUhsk54IdKvZSdzYScGOoZlGtlfsr635KVWhV6ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrgUh3WqqM3Jx0ZCqORExgXxb4wTzxojfXPCDwnkFEkMBRxckkMhRqvnXQgFKEFuZ
	 mxQCrCZ87Si0/z/WWS1ksi7x7IcqOgUtQbPRaW2rGYGpBJAHyWtOl8f25caM82Ip8Q
	 lCSNLbwKMyYRaXdpZteDeTo7zOdEj01oMWZ9avEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jennifer Berringer <jberring@redhat.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.4 150/328] nvmem: core: improve range check for nvmem_cell_write()
Date: Tue, 11 Mar 2025 15:58:40 +0100
Message-ID: <20250311145720.867643977@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1083,6 +1083,8 @@ int nvmem_cell_write(struct nvmem_cell *
 		return -EINVAL;
 
 	if (cell->bit_offset || cell->nbits) {
+		if (len != BITS_TO_BYTES(cell->nbits) && len != cell->bytes)
+			return -EINVAL;
 		buf = nvmem_cell_prepare_write_buffer(cell, buf, len);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);


