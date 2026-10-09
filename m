Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931E44DBD62;
	Fri,  9 Oct 2026 14:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556521; cv=none; b=T+tJD5mm/BpumRkI1FE6voRRyICMIBGXeAXHovrxio80/IWvqPKFbthlV+agU19qIl3eSO0znVCPAjxaxLeJOKE+6DEvYWIn2XCN5qJKD9lVEc+IuLB+V0GtwsMKxDR5ySA2ZTVgNYWDegPOF3EbKnoVAzmXr4HA1fu/afLZsl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556521; c=relaxed/simple;
	bh=uraaxBnlGMRqd040m6WOlHtT93qbFmyb5WaafYN1Tkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGuXlGQX1VnXapx9k2hsTh73r/M7l1TIlEXqL/XzOzYxpKRwKBXZb6kCZKSpv5kacRXnJALacpJkEn/LCD6aIkqq2WxDJYWCfA9UaYHjBeM+Xwh6qDnh1d9F0fPVoKrqJ8BqOJRovlki7vA/HC6AMRfFeXYc/DJ9wkUgvQeLBys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQ+ZbmCn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQ+ZbmCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB98E1F000FF;
	Fri,  9 Oct 2026 14:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556519;
	bh=i8enUZPIjM1k3B2VfW1kSLGxxGvGCIo/szKrRP8M1zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQ+ZbmCnI4xriRMJr0V1nEP+NVDxrKv3SanhH2xzTMvXiVd4JL8DdZfQEhQv0efHI
	 gGqHvwBc8IIEEVGIO9x5dGxw/FTik3j/Rrbf/ZYt4IUy842ahulJAfwc6W/OsDMumN
	 qNT0sQSUNjJa1eqX35hcHgZ7ccLs4PrgOHTozW2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 248/403] nvmet: pci-epf: reject too-short SGL segments
Date: Fri,  9 Oct 2026 16:10:09 +0200
Message-ID: <20261009140957.968673156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit 5d5fbfbbacd1efb13a9bf91317d4fde859ede4b9 upstream.

The host controls an SGL segment's length. A nonzero length smaller than
one SGL descriptor makes nr_descs zero, so
nvmet_pci_epf_get_sgl_segment() reads the type byte of sgls[-1] outside
the allocated buffer. If that byte contains a segment descriptor type,
the function also copies the preceding 16 bytes and returns a negative
descriptor count.

The read was reproduced in 3/3 KASAN boots with only the host transfer
mocked by a KUnit test:

  BUG: KASAN: slab-out-of-bounds in nvmet_pci_epf_get_sgl_segment
  Read of size 1 by task kunit_try_catch
  Call Trace:
   nvmet_pci_epf_get_sgl_segment
   nvmet_pci_epf_short_sgl_test
  Kernel panic - not syncing: KASAN: panic_on_warn set ...

Reject segments that cannot hold one descriptor before allocating or
transferring their contents.

Fixes: 0faa0fe6f90e ("nvmet: New NVMe PCI endpoint function target driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/pci-epf.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -1000,6 +1000,9 @@ nvmet_pci_epf_get_sgl_segment(struct nvm
 	int nr_descs, ret;
 	void *buf;
 
+	if (length < sizeof(struct nvme_sgl_desc))
+		return NULL;
+
 	buf = kmalloc(length, GFP_KERNEL);
 	if (!buf)
 		return NULL;


