Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1624624C098;
	Tue, 29 Apr 2025 16:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945313; cv=none; b=fS0tlJu109sSOcy7n/4avX8+zYsB8uXLTvVYYu4g715aTMU1Dx37rMZ8UN+Useh9j+SQiJJc7udYGsIM1hr4UgxnZlercGrO1Rau5c7SXf+faUSS/NvDMx5wXnLkJUp0KciCTi0pVK+D5SmP+YYOyWrmlxLU1m7Y9MOcPfPNZto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945313; c=relaxed/simple;
	bh=sWXuxyoUlVCvKyQbOy3mT3jqte2MmoBSsymGGwWvRzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxiTSLpiHg0Y7zErVAJd/vwJ3c5+AJote7PWDwC0lC9zxPWa6bKtHEKStBTQ65+mPWjBVYhlIE/YsBdyVKJuT8gkAVJ+bvo6wOjb1lgzbSK70hgu54QjFwmreTNuEDIv3OELMyOkjUHXPf+YcdhzLtO6klAMeKSDVnYw6HdRAWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuZyLFdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuZyLFdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1852FC4CEE9;
	Tue, 29 Apr 2025 16:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945312;
	bh=sWXuxyoUlVCvKyQbOy3mT3jqte2MmoBSsymGGwWvRzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuZyLFdL83k2jrkSjHgRL2+bjwlF3ffhlHWa+oIhQJn6yNWW/STu8vGFhh6/MgDFG
	 PRaD/+nB0C51UXqcRl4nbl3xpMOaLcqMyRHhhI42IXfyFHoVjb+HssO2GM9+4PHZsw
	 Mn5q8mSECUGzDaUOqWcbsXusW8KRyOU7eZLBRUyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.4 071/179] dm-integrity: set ti->error on memory allocation failure
Date: Tue, 29 Apr 2025 18:40:12 +0200
Message-ID: <20250429161052.289727756@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 00204ae3d6712ee053353920e3ce2b00c35ef75b upstream.

The dm-integrity target didn't set the error string when memory
allocation failed. This patch fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4112,16 +4112,19 @@ try_smaller_buffer:
 
 		ic->recalc_bitmap = dm_integrity_alloc_page_list(n_bitmap_pages);
 		if (!ic->recalc_bitmap) {
+			ti->error = "Could not allocate memory for bitmap";
 			r = -ENOMEM;
 			goto bad;
 		}
 		ic->may_write_bitmap = dm_integrity_alloc_page_list(n_bitmap_pages);
 		if (!ic->may_write_bitmap) {
+			ti->error = "Could not allocate memory for bitmap";
 			r = -ENOMEM;
 			goto bad;
 		}
 		ic->bbs = kvmalloc_array(ic->n_bitmap_blocks, sizeof(struct bitmap_block_status), GFP_KERNEL);
 		if (!ic->bbs) {
+			ti->error = "Could not allocate memory for bitmap";
 			r = -ENOMEM;
 			goto bad;
 		}


