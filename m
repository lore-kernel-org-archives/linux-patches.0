Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA6B28BA96;
	Wed, 23 Apr 2025 15:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421868; cv=none; b=kbWNmLq7cbYysWWCO8AbtGCvb1Uj+wiwmrsLHelYpxVSOPj5QMPKaYR4cI+/9oc5an61BGFE801iMJJ8ctOIpPDpz1PIH4VC1sa/EAw77opbjWQyV3TZjtj/O1isk/kLl1kcY4WDBX1mRZEgudgwFOndw5ZYh2pSkB+y7gSc1js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421868; c=relaxed/simple;
	bh=+0x6RgaxjW5XoiKparXPqEUer7kLwkq7/+ek2hPwR14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5vB0ibg0qFnMh3OqR0ww8c8JxBu0H7BYSsIqn85oKEsDpWgrwIyyq3njXg9TbKvcLFd1AqOrPQFw2D2sOzA8tEp3hLeqUGYf02+Q+tPM0Mi6DWlwOke6wOkQ1Fj14tC3IalsEIiMIrlVeEXpmwkldTr9FKXo5SSUH+kvfQcJvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFCdFu2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFCdFu2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12442C4CEE2;
	Wed, 23 Apr 2025 15:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421868;
	bh=+0x6RgaxjW5XoiKparXPqEUer7kLwkq7/+ek2hPwR14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFCdFu2PHoxYqkCyT/HYV8aKklUPmEFPZiZ3DcwozJmdZYEeBiB693qK6iBhYAhbQ
	 8nZycQEsxhCmynGCFi9W3n/GYYfbw8mc1AXKb4ff3/ty9LGnkw9fiSFE/oYLcZxbnx
	 HRstWLg3EBYWaBXDsLDfDikM6dJJECmZS+D/eweE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 210/393] dm-integrity: set ti->error on memory allocation failure
Date: Wed, 23 Apr 2025 16:41:46 +0200
Message-ID: <20250423142652.059474036@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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
@@ -4594,16 +4594,19 @@ try_smaller_buffer:
 
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


