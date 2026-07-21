Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24ED83C1081;
	Tue, 21 Jul 2026 22:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671206; cv=none; b=XRq4HJThfGISEYZw79p1oGxKJpv3Z9/B6Bvya3EhDAKLcAhLSfH/AokMXYbwEFrpBjzJfqxff74oiShZiIi9yuaJ6VVugRXjpGOVmtpRIq9dPKV20clzcBlP35mrI3mil/1e1KD97ZPu8ozQt7zY02X19PMFKm9fRIMNnoKiuwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671206; c=relaxed/simple;
	bh=vcv8iMrTbmnrTUZ93q9KH3FTiDGORsenHfjltxn2USk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiEuUkp0hZihblLFT8NBNuHr9puuo0ED8NQ8/xpU3xVQgnBuAPIgvgR5tJw+NXtoMl67B6UMXWs2TEnp99yL1XDvCfTPd5f9aTts8NIQZpIRn+OPGbyjB1cxBNFg6/+OvdBLiTerEwT82YDVlBN6j/j1pv57EF/rY96Zq3mIRb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egFqaggy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egFqaggy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B175D1F000E9;
	Tue, 21 Jul 2026 22:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671205;
	bh=FII8CpyXZB5BvFjYrPaJ6sOEChzIFyi1xhj1yv9NYDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=egFqaggyaCdhgB1onhFxBLbaxCDX1lkwfPEwzy7nIpTUjHo8A+1TMIl92kT8/vDl+
	 VaX5/X29Uwi2qBgwBDW+FwCfN+koc/JYBjQPif8Edv5NY10c5R/lsUPs1ooO4pq22k
	 6N4fUkEM4pNv/uvuq/LPdgW6ODLmsPJ95/lkKEg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.15 157/843] udf: validate VAT header length against the VAT inode size
Date: Tue, 21 Jul 2026 17:16:32 +0200
Message-ID: <20260721152409.545914749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit d8202786b3d75125c84ebc4de6d946f92fde0ee8 upstream.

udf_load_vat() takes the virtual partition's start offset straight from
the on-disk VAT 2.0 header without checking it against the VAT inode
size:

	map->s_type_specific.s_virtual.s_start_offset =
		le16_to_cpu(vat20->lengthHeader);
	map->s_type_specific.s_virtual.s_num_entries =
		(sbi->s_vat_inode->i_size -
			map->s_type_specific.s_virtual.s_start_offset) >> 2;

lengthHeader is a fully attacker-controlled 16-bit value.  If it exceeds
the VAT inode size, the s_num_entries subtraction underflows to a huge
count, which defeats the "block > s_num_entries" bound in
udf_get_pblock_virt15(); and on the ICB-inline path that function reads

	((__le32 *)(iinfo->i_data + s_start_offset))[block]

so a large s_start_offset indexes past the inode's in-ICB data.  Mounting
a crafted UDF image with a virtual (VAT) partition then triggers an
out-of-bounds read.

Reject a VAT whose header length does not leave room for at least one
entry within the VAT inode.

Fixes: fa5e08156335 ("udf: Handle VAT packed inside inode properly")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260612-b4-disp-9a2317ee-v1-1-fefef5736154@proton.me
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1234,6 +1234,14 @@ static int udf_load_vat(struct super_blo
 
 		map->s_type_specific.s_virtual.s_start_offset =
 			le16_to_cpu(vat20->lengthHeader);
+		if (map->s_type_specific.s_virtual.s_start_offset
+		    > sbi->s_vat_inode->i_size) {
+			udf_err(sb, "Corrupted VAT header length %u (VAT inode size %lld)\n",
+				map->s_type_specific.s_virtual.s_start_offset,
+				sbi->s_vat_inode->i_size);
+			brelse(bh);
+			return -EFSCORRUPTED;
+		}
 		map->s_type_specific.s_virtual.s_num_entries =
 			(sbi->s_vat_inode->i_size -
 				map->s_type_specific.s_virtual.


