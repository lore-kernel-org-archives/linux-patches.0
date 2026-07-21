Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3492D3749F0;
	Tue, 21 Jul 2026 21:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668503; cv=none; b=QcSE9IcZ4IQ4fpgqA+efO71T/M4KTfvglMqmGxWAz5dKUyhJij4uygSb19QL0I4vgT+HWC1Zq8ft8StOFiC5bAYKO6M8t1cmdphIbI0g3OW2hiS0504JCAPIStTCsxVJ+94T1JmY5YMVYBJarWl9oVEwjtlhsEEVz3DZFHPk9J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668503; c=relaxed/simple;
	bh=AayL3sgsH/iXt/k0Hu8xWuRYhfppIIgFDT6KxZ5AjRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLoaKUeLYyUEXL97na2S414FR7EL/hXZ5V3RG+mycWLbbW1dYLKMwmGQl/Q6uc0Z2YKpnaCnrTp0gzb4W8rWn+ygxM7hgXuvq5sv/g7w+BNxehNvfqTZhuXC+MmmJz296G2Fbnnx7tTna6P2w2FT4QUiD9cJXz6OvFNKuVVa5/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jc3yanWh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jc3yanWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A5D1F000E9;
	Tue, 21 Jul 2026 21:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668502;
	bh=N16trzPMrBwl934Zp0+QJtPzOM3aWNobYapt3dY7fwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jc3yanWhg7paUHgsKZaisnTTYmPh15anGszcrfawp1Z49XA+iXuEvevwNu/5U62BD
	 W093HC4KEvJJAfmYk6nRMUvJxcDJYTDKb08u63RX30vZDnZIPihMlvqoLbsEtD1Z5F
	 4NCWgDmyqkarTHkPpxBdVCAG157aX1kdgvEVWEvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.1 0201/1067] udf: validate VAT header length against the VAT inode size
Date: Tue, 21 Jul 2026 17:13:22 +0200
Message-ID: <20260721152429.089647560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1233,6 +1233,14 @@ static int udf_load_vat(struct super_blo
 
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


