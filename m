Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF83633065C;
	Thu, 16 Jul 2026 13:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209855; cv=none; b=jGU8pPeFf956wyISfAk40NqeUhIUTXuE73oRWcgqZeqFAIuWHLnAMVvTMUGMk6CtUaKtcbiGcdGB10sCmOKssS5F31iZ042Cz9x5yLSkfUDJ8C2G1fqJ2vX6/Q7KAYV+hcIM+fmFefu+F5Exv8mhXDreZwxU6Y6vfZL5xIDyJiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209855; c=relaxed/simple;
	bh=CZn8Z2Osr28NDrTaA963K1Mao+SGr2ldeB+0pfnpIJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Toj7JMTdzjg8vgtEyEAACmdjor6UknZakhRUCaOW8ExeyEDWMkgS14fZ71OcVIUu6Cdu14i4MiqPH14sqf9PpfUUz/8snlbDmoYs+e9SfD6aP37dQ4I289tpqFCeHI6i9xXvIsQVxeAL+9A/DxoXKmowPy1HFj3pPMLU8JSRSyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hua8PHO7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hua8PHO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB9F1F000E9;
	Thu, 16 Jul 2026 13:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209854;
	bh=ppbRnNQTGzZJlCl/xCZgNov28p+pimjZ4RJaBsW1ufw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hua8PHO7aQCE9VFWI0MRdeNz69aH6y6iuM7UO9+AigqTnilBst9krNagV2NKC+bQI
	 y8PsqcUKqCybz5PRQ43p4Ho3AhdjFX7HeusN4QIvj+CVLvxYBPZX/NLbVVwtRVXne3
	 pzVxU8gu0qXeHnNJm1HO6EZCFY1EDE7ZQ5dmYmi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 7.1 343/518] udf: validate VAT header length against the VAT inode size
Date: Thu, 16 Jul 2026 15:30:11 +0200
Message-ID: <20260716133055.324166214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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


