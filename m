Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F50B3F44CD;
	Fri, 15 May 2026 16:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861900; cv=none; b=MFveeUBxaCuhYfOUyda9JFJTLzl7chFZxWOmLzkuelJqb8jxQ/arrPgJFJPU19YTO90LJI4l+/RNglTSCVTN47cUP7zPzD58zcBlqAh3v3E3wgM7+cjjSYUx4gU6wgfJ5EvRrN5qQ2VfOuDuDtdKwNVCTxQpkOeA+LBmPM9csRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861900; c=relaxed/simple;
	bh=sgT9qKrqTh1+gEwTPmw7eFTHSYosgDbcs7JVD3AKK7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reefPtLSXphV2MY+HzYJ+nq5Ws3xPuLc0uniKzELpyrX8wIwdWbsJRqhe7Fi2N/Xdquvppz+0cB6UCG0yb/l2nUfF63C7+ezG9G/oIamgBa+zGsiLb1aPLTKPxFeRV3pfeH4L2cPe7LlaKftHbmF07QHgELT/MnkEh3eNn5NJzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtVU0XsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtVU0XsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E922FC2BCB0;
	Fri, 15 May 2026 16:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861900;
	bh=sgT9qKrqTh1+gEwTPmw7eFTHSYosgDbcs7JVD3AKK7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtVU0XsG4peSXOG7sMQcx96THgWGjR4vaRQIq5HZQNZAaSF14YI81xiwm5c4lyjc1
	 oquXhx5PuX3pIb3FQ5qA4HR7VLzSvRj5AuTcgVL/t/89xOWm1kRzOs1qZbNywLq56I
	 uL1Be+p0lWcnbygMIpkryqspjdF5Gy8fxb/c5D4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.18 032/188] media: intel/ipu6: fix error pointer dereference
Date: Fri, 15 May 2026 17:47:29 +0200
Message-ID: <20260515154658.004801934@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Ethan Tidmore <ethantidmore06@gmail.com>

commit 8dd088b8b106f7b119664f965b691785998edcfb upstream.

In a error path isp->psys is confirmed to be an error pointer not NULL so
this condition is true and the error pointer is dereferenced. So isp-psys
should be set to NULL before going to out_ipu6_bus_del_devices.

Detected by Smatch:
drivers/media/pci/intel/ipu6/ipu6.c:690 ipu6_pci_probe() error:
'isp->psys' dereferencing possible ERR_PTR()

Fixes: 25fedc021985a ("media: intel/ipu6: add Intel IPU6 PCI device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
[Sakari Ailus: Fix commit message.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu6/ipu6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/pci/intel/ipu6/ipu6.c
+++ b/drivers/media/pci/intel/ipu6/ipu6.c
@@ -686,7 +686,7 @@ out_free_irq:
 out_ipu6_rpm_put:
 	pm_runtime_put_sync(&isp->psys->auxdev.dev);
 out_ipu6_bus_del_devices:
-	if (isp->psys) {
+	if (!IS_ERR_OR_NULL(isp->psys)) {
 		ipu6_cpd_free_pkg_dir(isp->psys);
 		ipu6_buttress_unmap_fw_image(isp->psys, &isp->psys->fw_sgt);
 	}


