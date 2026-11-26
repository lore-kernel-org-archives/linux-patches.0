Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704132;
	b=WJNRK6wlGOUvUMe80nsQPio0A3msDU8iS4chbcTKuXe6pJGr6MMezadfpHAF6iyKJf7P
	 BFeC3MMhdUoHTXkhhc7ocSWfId/5uzeRIcHKo8TfYXQm2EqAOls/FBwJlfOe70r1kzc9Y
	 rKwDRuW5HRYZjgJKOgfjwuQdYWRVGrLw5oDCyMUHNqtiyyQ1ouFCIsnITWRDtIJi3FbWo
	 gKURsgmACFeqMzGv8NbhaeeIcwGswvtvSRAKQQqzYBE04OSfitOe3POvk4BPqpxuqJm7K
	 LCJePYf3zZMNwQSVDOBz6e6WfdONayhy1MNZD1hDWIG6fTgH55fzZetESXOlWmIZ8KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L4cnJoNdEYWqFToCl2c6oAQnJY1lwM5KkrskqhFh83c=;
	b=49vltM0rbZ1zBnyxLPxXneZ78Vhmg2KuUE3rzC8KBYn8M/k3Xenjy1L7hSmcyRmN6TxP
	 QW4YHwlm4gbinDGnhLZUe9RXavyzOlI0KqVtXLIio2Dj6DfcyP8WgAn38NtaCLOayJ9Xq
	 FXiYRKRxqcFeS9qbsZlkuH2DWOla6dc+Y3BWGwL2XzM1fi0EjCJ0VwNHJ1PBrv209No/Q
	 4oCAyqDQcXyhDqEDd/ZLwiYCfkZR4p3vIXzi4bW0SukS+3O6HDIR5wi4+BITdN0d15bPC
	 TytKReo/oKybc1aiwomnftaktL5CoT6Q6HKry2o0UIZ70c2BS2BTtplSHYml1PoNrnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OIj2U0fG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904CF606A31C;
	Thu, 26 Nov 2026 14:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OIj2U0fG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8811F000C4;
	Thu, 26 Nov 2026 14:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704132;
	bh=L4cnJoNdEYWqFToCl2c6oAQnJY1lwM5KkrskqhFh83c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OIj2U0fGoQscRf5P8nhbKTqPzd83frZb48+hvaz3Qfk7mtyLdsXRXgX5lsk+h4lQ6
	 ZZf7/JqEFmeWP060RapbYDZWWEDc9gDlEb0C5UgaKKnZGGE8VCemATzanWJdOS1+l/
	 etwgqjUjcgvyt0cdDocyMuVhmxIEE3P/py7ULKUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/265] udf: validate VAT inode size for old VAT format
Date: Thu, 26 Nov 2026 15:35:48 +0100
Message-ID: <20261126143606.338196177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 5163e6ee1ea744d412fe516235bfd9cab15141dc ]

Validate VAT inode is large enough to contain at least the header for
pre-2.00 UDF media format.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 6994cf6a09d66..fa49793ad5fb2 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1216,6 +1216,11 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 
 	if (map->s_partition_type == UDF_VIRTUAL_MAP15) {
 		map->s_type_specific.s_virtual.s_start_offset = 0;
+		if (sbi->s_vat_inode->i_size < 36) {
+			udf_err(sb, "Too short VAT inode size %lld\n",
+				sbi->s_vat_inode->i_size);
+			return -EFSCORRUPTED;
+		}
 		map->s_type_specific.s_virtual.s_num_entries =
 			(sbi->s_vat_inode->i_size - 36) >> 2;
 	} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
-- 
2.53.0



