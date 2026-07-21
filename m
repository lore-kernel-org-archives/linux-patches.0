Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC8A46A603;
	Tue, 21 Jul 2026 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649404; cv=none; b=I2/5n6ay6Pfj0IZXBnxfEApZT4tVwirfK9bNWu4Mvum2/yccBpcoSxivep7RyGp1gDsK3Pk34Wu/Omuj10Eq0+IbQt2PSjFW8vYCRnDgf8lFON1bVvJO/Yh++A20CTIp7i79gCVB6S6mjqA1CKhUVoWKp8h6x1NQJEX0OFvvajs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649404; c=relaxed/simple;
	bh=2OneiltJP+8GzP1pBoqkzxFVX30jsoZxdxpZLA5x9/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnjgcERdKv74cEMt9blPcS6yFzrutHKdlV7iYhxSJ77GHz7XGnXMBtVGgV/9TfvAzHw9cjGbb6YPHfrT4epExd4mMjHiOeYlkGCzDA8ufd7Pdhw7eVeyZG5FyuR+wLHU3DYhNRn4wydJjaqFIxnKfCrlVV/YKlTBE0dj6hFtg7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+wwBj7t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+wwBj7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6101F00A3F;
	Tue, 21 Jul 2026 15:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649403;
	bh=rwUPilOJNwn6r2j6Jmk/bUttQX5EZkGOOm1lcuHAxXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+wwBj7tJJKjDBZBxGCxSyQ4ndwGs6vTY8ySfdn62L+Ot07zQXxUP28+61gLZSy6D
	 LL1xHcnTjUQmqjRhd3hAGd49wmYqmT4LhwrT0gpduMsbl6FR4DGZV9yBAp6cLTiRcw
	 ycrLqfW04tfVBNR+hV2kMUqeSm/4ERDPcRe0cVLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0548/2077] ntfs: fix u16 truncation of restart-area length check
Date: Tue, 21 Jul 2026 17:03:41 +0200
Message-ID: <20260721152605.737460132@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 390936fb15053d8d8991ca3a22776e251a5a7f2f ]

ntfs_check_restart_area() validates that the $LogFile restart area and
its trailing log client record array fit within the system page size:

        u16 ra_ofs, ra_len, ca_ofs;
        ...
        ra_len = ca_ofs + le16_to_cpu(ra->log_clients) *
                        sizeof(struct log_client_record);
        if (ra_ofs + ra_len > le32_to_cpu(rp->system_page_size) || ...)
                return false;

ra_len is u16, but the right-hand side is computed in size_t
(sizeof(struct log_client_record) == 160). Both ca_ofs and log_clients
come straight from the on-disk restart area. With an on-disk
log_clients of 410 the product 410 * 160 = 65600; adding ca_ofs and
storing into the u16 ra_len truncates modulo 65536 (e.g. ca_ofs 64
gives ra_len 128), so the "fits in the page" check passes even though
the client array described by log_clients extends far beyond the page.

ntfs_check_log_client_array() then walks the array bounded only by the
on-disk log_clients count:

        cr = ca + idx;
        if (cr->prev_client != LOGFILE_NO_CLIENT) ...

For log_clients 410 it dereferences records up to ca + 409 * 160,
~64 KiB past the kvzalloc(system_page_size) restart-page buffer -- an
out-of-bounds read of attacker-controlled extent, reachable when a
crafted NTFS image is mounted (load_and_check_logfile() at mount time).
This is the in-kernel analogue of CVE-2022-30789, fixed in the ntfs-3g
userspace driver but never in this revived classic driver.

Compute the restart-area length in a u32 so the existing bounds check
rejects an over-large client array instead of being defeated by the
truncation. Widen ra_ofs and ca_ofs to u32 as well: both are loaded
from __le16 on-disk fields and every comparison already promotes to
int/size_t, so this changes no result and keeps the declaration uniform.

Fixes: 1e9ea7e04472 ("Revert "fs: Remove NTFS classic"")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/logfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/logfile.c b/fs/ntfs/logfile.c
index d3f25d8e29f9d2..9bc34572908efe 100644
--- a/fs/ntfs/logfile.c
+++ b/fs/ntfs/logfile.c
@@ -132,7 +132,7 @@ static bool ntfs_check_restart_area(struct inode *vi, struct restart_page_header
 {
 	u64 file_size;
 	struct restart_area *ra;
-	u16 ra_ofs, ra_len, ca_ofs;
+	u32 ra_ofs, ra_len, ca_ofs;
 	u8 fs_bits;
 
 	ntfs_debug("Entering.");
-- 
2.53.0



