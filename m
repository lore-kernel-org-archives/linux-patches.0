Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C7D46C4C7;
	Tue, 21 Jul 2026 17:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654946; cv=none; b=oHc4mCxb3zDWD4S3Hkzbbqe+fVubZxO4zeKtrGQAekTcUqztMOafImLRBaHtZplA0dLD7HpKMwWH2q7Uyam398UiSEDTjy5NFY+mMmgujlG4yWuyavPqIP9o1QevyTWHQ9amixINE9qz5NfPk/yMagkRSVdsI2qJhpF+HRLhSv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654946; c=relaxed/simple;
	bh=8OyPhsyiAPBS9lvCxXvzm+gcuh8CiRVPCmaQRyLbWH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uj7uSI3hVp8bi/mh3cLEOOsUyE6SmrrA603exvOm2Z9kUfU3tNydeg5n4atXLeZI5IOtiYNf25Dy2awEgTRg54PFcrEd3w+eR3nfEd4PQBAOndenLlWus9Pld1t0Zim15ylQ2J9LJ1e2FjcNFvBbHECRP3Cnv9SU6L2PLOPqCkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1/kbzL0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1/kbzL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7D01F000E9;
	Tue, 21 Jul 2026 17:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654944;
	bh=aiDiRFuWqIuzhKIZuiqr90bgd0Qcg50aI+6IBzFT+BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v1/kbzL0x7N4/Ry8SohlJD3+roenlNIRbrg76nNlCUKQnIEhNJZTdOONXjXcGr0Gn
	 gYWZhOT01fWtEnqycUHzNWT131pz2JbUf8EIoKw9Q7tgnczsqjZKvrAdky+qwZPuTy
	 dqtiDBgHnq/PHIA6HOcd+t0U6B5UJB7ahJaNed8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1843/2077] dm thin metadata: fix superblock refcount leak on snapshot shadow failure
Date: Tue, 21 Jul 2026 17:25:16 +0200
Message-ID: <20260721152636.207013535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Genjian Zhang <zhanggenjian@kylinos.cn>

commit 4b22d0801fadfcae2e106e6ba32e49439c7c7ebf upstream.

__reserve_metadata_snap() increments THIN_SUPERBLOCK_LOCATION in the
metadata space map before shadowing it. When dm_tm_shadow_block()
fails, a reference is leaked in the metadata space map.

Fix by adding the missing dm_sm_dec_block().

Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: cc8394d86f04 ("dm thin: provide userspace access to pool metadata")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin-metadata.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1353,8 +1353,10 @@ static int __reserve_metadata_snap(struc
 	dm_sm_inc_block(pmd->metadata_sm, THIN_SUPERBLOCK_LOCATION);
 	r = dm_tm_shadow_block(pmd->tm, THIN_SUPERBLOCK_LOCATION,
 			       &sb_validator, &copy, &inc);
-	if (r)
+	if (r) {
+		dm_sm_dec_block(pmd->metadata_sm, THIN_SUPERBLOCK_LOCATION);
 		return r;
+	}
 
 	BUG_ON(!inc);
 


