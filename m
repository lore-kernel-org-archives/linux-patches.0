Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD9C41F37E;
	Thu, 16 Jul 2026 14:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211300; cv=none; b=kIDXb855lK0olirlD9CPTOwcwV2IoHocUjD/kVKWmEeM2IXubnjdlqk6kUOOAkXPdwhYQiIqra0NXllbLCDZMD86EFsjI/iRj6i+vQ52gwx3IMwSjlbKiNN/yIR20gKp7JC7GSCOKvFUpdybD7qVldag+Z7FsyyRXqfH0lmuw5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211300; c=relaxed/simple;
	bh=CrVmpQ68d1595JPTzWDbb0glpMc/5LQmd/dy6pM6Ndg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODTIgD48ZodUAkC4Ymuqn5hzScpweWxYvFEm65TCBr9VSY2yLw4l/L5o2m958Lx870+kpYDrT77+f8DJPZijXfBoHf5YRojuq6VeWcB+OEd1GfF+gVfvjr1tV+ocosP8H0U00UA7WdvJ0JOaSJGvg+irmLQ66Q63o6H5GIK8FsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivJdcaLu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivJdcaLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728FE1F000E9;
	Thu, 16 Jul 2026 14:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211298;
	bh=csX1SUxIEgduYzxjDhXZhDoeRTOWMn69uchJPIgxyGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ivJdcaLuFI/CnkccXpj+uvS4R/GHTb+CqHWcJi62jXDNQDTvS991K2BwjYCUZnxSN
	 qi376daITxBxkfHbDjgLgdIqO4YuxViQGZaC2wXruyrgM7xAzH83vs5VSTrhEv6PBf
	 DL3U00xQVpKPINgj6aBhvFf6ZNbvE4QDzr+fFjuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.18 332/480] udf: validate VAT header length against the VAT inode size
Date: Thu, 16 Jul 2026 15:31:19 +0200
Message-ID: <20260716133051.996649093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -1263,6 +1263,14 @@ static int udf_load_vat(struct super_blo
 
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


