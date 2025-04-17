Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFDA264630;
	Thu, 17 Apr 2025 18:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914861; cv=none; b=ILT979BmkgPzW9QIB/gctM7ntZpA3DPSDJkiqtYryyuavxAnIhsZ55kInad8HVF4XdKtP2d6oipiAElqVcKl2WMHQD1naCJUpHTLjRFP2Pz2MSbfMFcnC/hmNQ7ijKmDrF0Lj1f5ZHM4H7VZXhDNB4nZ5nitLlu1QM2dsB3xbOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914861; c=relaxed/simple;
	bh=dae+mgDISWfSWAhCFAaVi0qdpCFqJ3JW5Ez2wHFBYy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q44AZO+ElaL38ONh3iAUQ8cRk0UZXBasuFAT+c6pY3lCpMidKxg3OQ/jC98MR9F508xU+6gevgrK69mlqSAT5667TBMaEcXFW9JXubP86i0tDJikLbvYGxdWwASof+3gbPiR62boy3DIh1saI1YLPm5az4AYYnvAogzofNA05MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLBsESN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLBsESN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBE3C4CEE4;
	Thu, 17 Apr 2025 18:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914857;
	bh=dae+mgDISWfSWAhCFAaVi0qdpCFqJ3JW5Ez2wHFBYy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLBsESN6qFFuqTufbU4dae0gHU6KYv97LwhoLe+N0LgGzBESCODaWoEeXJTbZKqVi
	 v4kRLf8hduWyFy5qYxMQA/fPn6S8BCTOXg8yjb9TZjXXCeGDgWQi/A9OwYOfwjVkBJ
	 2pItFSbWY51PeTcgRsTed/JTd4fyxMoae9FlLxP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.13 354/414] dm-integrity: set ti->error on memory allocation failure
Date: Thu, 17 Apr 2025 19:51:52 +0200
Message-ID: <20250417175125.691518181@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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
@@ -5081,16 +5081,19 @@ try_smaller_buffer:
 
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


