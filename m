Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060313;
	b=lAXjr9I8XRvbLUJ0rj/FcwzZPdLtdJgJ129zlbkH/2UWkfXR0Wg0NGNeqHVnfwWWMoPA
	 rGvBuUws/hwqbCawoiKlQQiVcT5yPURUTAQzhXo8bP5bdN/tCUUIxscaCbJGnrEHaktaf
	 li4XLADmJTEug+Dvxke2ZJfesnGlz4ebq/UJfuoCPctddyfKj2+Okuk8NI1N7vgzuS0a3
	 TV9k3k4Uz6cMYYlcjvYWBqy1nCDN15b6Jps9kheSyW9Q8Ak0j5DHfnHSucCYfhjXfSVzu
	 SQDpu9sELqDAP3eR196L1aPCqjvVTnMLhYgR1oTJ5uayD6NZ2cm9rPVSwCrcZ2jnufw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GJHEKCLuJbTTeoLiNwQs006YPkZSRGS1NZKFnC1L3bc=;
	b=rqMzbdH0PVJjySrQ8D5gjj09ag0SresiZ3Cd3omR8zTewMYAAasg0msPMhVuZUtlMqpw
	 Sj46CBOUmVfCCwN2fAO7glmOq5ccR+KodpB2+I6GW8AoMAZEiGu5tyur4mWJl+e8NcI6/
	 AEClqYSyJnAIBeQR136rOwbUQrpYL/Hc4my+q3jstdc8jcbkADXvkDynzQ8neanuVXNnU
	 QujwEqj6sQwf08Vu32N0bTqXu88A1aw39560zFuU39WO86P23zwdPF1jT291bTZybLfiC
	 r9hGUjwwR/WOTG0JNotTYodLOPULQnOYymlIzTkn1qiryFUWfbU1Mqp8GTTKqeaOxNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4LAjnD7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3036606A320;
	Thu, 19 Nov 2026 03:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4LAjnD7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445A91F000C8;
	Thu, 19 Nov 2026 03:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060312;
	bh=GJHEKCLuJbTTeoLiNwQs006YPkZSRGS1NZKFnC1L3bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4LAjnD7EZcDIUNpAiv2Xg27DEDu/NaOAkml7Ie5wjHFH8wUVbUQWQYAWISN1s9OF
	 STi1V7/Sha0z8QYPQuDBXA+P1Lcv/O0POAalHDQMBUUeGdbw9tuaWkKostDv8nn5ih
	 CfrvJj8VBoflNXh5284KJ4QH8Tfdz6pugD4ONQwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1113/1848] udf: dont use eloc after the end of the unallocated space table
Date: Wed, 18 Nov 2026 15:52:31 +0100
Message-ID: <20261118150005.926925384@linuxfoundation.org>
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

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit 94401199df90e1c2a50c6e4b73618ac5a4ba83ba ]

When udf_next_aext() returns 0, its eloc, elen and etype outputs hold
no defined value.  Two walks of the unallocated space table still use
eloc after the walk has reached the end of the table.

udf_table_prealloc_blocks() looks for a free extent starting at
first_block and decides whether it found one by comparing eloc with
first_block after the walk.  If the table's list ends in a continuation
descriptor that leads to an empty allocation extent, eloc is then the
block of that allocation extent, which is in use, and if that is
first_block, the block is handed out as preallocation.  Once
udf_discard_prealloc() no longer frees the wrong block, this is what
still makes fsx in generic/091 and generic/263 read back bad data on a
table, in about one run in four.  Only take the extent if the walk
stopped at it.

When udf_table_free_blocks() cannot merge the freed blocks into an
existing extent, it appends a new one and sets only its block number,
so the partition reference comes from whatever eloc held after the
walk, and with long allocation descriptors it is written to disk.  For
a table without extents, eloc was never set.  Take the partition
reference from the freed blocks instead.  Short allocation descriptors
do not store the partition reference, which is why this half remains a
latent long-descriptor fix rather than a reproduced failure.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Link: https://patch.msgid.link/fd9ca4c4ba98c00c012ec861f6c0bc08a3b1d07b.1793349907.git.matthias.goergens@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
[ sashal: Replaced ret > 0 with etype != -1 to match udf_next_aext() returning the extent type directly. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/balloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 0bbe86da3d133..267365573bf7e 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -473,6 +473,7 @@ static void udf_table_free_blocks(struct super_block *sb,
 
 		int adsize;
 
+		eloc.partitionReferenceNum = bloc->partitionReferenceNum;
 		eloc.logicalBlockNum = start;
 		elen = EXT_RECORDED_ALLOCATED |
 			(count << sb->s_blocksize_bits);
@@ -545,7 +546,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 		; /* empty loop body */
 	}
 
-	if (first_block == eloc.logicalBlockNum) {
+	if (etype != -1 && first_block == eloc.logicalBlockNum) {
 		epos.offset -= adsize;
 
 		alloc_count = (elen >> sb->s_blocksize_bits);
-- 
2.53.0



