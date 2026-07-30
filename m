Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DFB395ADB;
	Thu, 30 Jul 2026 16:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427639; cv=none; b=Do4ZsKIvpyiA4llRMyNm5or7l7BqDMGUa1HIkp1HDWJsluBScLGvYWDpU5JzXwcIFmqmsGDWbrqv8ZwJTj33rCemfNojLZkxmVnSGG0uEkNdv+PJKKrhguoZ0UKmqZUHc7/jjmvfZs6rnoBVX64PGbSOym1G/X8Y9GrMcmehDBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427639; c=relaxed/simple;
	bh=if0TbEYIojBM9Z8Stj8kR2LXFj3MhIXN7MwvPaYf2vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IM12MwDLgg5BLGe/86nynxqeJWupbuPaniG3+o+fIfQBtk+dpi2LrP0KDo4eZYk++nw8Z8P9Bi0TlqWz2yL3QWc5PTUQ3w1GMhG8fRwpb+7JaykPLD09/W4m7kieDq7EuRqFgEB1/afkLxuKg9v3tnIBWZL+rpL4Ii8QOocX9Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyx0bjD2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyx0bjD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB501F000E9;
	Thu, 30 Jul 2026 16:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427638;
	bh=lko6+VR6HpPhT0O1CKxI/YWCzkdi8+C5qa5jnEGbVLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eyx0bjD2Oyu/xMh9XTxWoPBjpOjEg+nm5lpDVsL6GyUslRTvWvclQhpSPCRPGEHZD
	 xMOv8OXnet42bU1hKDIgQC3hHx0CkP4PYod0uawvKIUnRmLNV+H/lOwEBA05o/zjSS
	 F+jmms0E53AH4jOhfCfn9TMPN5cVOENWrwy+5Sl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 242/484] media: marvell-cam: fix missing pci_disable_device() on remove
Date: Thu, 30 Jul 2026 16:12:19 +0200
Message-ID: <20260730141428.739535308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 033ff0420e4c9c240ae5523fff39770298efa964 upstream.

During manual code audit, we found that cafe_pci_probe() enables the
PCI device with pci_enable_device(), and its probe error path properly
calls pci_disable_device() on failure.

However, cafe_pci_remove() tears down the controller and frees the
driver data without disabling the PCI device, leaving the remove path
inconsistent with probe cleanup.

Add the missing pci_disable_device() call to cafe_pci_remove().

Fixes: abfa3df36c01 ("[media] marvell-cam: Separate out the Marvell camera core")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/marvell/cafe-driver.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/marvell/cafe-driver.c
+++ b/drivers/media/platform/marvell/cafe-driver.c
@@ -609,6 +609,7 @@ static void cafe_pci_remove(struct pci_d
 		return;
 	}
 	cafe_shutdown(cam);
+	pci_disable_device(pdev);
 	kfree(cam);
 }
 


