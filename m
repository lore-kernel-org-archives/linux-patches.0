Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBAF38910F;
	Tue, 21 Jul 2026 18:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658996; cv=none; b=DlFlq/eEaAJ0Z8YthhGxEbriUu8HuMBV10G72yV/KrlyXcknoG2AZj8rj8DvFDw4LLiYu/PvQv2lWyi7ZpzCuITqEb1Kw/4/1SLt6h3xknOrxzB8DIc3+Dc2r1HNSAL6C0vw876VKC/bobqNz6xGxlGx4B2U8NUumbOa/oj7VY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658996; c=relaxed/simple;
	bh=DhxpzmVjpASxB7WGQJceWRd0WJeBZcWwO8fZxVobJZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2OvumrE1jsilRTVJmNLxHDrYIwwg3r82XTuE9GBPHWIeUxKgqE8T1FXOza+vDKrm4uH1858RJfAD8pc1KgnPcw5wJrHvWopcqK4ECPIaLeGQZsfi6eCju49OuExvxALT3wo7OB4+4Y1TMBhdOCDSSfWSHQcFIiytD2KCxwi158=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WIniROV/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WIniROV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED1C1F000E9;
	Tue, 21 Jul 2026 18:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658994;
	bh=FSmYQaNTZY276vneDyUI+QwMS0ezY91LO+qxDzABe1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WIniROV/KMBePiZat6vCBvxyzMOz5tebzJZ1SsLo9z95FQEZU5fJZEGyy/4twPxpW
	 vNancy32WRUaoU9G4t6QMXXZ6cS/9vdn+hA+HW+TBVwp5KV/QddN51lYodVYInBxHz
	 n5Jottuc23S04x8V3BaNJM8Pq1UmJG1wKjVwIkS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 1355/1611] dm-integrity: fix leaking uninitialized kernel memory
Date: Tue, 21 Jul 2026 17:24:31 +0200
Message-ID: <20260721152545.934239356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 7bb03b2b01b814a9fc14afbfc2cbb2cca5b34750 upstream.

If hash size is less than device's tuple size, dm-integrity is supposed
to zero the remaining space. There was a bug in the code that zeroing
didn't work. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: fb0987682c62 ("dm-integrity: introduce the Inline mode")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2605,7 +2605,7 @@ skip_spinlock:
 			struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
 			const char *mem = integrity_kmap(ic, bv.bv_page);
 			if (ic->tag_size < ic->tuple_size)
-				memset(dio->integrity_payload + pos + ic->tag_size, 0, ic->tuple_size - ic->tuple_size);
+				memset(dio->integrity_payload + pos + ic->tag_size, 0, ic->tuple_size - ic->tag_size);
 			integrity_sector_checksum(ic, &dio->ahash_req, dio->bio_details.bi_iter.bi_sector, mem, bv.bv_offset, dio->integrity_payload + pos);
 			integrity_kunmap(ic, mem);
 			pos += ic->tuple_size;


