Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DF7253B7B;
	Thu, 17 Apr 2025 18:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913592; cv=none; b=UQwBJeVBXYt0fkdd80ub/lFOBmkzHPTv0/nLk2r9LRj0BBKRlJGHCSQt6ptjHh4ee1SCef12J8ZtJ8Xt5KKceE1bVuO/X9lSVeOMemjXHRy4wNYEA3dL7MWaacSFNB2uBfhxoP0l4CD3jYGGWfmUPZw8AROKf6WHsSBiNHGOJOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913592; c=relaxed/simple;
	bh=y2eTJfyq7ksrbZI4VuFRAdozoADODSv+Fcf6vAAyRzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJtRis5ME1jMXisTa4TKLunGVdkEqB99ZuIpPfp15oRg8bWnma9a6WeG7986JFEVOdeZctAt3RIqtGVC9JIBWPDhgBjnXQtdmt26o4BHG0dZcCIpGCFpcYOgfviL2KrYcYpUYya7RD+hgrLpeZvBAOPRDOOsp4zaDlG9p2tobsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4HCjsHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4HCjsHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FF1C4CEE4;
	Thu, 17 Apr 2025 18:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913591;
	bh=y2eTJfyq7ksrbZI4VuFRAdozoADODSv+Fcf6vAAyRzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4HCjsHQjWdXA9KUngiT3PNKoiWQthAjYDYdw6ZfzYkjRUjKmKaacgqL23Rr+2SlR
	 ntkTPKl2lDXL4T1vR3UwA5CrnRlTbKGdZ+QrKmPnIE/dkMh4RJn1YiU+WCiMDnDl5h
	 U+OSV+R8WkQPwDE+kjXJPQ1LcwW0Ddo4wseuXjbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.14 388/449] dm-integrity: set ti->error on memory allocation failure
Date: Thu, 17 Apr 2025 19:51:16 +0200
Message-ID: <20250417175133.882344996@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5084,16 +5084,19 @@ try_smaller_buffer:
 
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


