Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590499;
	b=S/9H9iNHXjyFNvFh7klcc5NsHkoZUKTouuJxGbzxqhhXpZyRWn6N80o3TNTcHVukc+hp
	 +F+2KH6EU96hzaIT4KDAoA/96zzbT7nJlThzDbelwBFrl4ZMR13SzkedgSuM8iOX4Vvsm
	 B1vbpBllxzVAtcQTygsHoXM8M1x8d9qBWw3TqL3raEEd64GCSJtMB/XfjwZ0sBt6QSl/z
	 UWwhkg9aNm/9nd9BJ9L7LCYKLZQdYcTxd4nolWB2oZ+D5ACXLRigLp8KIuNb18ZiVj/1g
	 vENdi5AfEN8XDJ4Svh6TGQ53K7uwFOx+GEmoxPfhrssajXewdEr3X40fpB1tN+gN7aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nlGTKWEZt1Dp/1tEnv1tXrxkiC6q9HnWvbZL8xKkaxo=;
	b=x9Dc6e1dkExbl82p75lxmQZY6dFoQHiwIQfyDx8pYICB6PEAurgub5a/qUC2GLx/bqrk
	 wvz1a4UzkPhihe0EqCHagV+SZhhQthEINZON03LxW+5VR9u0LmA2vsOWq6S0zlonHNDdG
	 vMBfDw220vTRpEykhuDqg95XNDgzUeaj7SJjVCaBkOGvU67Vu2G020Df2K51TR/gneyKC
	 RaAm3pHKrsPJli9xnwdT1PbspB1X0p2s9YxbZyjlI0/tNr9PlvikKQPzdKmX7llqRG6Ia
	 gHJf0RfmrlpKf6fuAP5ygt0GznRJOITz3hwr/BM9h2Xmxpw/9Fb5nDJgQeiMJKrVSNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LkKYj8Iv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29446071437;
	Fri, 13 Nov 2026 17:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LkKYj8Iv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF3E1F000C6;
	Fri, 13 Nov 2026 17:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590498;
	bh=nlGTKWEZt1Dp/1tEnv1tXrxkiC6q9HnWvbZL8xKkaxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LkKYj8IvnjIa/0Tt8o/Nxcr1Erh/gFgsEiadtilt2e/N/rpZKFMKtzoYnYmxh5zuv
	 orqriPrgN3HJkD3S49LK1bmbQKI24VXjM144YDC6hKQzO9HcGuLbMIsp91dorhT/4s
	 1gIa6t0Qfiw4KanCOAzMOxv6VC2TvCvX11NnN6oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 446/686] udf: dont use eloc after the end of the unallocated space table
Date: Fri, 13 Nov 2026 10:49:39 -0500
Message-ID: <20261113153835.998590953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/balloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 2ec577b4321c9..75124188e7452 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -457,6 +457,7 @@ static void udf_table_free_blocks(struct super_block *sb,
 
 		int adsize;
 
+		eloc.partitionReferenceNum = bloc->partitionReferenceNum;
 		eloc.logicalBlockNum = start;
 		elen = EXT_RECORDED_ALLOCATED |
 			(count << sb->s_blocksize_bits);
@@ -532,7 +533,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 			  eloc.logicalBlockNum, elen, first_block);
 	}
 
-	if (first_block == eloc.logicalBlockNum) {
+	if (ret > 0 && first_block == eloc.logicalBlockNum) {
 		epos.offset -= adsize;
 
 		alloc_count = (elen >> sb->s_blocksize_bits);
-- 
2.53.0



