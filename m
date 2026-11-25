Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620845;
	b=1bsiRSsybuDViiKK2h0PDWaj9J8kt+GIoI06cJxTpSIAP5B2VVZKxxuDFn4h+gPvX/ZY
	 1tJTo04TX8Pt/YFEi1fiPpbAfrI5LVN5jMVkSfC8ObvHvxMCk5cTHSjRd0FwirRTrkhlM
	 CiiS+PfQBqx+yTRVkN3h57YSdWqfMKVk392KoNmHXgRrCtTQERbUgXlNk8o68cDk1z5Sp
	 ym1kcFctAj3UhjGVUkvsdYM3ZotJayu7AX5aKTiOscTpwD7sFmOgMN8zUazrYQbwaMVJz
	 +hHmcHgvBcdCx24Jdn27QpFaXPFOfvR0++nQIpNzH3spB2diDSuoxi8BOqFG0zL0GLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sgA8hT1aZPd5WtHByOKJDbo0ztJM2I95uHn6to2083A=;
	b=TYgW3LtAkNL7Kkw6r3TOr0cuq3kzebDVVfg9sNpckM9tSgpPP/Jj1bpOOumbwkxfj74E
	 AT3QVRX+pdzjsxTnUyET6nk/snJLoTLfh/vxlkRrrWnNsEGMynD1dBsOcgYkLFHHsea1B
	 IkINfJduX2nxXd11JeK7F0EWX/zM0DeEB2my+KVLttmC7h4Ei3EjM4FJIF4nO+wF7/RIj
	 +JqKP05KzsGxCvRVqiMekB4mn80TF3mznFSjPVvCrcIsoB/V1Umwjfd1o22M6jM0vmpiO
	 t2HKLkpn4yNm0vDqUy3QvFA9whynsu+rkAl038ii88OI7bAIG1Umvn7yXT6Z3BMRF8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qMruyvNf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EB0606A31E;
	Wed, 25 Nov 2026 15:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qMruyvNf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC841F000C4;
	Wed, 25 Nov 2026 15:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620845;
	bh=sgA8hT1aZPd5WtHByOKJDbo0ztJM2I95uHn6to2083A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qMruyvNfBkYDD1cV/tUri6GUcXL5gvn+Vg95SXIPGSj/ZjKnoND31fA41SKL87E2F
	 z9gidob8tV/3JlupucIZONDa2RLbECh7knCQl/6HXo7WqNajnhtBTSXT6ixEbaI939
	 2YsNANbW8qjFrSfqT2wQqi/hQxpr4HuYPygqqDQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/990] udf: validate VAT inode size for old VAT format
Date: Wed, 25 Nov 2026 15:23:28 +0100
Message-ID: <20261125143823.053090699@linuxfoundation.org>
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
index 8d3d758714da2..ea9cd593ffbbb 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1319,6 +1319,11 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 
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



