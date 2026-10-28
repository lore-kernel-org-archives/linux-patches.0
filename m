Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217011;
	b=uKIa3vKHN8edDfeEsIPVps972QIaeOasFwyqhAsmKXpbwiBRyS3reKmVUN6KwCJDvs/1
	 /w+IBQgkI1RZ+xWNX0dhFKy6MIFNxvThgROH9Tw5KhGMPGzPKSouYiqpHjnTLp6379/MV
	 7kWvX6lLCa5H/4BTbnV5Sgf6/DAUPKPn5C0lXfsfBOusInZnazLqOBsU6vSdgEZmwdPui
	 2SIAOaClNNpfy268OgJQ9xn3PGXkNFd5KAJfX1IEgxvj/topBO/I98Oe3lhIiZY1rg+6H
	 DFQ5QsxU/0Im7og8Co+1vU4OGNkD+ad36pPE0z/Dg5jgdQ4+wYChKAH6BW3crcbkSYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217011;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CGl24iIoPyGOGkIIluFgdV/kct8B33HP9VbwiyogoC8=;
	b=RNy46RC0RwIQmRxFCNPChUw3LjMsSJqLS2hRVvjGOG4aVgXQC8PRkTI+oYv6ULarnDXz
	 PzbSxRnpNloswDWreKbSZEZXPBHRnhIICE+ua5GY/Dwp2Q6zUzpRnYZ2cVSHwVT5c7Bh0
	 Xm9zrjSnfi7bwccE0f9re9792r2+x/EOvGMePTsyGYz+OdofVN+/9o98QCrbbLZ9QEqH6
	 l2Zuvmer+oXlyTtnd7lFXKvz8Vp9HrAznh6H1lO+UCjf68mubM651dQlxiWs0hbocbIqy
	 tK2WKUX9GFqeMe46XRv1DMo0dUKvbTFRgrIBU4j8BvWPbepPOZX2o0hXdxTVbNT8Wew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AZq56YHC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F4D606A326;
	Wed, 28 Oct 2026 19:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AZq56YHC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B0A1F031E2;
	Wed, 28 Oct 2026 19:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217011;
	bh=CGl24iIoPyGOGkIIluFgdV/kct8B33HP9VbwiyogoC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZq56YHC9HqlqiYVcEqK0ITC62BdNRXvkg61Zx5Ye/PGY/rTa+ogVj9xktfxgWioz
	 VJzvazet9pTnTWecTIoY9pupA1Qc6mesTg+QL2m93ApmjQg3qQJxnJK2GTVlSoiEx+
	 HufA1odxMEGMkcSD5z/SjGCpF83NeVDZeO+WBLsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 1757/1887] dm-ebs: fix incorrect device offset check in ebs_ctr()
Date: Wed, 28 Oct 2026 18:04:13 +0100
Message-ID: <20261028170539.440472766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Genjian Zhang <zhanggenjian@kylinos.cn>

commit 7ac81e2d2240f2c57bd073b0733e0b2abca38e82 upstream.

<offset> is a backing-device sector offset; ti->len is the virtual
target length. Comparing them rejects valid tables, e.g.:

  dmsetup create ebs0 --table "0 1048576 ebs /dev/sda 2097152 1 8"
  -> ebs: Invalid device offset sector (-EINVAL)

Drop the check. Bounds against the backing device are already
enforced later by device_area_is_invalid() via ebs_iterate_devices().

Cc: stable@vger.kernel.org
Fixes: d3c7b35c20d6 ("dm: add emulated block size target")
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ebs-target.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -264,8 +264,7 @@ static int ebs_ctr(struct dm_target *ti,
 
 	r = -EINVAL;
 	if (sscanf(argv[1], "%llu%c", &tmp, &dummy) != 1 ||
-	    tmp != (sector_t)tmp ||
-	    (sector_t)tmp >= ti->len) {
+	    tmp != (sector_t)tmp) {
 		ti->error = "Invalid device offset sector";
 		goto bad;
 	}


