Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620849;
	b=vmrRmKZ/0JKaIe1SgeGq0J6M0urL8ddx2VDxcbiqTpNlwwSe/plWL40XIFaOXLzn6z/5
	 uWqUYMDaEJSdHssgCyY5kqGTRoFA37F6N2ZNVxKgOrziqwPGchMfT13/7xVyJkPRLuXUr
	 AcQrO+WKLkU8OHuC1Zh3qLfJFA4cQ6urUJDndO9TPW/2YFH0rFAq3LcYDsEe63A7LIpys
	 W1qCK+Z/w2wt9djT72IQVPXOFtmWwa1fsVq3YKgWD9FXlD26cEcbzWfl1p8bIiVbLZN69
	 YPDTDeKc+aRv5yLeJw684saohEAyUeH1XUB3SA7KGabayoztqhqT6excDApBguW6MLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nRIDe9pIFdx5sCm2ma2Zs/B78a79QN8gdimRMJeus40=;
	b=cwkvnbb6uWLbXDoVl45v+ZJmj/QsXXIoqnYZLDNBmJ9wLQ6zpe6detJuAev3vJryWNYp
	 zGRrR8xwRZYBXMaSyI4/bPijnoGfZZDcCIJn93PXOui8P75hkKo6LRK5YrgbRlrJUfYuM
	 2FE6hzTWjHzsGu71j14qoJaaDncOHilSN8GZInHBZe/FaSFBA246kypNNqSoBQrdUhKJ+
	 mjanQikTRYyf+SvFnt3pvaFxAAakfG9PH8PnxaQ0/oVW9Ui/DaZkvkC02oD3xhkLhZF0Y
	 gayYlSDIIAuBRW34PWt6mckckt8jRNmSVSEcLJnTJFrj3eDTSqgAxtr5wroGfnKTMvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Tdiob8q/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1824C606A31E;
	Wed, 25 Nov 2026 15:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tdiob8q/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6791F000C4;
	Wed, 25 Nov 2026 15:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620848;
	bh=nRIDe9pIFdx5sCm2ma2Zs/B78a79QN8gdimRMJeus40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tdiob8q/NiMWdab0KCJvEh2x6Ltp+6D8ocE5tw8JgPjwa1BWFkay2dAs/21Pzgrbh
	 ms+27zlTKZRssLP9rXg5dnrpzIpls72vBVpRD20c3/n9B8quBOUYIBPWzrzRAK25LH
	 dXIiUXf2WlDQFBI3so5GJeuqbTLwmtOWBxf7ipXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 042/990] udf: validate vat20->lengthHeader and VAT inode size in udf_load_vat()
Date: Wed, 25 Nov 2026 15:23:29 +0100
Message-ID: <20261125143823.076370929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

[ Upstream commit 49f771d14578733a350c45e34e1bc6ad14f56952 ]

In udf_load_vat() (fs/udf/super.c), validate that vat20->lengthHeader is
at least sizeof(struct virtualAllocationTable20) and does not exceed the
mapped buffer or VAT inode size so computing the VAT table pointer and
entry count cannot underflow or read out of bounds.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://patch.msgid.link/20260919222600.3793513-1-benquike@gmail.com
Signed-off-by: Hui Peng <benquike@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index ea9cd593ffbbb..09905f6c9ee1c 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1328,6 +1328,12 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 			(sbi->s_vat_inode->i_size - 36) >> 2;
 	} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
 		vati = UDF_I(sbi->s_vat_inode);
+		if (sbi->s_vat_inode->i_size <
+		    sizeof(struct virtualAllocationTable20)) {
+			udf_err(sb, "Too short VAT inode size %lld\n",
+				sbi->s_vat_inode->i_size);
+			return -EFSCORRUPTED;
+		}
 		if (vati->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
 			int err = 0;
 
@@ -1345,8 +1351,12 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 
 		map->s_type_specific.s_virtual.s_start_offset =
 			le16_to_cpu(vat20->lengthHeader);
-		if (map->s_type_specific.s_virtual.s_start_offset
-		    > sbi->s_vat_inode->i_size) {
+		if (map->s_type_specific.s_virtual.s_start_offset <
+				sizeof(struct virtualAllocationTable20) ||
+		    map->s_type_specific.s_virtual.s_start_offset >
+				sb->s_blocksize ||
+		    map->s_type_specific.s_virtual.s_start_offset >
+				sbi->s_vat_inode->i_size) {
 			udf_err(sb, "Corrupted VAT header length %u (VAT inode size %lld)\n",
 				map->s_type_specific.s_virtual.s_start_offset,
 				sbi->s_vat_inode->i_size);
-- 
2.53.0



