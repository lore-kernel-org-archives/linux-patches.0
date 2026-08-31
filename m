Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02B9494828;
	Mon, 31 Aug 2026 14:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185182; cv=none; b=uqV6C2p++iqfNDbB6LWyXQTsSInJfEpR4prBvfPfochdKuIr5nO/ZQSUYRKGMIrKVz/ucUAsvsgi8mbou9GbHNjrYYjcUb6+ZQ0Vqph5zp+BpjSc4MRDUXncAIfRUbdhn8hlbIOTS3iymurFKfsdg1a+qfmUPJ5dqcWulMxQ7LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185182; c=relaxed/simple;
	bh=smAaFnsUMv9cmbNMsfUo+/3vMSKhnrrZhYVH1dF3dLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCkL8fKp8TrSBGRDZg7DVNKLbY9650BBP7OwPrJxBF8CUkgiv/k3mzcJOcbSTo3bMmA6jAZFqhxax5Gwgao8DZt8Re9Um+Mdl6UR8IjWKlYSyNP36nE7g1kLSNeFvlkmr4ZwJvnl7sfFuRelSU1U39BMczT9C1xcY5dGsIwf7/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c69iUaUE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c69iUaUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AA71F000E9;
	Mon, 31 Aug 2026 14:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185181;
	bh=YK2+VqYsDrJiED0idqdhZNfapZwwV2KQLxnpFPyaCbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c69iUaUExMpX/V1mbEe1NQuxRDsLrXYYWyeU4cJ+80R8ixRLti/93/mUiqNs1zlli
	 F/Q3q/ndGG0mD8d9Teox0QaU4V+AXPP0Y3cekx9d4LR2w5hX8WUbGhVt1HpQyj1QTo
	 WzAW3nbAK7tfzA2nNBWNHaoRhUyE9JIPGpMmwf7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/43] Revert "mtd: maps: vmu-flash: fix fault in unaligned fixup"
Date: Mon, 31 Aug 2026 15:35:21 +0200
Message-ID: <20260831133359.114620962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit f781e80c9f1e52d92535c076573b0cdafab04864.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/vmu-flash.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/maps/vmu-flash.c b/drivers/mtd/maps/vmu-flash.c
index ad10f7887dfa0..f96a165fccc7c 100644
--- a/drivers/mtd/maps/vmu-flash.c
+++ b/drivers/mtd/maps/vmu-flash.c
@@ -610,7 +610,7 @@ static int vmu_connect(struct maple_device *mdev)
 
 	basic_flash_data = be32_to_cpu(mdev->devinfo.function_data[c - 1]);
 
-	card = kzalloc_obj(struct memcard);
+	card = kmalloc(sizeof(struct memcard), GFP_KERNEL);
 	if (!card) {
 		error = -ENOMEM;
 		goto fail_nomem;
@@ -628,13 +628,15 @@ static int vmu_connect(struct maple_device *mdev)
 	* Not sure there are actually any multi-partition devices in the
 	* real world, but the hardware supports them, so, so will we
 	*/
-	card->parts = kzalloc_objs(struct vmupart, card->partitions);
+	card->parts = kmalloc_array(card->partitions, sizeof(struct vmupart),
+				    GFP_KERNEL);
 	if (!card->parts) {
 		error = -ENOMEM;
 		goto fail_partitions;
 	}
 
-	card->mtd = kzalloc_objs(struct mtd_info, card->partitions);
+	card->mtd = kmalloc_array(card->partitions, sizeof(struct mtd_info),
+				  GFP_KERNEL);
 	if (!card->mtd) {
 		error = -ENOMEM;
 		goto fail_mtd_info;
-- 
2.53.0



