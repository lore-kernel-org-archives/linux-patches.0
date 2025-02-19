Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3851D1EB195;
	Wed, 19 Feb 2025 09:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957227; cv=none; b=g0l+5J0+Mdcfq7oAwyVlfcWVSMPTt49/OR5v5rzwF6kI88rBeZlL5A/coAcQNc9Hvd24OtU5S6gb4eROrnjxeVzJzNLDUe+gRMJ16s4rSx+yqOYUeR56NaYgIq203WCfd+z44yC4+s+bjRtRKRDxrtpswG0SUxI6NjY+zeI6Fko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957227; c=relaxed/simple;
	bh=U+sNyKvIx0BPGGeLpmXzW0FRklVLXQ95kqzGNvQVTUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YebMbmLMdfAMSiYHxz3Kwpy9G2dzO4pr5i6XyQSKDXD01XhcK3IrgaqddH9K/UW7TpW9xPGspwVrZ+TMoeQe9xYD3Q3nAE5BqPaWRPrL4lwgB3L2wEImqWD+JxL5aCYYkp4U9XcdOhSKjH/13dd4RWRNp4Lfb70uHgLcpHM12Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qrz87Y7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qrz87Y7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9D9C4CEEA;
	Wed, 19 Feb 2025 09:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957226;
	bh=U+sNyKvIx0BPGGeLpmXzW0FRklVLXQ95kqzGNvQVTUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qrz87Y7o08nyqC+HSr5Bdafu5Wv+KfT+IY9tMMU0WlHEwroRAHDLg5/6Yp/OS1+Pm
	 Zu4ORmH1AsmFt7ya5L9ryEs5LSqNIld9OXtZExphClY4hJpibRUwKUcAIHfRKtYs8L
	 aqzn+30XEn5it6OdGJFMA9paSIerrh/TwZir6QiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jennifer Berringer <jberring@redhat.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.1 421/578] nvmem: core: improve range check for nvmem_cell_write()
Date: Wed, 19 Feb 2025 09:27:05 +0100
Message-ID: <20250219082709.578321019@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1532,6 +1532,8 @@ static int __nvmem_cell_entry_write(stru
 		return -EINVAL;
 
 	if (cell->bit_offset || cell->nbits) {
+		if (len != BITS_TO_BYTES(cell->nbits) && len != cell->bytes)
+			return -EINVAL;
 		buf = nvmem_cell_prepare_write_buffer(cell, buf, len);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);


