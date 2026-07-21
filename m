Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F4C223708;
	Tue, 21 Jul 2026 17:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654829; cv=none; b=kJ19CY2fQyDYDCRkK0lCYOKwE5EuNckmTj60da4Iv/luyHLPK1BcQ8aazjRSqgEwV5MOSoDz+Simjck/13cOdGJeYmC/GPI2hjg16e16kirQu158MGUrfOc448Mv6HORMRMneUTFgx7pwLpGgP5H2173HiaKLO9SXYpW4PWTSeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654829; c=relaxed/simple;
	bh=THSbkJeIraLYGPGMQvo9B84UPTz7+8N92rziHH+Gbno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzYAEsT2rNM3RwzsjJfV9Zl2Qai+Y6BUWwwr+MnC39va479YmfRTvznRD7IVtVaLBfMY/7ay/fhac8zf2JiGuC1lKxgcnOQ/ixXWU6RMxop32dupoqJIkd8ctT1158DdZUB/xpjTsmZKsDjvVnIFn97lESQr66ryQ5A90iepWJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DC3mOwv7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DC3mOwv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA301F000E9;
	Tue, 21 Jul 2026 17:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654828;
	bh=uzeRRcKYj1y73o28/GBC9+Ak4l6YWpOijn9XR/MGO5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DC3mOwv7jxCz6ked1WBwJL73i65mgtrFC1Hazkm70zcaZUxvAn8GCFog1sgzTNNDh
	 HnyoSgxF68xs715Ucg5dLgPhsk3sODr7AytmiDVfIDcrpbf/ihDkACM2nzsv8III6S
	 bhOuwGZzJz5qGszwyZ4WFa+70PT87JXO+ubtdtuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1854/2077] dm-integrity: fix leaking uninitialized kernel memory
Date: Tue, 21 Jul 2026 17:25:27 +0200
Message-ID: <20260721152636.463431665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2606,7 +2606,7 @@ skip_spinlock:
 			struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
 			const char *mem = integrity_kmap(ic, bv.bv_page);
 			if (ic->tag_size < ic->tuple_size)
-				memset(dio->integrity_payload + pos + ic->tag_size, 0, ic->tuple_size - ic->tuple_size);
+				memset(dio->integrity_payload + pos + ic->tag_size, 0, ic->tuple_size - ic->tag_size);
 			integrity_sector_checksum(ic, &dio->ahash_req, dio->bio_details.bi_iter.bi_sector, mem, bv.bv_offset, dio->integrity_payload + pos);
 			integrity_kunmap(ic, mem);
 			pos += ic->tuple_size;


