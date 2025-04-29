Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155B422A81D;
	Tue, 29 Apr 2025 17:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948763; cv=none; b=Kud8uPtwIZPhOh713Ml0EDnLonXNhTjf1tzDs1ZYtJ8nYKhAODK2ttu7jm36ilxob525IfzssvduEAwJmVqtmt/zmTDuQnewM8a+XZkn5HR7djongG4GFMxkLV30lvJfduEkzt3Wy1C3Hl14G/RQnasCi+SgN5hRyM5G0sqjWBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948763; c=relaxed/simple;
	bh=WuHjXtcXh8EBeDOGV7S0bpCiNSOFPBhUbwRD23J1/Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9gg9OIitXBKWVPwNSvjMHfR8OzaWRQiqXqnXfk02dAZ7fZnszW5Owd16r37H4vS4zOdVmdCPPVFq1SsV4tHtefRn44OJeePij/1UtKbH+PK14lvXtFDs8kRAPVP7BSY5EmC9W0KA7FDTcxFJURNdAcUCwd/+CEx4b7hUEmymTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rzq0Dyon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rzq0Dyon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364F8C4CEE3;
	Tue, 29 Apr 2025 17:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948762;
	bh=WuHjXtcXh8EBeDOGV7S0bpCiNSOFPBhUbwRD23J1/Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rzq0DyongzSBRh7lOmZP6U7jidifOloQ8/TVT+s+tuEXNBnrNRSBcFiDjmiB56Xr7
	 PZFPscEI5iwHzcV8GZ2V6eNBiLspdq6hieLzRbeG4nD9SDZ2awshSbyq/RaPcWUvoX
	 SsRtOD0Wsm83nzdVB3cd4Z3x+nj6gvrv3oOpsd68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 105/373] dm-integrity: set ti->error on memory allocation failure
Date: Tue, 29 Apr 2025 18:39:42 +0200
Message-ID: <20250429161127.475993992@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4454,16 +4454,19 @@ try_smaller_buffer:
 
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


