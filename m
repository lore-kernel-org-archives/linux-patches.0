Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704895;
	b=pi14d9Rd3JABCSvnM1JtwWE9y4FLLtGbFtn6RkQtvtnom1vU2fRZk8VdvFHnktChTdF8
	 zuayPsm8IAn2OI3vQd0lc9/GFzJQWSg/ckLv8JooZY7SfZVPa6Bc2OLa8asos6OGKvTXq
	 O/cxjumpcG9xC4qDbaWDZaSjs9gAATCgHeey+vGce5c+9en6TET4z3uSVaN+aWltoIOEU
	 o033jv7ns36fp+TIG98RWQvAmGv4VI2H0S/SpO4XVlygsXfSCYLnreJ2vtKa2rnwbEWa8
	 T4hdsesgxbqAfNKg5mq5xeH54HtK52Vm5d9ur40CePHCMlrLFt361KPpfgZEnuIitvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QZ1nzIlvN3ZNqk9TmxKIL0M1Wy2VHPzDW1Lp3b1NtI4=;
	b=pSFp0Lkn1CDWX7T4NKgma5K/2SweYwI0Pc5RHReRSnR0PM6qXFtbDtQDM9+l2mBu8/dF
	 unKjkD98yZkcyzOpoAbD6rS+9i3dKiZlp21vlm/D8cqiwirDz8TG6s0ArzGfeAZM5ErNG
	 7v8nhfpPOih3WqWW4B0w2IZKcvhaOhYhuxBuPqlMMUJ/kUQ1K0FH4Q/xA9Sg4RTkDuY5m
	 mdpMdrM4U1DBr5T6rYLJ4n2ELu1NP94ATRaOErgQ5YB/tleFDrqebyu4B3k3LenkyXKxv
	 bh63YvB0nNdWEKooGdCLrL1CmZ2mwKB3gu540aAPMXHr2XV5LvDQngoN4DMK86PMILQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NyeBWIvP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAA9606A31C;
	Thu, 26 Nov 2026 14:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NyeBWIvP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB7E1F000C0;
	Thu, 26 Nov 2026 14:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704895;
	bh=QZ1nzIlvN3ZNqk9TmxKIL0M1Wy2VHPzDW1Lp3b1NtI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NyeBWIvPB6C/uNnVUclHAfvOJiIE1s6k86ao7X9g8Hp5Yj1kvWcBF/GILRDuZdoFh
	 C2m/zzDy2uC8EswdUdVo6gJk1G8ZUFvCmK3gPzOAyQEwZWqbx4zBlaPR34DVdSo6Ig
	 irzKKdUn2ca1jEeZmT+Nk6uWUTYf7kqkmKDwVxjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/319] udf: validate VAT inode size for old VAT format
Date: Thu, 26 Nov 2026 15:36:21 +0100
Message-ID: <20261126144007.040364036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6857c15f5a0f4..98f95f0b6f8a7 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1217,6 +1217,11 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 
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



