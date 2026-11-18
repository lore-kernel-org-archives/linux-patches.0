Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058562;
	b=QfucIwEfGd6+GIwDL6lc2KJe4Ua+lhFsBatFkknXGA7h4U0WiEbrwiuqU1XA4EPtWwj0
	 cAaiWXSJgAZwH/SFGK/3sA9ycRzFFJekOuPjxxsHAx4VXVMzsb9r1NOh1dR8KQ13FVqiC
	 Yijmt/V9RNNhzZyZlJU/LTJRrS/eUWsyK9B9WRgVIPsa9A+lTiBA/URZenqcTNhkt+6tr
	 8cg+KG0J4/UZs43DV2P+wSM9jQbmZdsqv/KHxuUjiPCLL337VFcX0IdR9R1LfFyESXlTe
	 O7VHg8EtMdWnUQrAsv+A0OG45t8tdGBUQy39Ktef/UPzZuL1ms0C9oK0gEPNeY3jZuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FuN9iqezPbdtIDzenf0uERyVN8rx/cYGNTWEOUe4Dww=;
	b=VdTa3h09mUZQYAfPPh+UCC+bblAwfJYxcQBf0amPQZEAlT347j8ARFdsiwBCtj3Yk95c
	 WNjpz0rr6QFr11kDAaU36oefyVq11G8rhaQ/c20Vt253XEdIuO7n6ml5zbRZOYJq6Z4cj
	 t81VpQs3VtK4vYysqYDUHGpe5JQQ+ekgUxcB9YviOmCtySvV0PP3RWedJNC0+w8ajQTVn
	 H2xq2/SlRydnEbbWmN1d95T4ikJrGBnoZFLmbC8l0hRm2lcAWFJIInUtkjsVpvKHaoJyX
	 HT61eYN4lkvN30RwOl7V/om83hMd8FaL3uX3sSeY9Oss3jhaiVv7JnRje/GtKHdeBJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZXLL65V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9823D606A33E;
	Thu, 19 Nov 2026 03:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZXLL65V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045291F000C4;
	Thu, 19 Nov 2026 03:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058562;
	bh=FuN9iqezPbdtIDzenf0uERyVN8rx/cYGNTWEOUe4Dww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZXLL65VYYV5VFT1xLHGU9TwUU3nmkoSr4NbZTVNdmGeA/kqpTD2Zh1yYcdqXQCgx
	 6AdRSYyIxWI9v0DTOpnsxorRsgPOLRcFR1jnVuTxvjuR0g7AMcCbnUDnhpR5UgRXfE
	 7Semd4R18FDR9BGAIJQ80OMvBnE4rwMRPeVBIlhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Theodore Tso" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0490/1848] ext4: fix out-of-bounds read in ext4_get_group_info()
Date: Wed, 18 Nov 2026 15:42:08 +0100
Message-ID: <20261118145934.829594221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit b067d3c1f90b536e9aa9f48b19580475a0b34f0f ]

A plain read of s_groups_count in ext4_get_group_info() allows CPU
load-load reordering. On weak memory models, speculative prefetch of
s_group_info prior to the boundary check could lead to an out-of-bounds
read if a concurrent online resize expands the array and increments
s_groups_count.

The data race occurs between the ioctl configuration path (holding the
resize lock via ext4_resize_begin) and the lockless metadata lookup path:

   CPU 0 (Writer, Resize Lock)                CPU 1 (Reader, Lockless)
   ---------------------------                ------------------------
   ext4_ioctl()
     [EXT4_IOC_GROUP_ADD]
     ext4_ioctl_group_add()
       ext4_resize_begin() // Takes lock
       ext4_group_add()
         ext4_mb_alloc_groupinfo()
           // Publishes expanded array via RCU
           rcu_assign_pointer(s_group_info, ...)

         ext4_flex_group_add()
           ext4_update_super()
                                              ext4_get_group_info()
                                                // Speculative / out-of-order read
                                                [Loads old/smaller s_group_info pointer]
             [Plain C store / smp_wmb()]
             sbi->s_groups_count += ...;
                                                // Reads new s_groups_count,
                                                // boundary check passes
                                                if (group >= s_groups_count)

                                                // Out-of-bounds array access!
                                                sbi_array_rcu_deref(..., s_group_info)

Fix this by using ext4_get_groups_count() to enforce acquire semantics.

Cc: stable@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Baokun Li <libaokun@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Fixes: 5354b2af3406 ("ext4: allow ext4_get_group_info() to fail")
Link: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinjie%40huawei.com
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20260902074805.398540-8-ruanjinjie@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/balloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 679bf230b2984..f06b4149bdda5 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -325,7 +325,7 @@ struct ext4_group_info *ext4_get_group_info(struct super_block *sb,
 	struct ext4_group_info **grp_info;
 	long indexv, indexh;
 
-	if (unlikely(group >= EXT4_SB(sb)->s_groups_count))
+	if (unlikely(group >= ext4_get_groups_count(sb)))
 		return NULL;
 	if (unlikely(!EXT4_SB(sb)->s_group_info))
 		return NULL;
-- 
2.53.0



