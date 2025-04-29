Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BDA21883E;
	Tue, 29 Apr 2025 17:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946848; cv=none; b=GBT6z4xWJGw3Z6bBQ6m+H5ECXXKyy1AqTyCOuLn0p0jW45zgGTWkUNNllw96jfOP12f0syC9+suwlHkhsx2TNEBS36JNLFJCxIJeL7kkqh8HiJEc3naXkgzu30LtqG+Ii9MKH9hV/NWg78EcJGYrERxsk9voK1Lv3cFInehUd8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946848; c=relaxed/simple;
	bh=TVRBFxDn0boLERJyecGKXQOA9QSWhJdE9K6+KqZDZ0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/iaQbrIf1eF6ufJqmW3pi/X8NDLTtemxKUqCaKWAHTV+r+EhbIo9d5oFN9XZ6EfJF5NajMKJFqAQIttd84SSk3DUZeODU5q9ZHxuwY4YEH5LNcPUTLw6egdTscW6eFu3Dd2j+L02jsMUHaXl2X3y+Mdjk+64pP4so0rKRxfbts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7Nlcy9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7Nlcy9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62926C4CEE3;
	Tue, 29 Apr 2025 17:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946847;
	bh=TVRBFxDn0boLERJyecGKXQOA9QSWhJdE9K6+KqZDZ0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7Nlcy9H+hQDZshU41hCFr9+msEpixgNXZz+98yQL+PIVCjOeWba7kW6miFpvvHJl
	 +BxZASh9/9IR+sgpkco1FLR1EFRY6lPTfG8LhRUHorDHQbhTOQfWQ4Tl3eFShyucBR
	 vVEWhBeXPOK7z6eXxx2D1mJE+szRf+2Uqsy7qews=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 088/286] dm-integrity: set ti->error on memory allocation failure
Date: Tue, 29 Apr 2025 18:39:52 +0200
Message-ID: <20250429161111.480596183@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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
@@ -4303,16 +4303,19 @@ try_smaller_buffer:
 
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


