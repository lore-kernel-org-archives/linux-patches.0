Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2114C313E2B;
	Mon, 13 Oct 2025 15:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370154; cv=none; b=M9IBGShnvAthx0OKcOi56xKLevOnhm6r/AaRcA8VA6tnAcXH6rYpdJI+SzlLUU3ml9xHBZYQodU7SLDnuh/u/OYhM3lpVMhRLwlymsKF6V3KTttO9atPOZwn9EwSNZN588eeSAmSUjrTF1YK0sdkiIZp3RtHFk7BKkxY6mWtCbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370154; c=relaxed/simple;
	bh=foDEkqgZPpQWX8kr52/7bz48DCyMsHcj2Iw33UNMJhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZP1D8j7X6dNTBkEG6lq5si11MeHtg1BWoeuXtsSxk+kVIPzLuPyglQOGxpLmZ3EHLNErCacnYIqa3ygN8VSdGiSa/7SsfjVmwKtLpT6fSyQg1xPl8Y/kqur94aeNejFZVCDAgglIr80RmSq3/AV4XsGRbSkjEKLEeW8Wbg1FCMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjG5vXqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjG5vXqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9970BC4CEE7;
	Mon, 13 Oct 2025 15:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370154;
	bh=foDEkqgZPpQWX8kr52/7bz48DCyMsHcj2Iw33UNMJhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjG5vXqCkwVBA05Hn2gi6IxlM1nWIaTu1VgzMpFGM13AfFCTlEA0qp4M17ugSm+YO
	 cY5fK+nkLpK0hD2lGK8v0rQtsroJ5kelvRAVK5zgup0ayiUeR5XhaTH25EQBnStHvl
	 HSxgixX4BICyv4k280I9wc3ZHDsSBvOE9sVscCTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.17 498/563] hisi_acc_vfio_pci: Fix reference leak in hisi_acc_vfio_debug_init
Date: Mon, 13 Oct 2025 16:45:59 +0200
Message-ID: <20251013144429.348652746@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit eaba58355ecd124b4a8c91df7335970ad9fe2624 upstream.

The debugfs_lookup() function returns a dentry with an increased reference
count that must be released by calling dput().

Fixes: b398f91779b8 ("hisi_acc_vfio_pci: register debugfs for hisilicon migration driver")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Longfang Liu <liulongfang@huawei.com>
Link: https://lore.kernel.org/r/20250901081809.2286649-1-linmq006@gmail.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1612,8 +1612,10 @@ static void hisi_acc_vfio_debug_init(str
 	}
 
 	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
-	if (!migf)
+	if (!migf) {
+		dput(vfio_dev_migration);
 		return;
+	}
 	hisi_acc_vdev->debug_migf = migf;
 
 	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
@@ -1623,6 +1625,8 @@ static void hisi_acc_vfio_debug_init(str
 				    hisi_acc_vf_migf_read);
 	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
 				    hisi_acc_vf_debug_cmd);
+
+	dput(vfio_dev_migration);
 }
 
 static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device *hisi_acc_vdev)


