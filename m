Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DE23FF1D5;
	Fri, 15 May 2026 15:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860369; cv=none; b=UhlblNFG9sacSABNT1UsF6ecFG9oYiNj5A0AdZNG/yKzLI12O7+YAn/wVDVCt4LzQyCD9zCwzHIHPnNqaJXm0RRUignFE1NIrq9Y7X0qw+8eTuGIctGtXX57Ergm3Cg2giI2Mg2p8RqjBmNcASEB/mRiZrKMTMVzI2gu6OZUDLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860369; c=relaxed/simple;
	bh=wOPqWAp4L0MNR4N4eLK0oL6p5Z9C7s1m3m2wBE/ncYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGXZAOMBBpuJzxco/9YulpSemixpIf1zD5GiFYRtfZTXL3vq5wqB7Nuq+Nj3dC+nGjXEZu90wKbw6a7hba2cFC4brFzWucKR5iXo4iGJTO7PN37bkB400Ygk9aGqBbYqXXZhW3zxv16Xn/5LEeZ2C7XSjoHAzfPtgSizUAV2urw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtrhFck+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtrhFck+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E40C2BCB0;
	Fri, 15 May 2026 15:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860369;
	bh=wOPqWAp4L0MNR4N4eLK0oL6p5Z9C7s1m3m2wBE/ncYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtrhFck+NxsMXQ0MotphCAfFdJ984pC898KcaN1pYxg/68UE96Ad2wFwdwXrTW70E
	 aAGPRXrj1MIeWQo6URD07p9J3M/Au/21ci92dHSYCUqfT17OSHDaDVC8YClg5xjEqx
	 7ixX5ve7vhC2BxTlrcRQLmFWHy/1zstzOpwUn4r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 020/144] media: intel/ipu6: fix error pointer dereference
Date: Fri, 15 May 2026 17:47:26 +0200
Message-ID: <20260515154653.964717970@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -685,7 +685,7 @@ out_free_irq:
 out_ipu6_rpm_put:
 	pm_runtime_put_sync(&isp->psys->auxdev.dev);
 out_ipu6_bus_del_devices:
-	if (isp->psys) {
+	if (!IS_ERR_OR_NULL(isp->psys)) {
 		ipu6_cpd_free_pkg_dir(isp->psys);
 		ipu6_buttress_unmap_fw_image(isp->psys, &isp->psys->fw_sgt);
 	}


