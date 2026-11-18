Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047823;
	b=t6ePq/aNbLak5IvgeyogBjzvBECdV66Cj3zCC0w+iQOxX2N1UDoxMF9aDskUL51luPSZ
	 FzVZcSHYLm47mi+cIpBSNBSQ+xnPS7Dg/fkcnGbzmTSv57sI7ukKcWlkWwegL7ugCCJEd
	 NTszVVezB6zBIdyxCdz46YK1k4ljFY5qhxqs1h15fKuZX0amHgrauFRBEyaQFmlOLfXTT
	 iwdAOXcR9iyaHf81QCCPeGUD7PzzH8igYVP/AwMPOv74vLTj6zUPXrxsxXgdg+9o36MxU
	 9w0GNBZZxCawS8AvH4H83h5fM74Q9+UlruradvtNSgdIYTqFOnfgCokEhAqoxMMveZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZUk0RE/3uBe/vgbxfIKu8hMVO3+uxZ1B9D584YGfKkM=;
	b=mNVSng/3I56fqMuCteSOPSsU+f5D67i7HWfSGNDS0/ZU30sK/EJq631KGsvSBuwjcwZN
	 ujNkWpNo9crj616pLhbfH60h1/MAItwit2MWzikJSGvxAKcGIG9J7ijvtf9pdfBHy1ei+
	 MkF/H8i+DoEK3m8CFHz7/Ts5Iu8z9C7J+V6q59UMFcbmJUqRYN9rwmG1Y08D1uowBlN39
	 atzCqa2eeDknoxRHTndijljhuyemgI5oFWK2AmV02gq9Miq/3mwf18tWqDGoMVe/+UJAO
	 Rvc3QQdBDFgFPiwOWtV47yvQxkZ1T1/HIItwhBb7Q3wZIRcryio37O/lu6UoK0xEcJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1mvcgVA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084FF606A31C;
	Thu, 19 Nov 2026 00:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1mvcgVA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDD31F000C4;
	Thu, 19 Nov 2026 00:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047822;
	bh=ZUk0RE/3uBe/vgbxfIKu8hMVO3+uxZ1B9D584YGfKkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L1mvcgVAH59WSO8/Pwcwt1FEIgZnVWw/rPJQ/HeMvdheW1KPIJ5ez5FwqjUNee7h5
	 Lvv6mPmUw05Fq0Kx9Pm29l/5+PJ9hdF9LMZXf6NK4aA2CujfnAXXYbYOeXXMMEPW5k
	 1ELDTjh5HODGixzumEXX7Y5q1pUVmHK4McVW1qWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1725/2857] udf: dont use eloc after the end of the unallocated space table
Date: Wed, 18 Nov 2026 15:45:59 +0100
Message-ID: <20261118150303.429797334@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



