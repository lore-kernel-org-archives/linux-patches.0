Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B8B41D138;
	Fri,  7 Aug 2026 15:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117212; cv=none; b=ik4NejwwujcWcgN5o8FeSLisprYNHw36IV5B26igXcueh+xnhOUm6Dfv01DVW9tNYe+8XFbU31R/llNBBInVYPBwWoReNg/us6DsrcgQa/tGtOevB0og9mECt86omYOdZYpP7TnE6dOD67ZVRDKuurS3mEK2lAm0SIk/PhGWraA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117212; c=relaxed/simple;
	bh=vSgzXVpXKhV9uUWCpIPHNNm9mqZtlGMvBM+h5YEKFEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlLOygMQimvqprz9ArFttoVglTdFT7wtFE1wpOs6eWGrao6/criOvID7AME37SbQFGZWF3NA+cgTsDTA1bdX2pBj+t4WJArTEy/5uSYX/5HUsk196ZNmNl/Um8U5GP+h5UJM0RQ20mBUt3cSYKxtBj+D8rIdyoxBGIR4lbTHebY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJDF94Dd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJDF94Dd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929291F000E9;
	Fri,  7 Aug 2026 15:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117211;
	bh=5+NrT375NCL8MGYHfvtPr035Mf89KNaVQPNI/9xI4Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJDF94DdP5dk+YFBS7qlSY/RiIgCP7HzTulkktQu+x0HKAcD1zZQaUR5p+iDq1Ypq
	 9o8doOrR7/9ly3YFqbhtjxf8DNflXb+k4QSEuq+ayp8L99gXkahyXSYzx2/GSAZp3N
	 0mmg8Ri8FXMXOhuNW299S/nxlW1A7Wwa216MYNvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 212/438] lib: test_hmm: use device devt for coherent device range selection
Date: Fri,  7 Aug 2026 16:36:48 +0200
Message-ID: <20260807143432.532707528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Stanislav Kinsburskii <skinsburskii@gmail.com>

commit 4fc089235378d1f9ddb6bcbe67c192ffdcaae0ed upstream.

Commit af69016dab96 ("lib: test_hmm: implement a device release method")
moved the initial dmirror_allocate_chunk() call before cdev_device_add().
That means the struct cdev has not been added yet, so cdev_add() has not
initialized mdevice->cdevice.dev.

The coherent-device range selection uses the device minor to choose
between spm_addr_dev0 and spm_addr_dev1.  Reading
MINOR(mdevice->cdevice.dev) before cdev_add() therefore always sees an
uninitialized dev_t.  As a result, both coherent devices select the same
physical range, and adding the second device fails due to the overlapping
dev_pagemap range.

Use mdevice->device.devt instead.  It is initialized in
dmirror_device_init() before dmirror_allocate_chunk() is called and is the
same dev_t later passed to cdev_device_add().

Link: https://lore.kernel.org/178277581197.172200.16265155329935822153.stgit@skinsburskii
Fixes: af69016dab96 ("lib: test_hmm: implement a device release method")
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_hmm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 9c59d1ceb5b5..c4adbf98fac7 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -581,7 +581,7 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
 		devmem->pagemap.type = MEMORY_DEVICE_PRIVATE;
 		break;
 	case HMM_DMIRROR_MEMORY_DEVICE_COHERENT:
-		devmem->pagemap.range.start = (MINOR(mdevice->cdevice.dev) - 2) ?
+		devmem->pagemap.range.start = (MINOR(mdevice->device.devt) - 2) ?
 							spm_addr_dev0 :
 							spm_addr_dev1;
 		devmem->pagemap.range.end = devmem->pagemap.range.start +
-- 
2.55.0



