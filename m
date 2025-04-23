Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFEB2BD580;
	Wed, 23 Apr 2025 15:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421501; cv=none; b=C8uEFrxaxvrp7OsnwTLAnNFPshT/yfgtnDNRJrpRgzQKfaV/cgtQkWkFmtAnvnq9Gx6psZBbs6E3kbMMZcoCJ2322RTGa37xpQz4vWDjX2MxQB7OBjPAtq2lyj6+bvuZ1LWEhgnkpeYckp318dNvi2WXK/czW0NycMxPlNuGOI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421501; c=relaxed/simple;
	bh=6BQ3Kyyvvrd/i/fSW9VSkAsWA4QTtMhq4nMlgPF+VBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqgTg5V5hAX6WLujJrA3ZN2+4is96nlEtCtnCQc0RgbBSNjmu6ZvtfwTmjp1OTk0M/JOXlUiu0RclPs12tULKlvpeQKNGRH/0LDsZGf/Xm0VCDHW/g8KP3nxbsigcHrWtYhmTcEwIiTo38QJhoQtw4WWilhxkSRCsiK1yR0Xr1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaCwFlqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaCwFlqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F0CC4CEE2;
	Wed, 23 Apr 2025 15:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421497;
	bh=6BQ3Kyyvvrd/i/fSW9VSkAsWA4QTtMhq4nMlgPF+VBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaCwFlqwyO8F/q/8l8MtmsNtcDtWh21FSCTRj57gr6YgtOzDQptVugL1RtSg9Plre
	 7e+PPuW8hqx4c9PPGKqqG3fU8AkgBiCBiWglpDRwTpUU++GyGj7lAxHCkqwn2AFqm6
	 US5aQbZbiEf+URDdkwi1d0G1uCRnKp7mJ8Z5O8HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 143/291] dm-integrity: set ti->error on memory allocation failure
Date: Wed, 23 Apr 2025 16:42:12 +0200
Message-ID: <20250423142630.251045439@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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
@@ -4546,16 +4546,19 @@ try_smaller_buffer:
 
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


