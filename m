Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052543;
	b=UiVUdTrP1TQcbZM4njxbu41GtG/Y+BA/Cb7flYn2RFQpRMH6e6eTVh7pc/uR0BIN7J2E
	 Wal6nwD6/g0q1Sqh+wLNxFIPxj3UCBRYUAg8RsrfDSviFAhNRaw7wVNiLt/QCBgQwJpgJ
	 5XUiUlLpDD23BH96w+lbwF2LB1wRRmOHW5J+bZOwmy/bhp4mAQYae5qiSxcaabErXriij
	 IZWcLGC6kbqP5J7KFjFZL+k7LpQWSd6rxzKEoatV4JfpTSpn/sG5w/pz1cQ4OvEKs/36s
	 xLfuRcKHjEm+Kut6k38KBMqDQN7cb+VjHsCvetpVIMk8oBGfDHX866gDXdKch27p2xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QGIqcQm+CURLU4uZgI++o2if/yBUVUHzTl1laVAVeWQ=;
	b=SIStpiApfF7VrwRdfSuwwMzYSTE+R2olU7RbZD/GjqkUMOOGspAm3Ldn0rTJ53Sc5JLg
	 SQLZXJ7hpXXwBCUPBTW6JRFujqp+B9jYsG5oTem9XkqSKWtxNH8oaYMEVqJHHq18WYFw8
	 oanFkAHqRBtqP/EuMeZMDu89l4PdGH+DKWU8/m2rX9bA4p/6kAPsTvgqvHDeyKFL0LdvF
	 +GWNXBYWvOJKfSXsjLrk9wjk9RhFe+D6NZF06ANKPBMDQ9Ld0OWOommcP7krDvS2dDQfZ
	 eKnz/dxmRHCzK5rl2oN1d0EN0KPPXNaQ0NdhgP0z4SnyX9lJXsorPv2TxDdaQAh81Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dIlcrhUO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF64606A320;
	Thu, 19 Nov 2026 01:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dIlcrhUO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3764B1F000C4;
	Thu, 19 Nov 2026 01:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052543;
	bh=QGIqcQm+CURLU4uZgI++o2if/yBUVUHzTl1laVAVeWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIlcrhUOjugF8INTMV+0t5FfAPZ2k5c34/D1g4w8YniPt2dBPC1LMTVR76NZjPVwD
	 IpKKxAFvHzE/T9Dsit6JxH947nrR1UF3XWwCRLGi+KLsmvp2EPd/7WASwRgy4nF3Av
	 sG4jZuvQRFecYsGGv/VKNRu3OPkC6Zkx+8i45aZA=
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
Subject: [PATCH 5.15 0601/2214] ext4: fix out-of-bounds read in ext4_get_group_info()
Date: Wed, 18 Nov 2026 15:37:57 +0100
Message-ID: <20261118150034.995975468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 660d8aa23db0f..6370b202ea6c6 100644
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



