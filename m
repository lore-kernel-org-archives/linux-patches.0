Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5EC4EB871;
	Fri,  9 Oct 2026 14:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557129; cv=none; b=MreKTSeO9Tq7y9OkGICOEr0nYXuQHRYksRcolhNHZ4UgbFx6Wf7Sk/ewNQ+ky31FJO8be0IGAxCny1JxKP3UurV/rrLZe7KnEteo6Bl8wHqx/3S2ziNKC/k/hn3/w46Dqfke0/aq2UIEvLSYmITIYCPFzrWXoJQNdchEjrwAYig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557129; c=relaxed/simple;
	bh=tt+xp8RT6d6ZDFJeEe6gnm7Zk3zKJRDHALHCAVd3LZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCjfYJlw1ru1Qyuyzg3o/XI4a3KWN7s4aCvsbTuMIpBrv9qi9WuCJ733bStAUG4CjxqywEl0tQ98Y+8YcpEIb8SR3j2kV8Gtb8F/UxykLdbGOI7O4Z+WMM5nAZ0ep/F2Wnf/anhcYj18yg2LTF8YsREHCAn0ybw1pB4Uatoefrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmu/UhN2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmu/UhN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544E31F00898;
	Fri,  9 Oct 2026 14:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557126;
	bh=XehFnwy3lUCFAS7kqshNfDCYWS1wavDFGkn7gy6YsUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmu/UhN2UgjwTPosIgw92yupbfmHvsGmv4I3mvDLFfBds2YAKvL37bktLFcy/7owu
	 4XNKZS84qFmGHAVCwAvw1742YeYOfD2sNmqhK6spIYYUwFnN2D1tnbKXGY0CDqgQ6+
	 IvUQexjCXZSAHrZQ2Fpe/5uNTMlVyA525DLvfgwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.2 300/428] nvmet: pci-epf: reject too-short SGL segments
Date: Fri,  9 Oct 2026 16:10:37 +0200
Message-ID: <20261009140952.704240780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1001,6 +1001,9 @@ nvmet_pci_epf_get_sgl_segment(struct nvm
 	int nr_descs, ret;
 	void *buf;
 
+	if (length < sizeof(struct nvme_sgl_desc))
+		return NULL;
+
 	buf = kmalloc(length, GFP_KERNEL);
 	if (!buf)
 		return NULL;


