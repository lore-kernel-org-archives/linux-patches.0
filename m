Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7D847127A;
	Tue, 21 Jul 2026 18:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659917; cv=none; b=t/7F5zjaWRORoJmLcf7B/WVymvlQVRKMWifA7xd0nnuMklyhkGNqIRzfqTLTOn4i0US+H2qm7Xr0stxnDRF1LHd9jYR9Lt1ra+bcT+p6Fg2RhjEG9Swm4vYm6iPel4rxdpuKNEbnSMcxts2biahdlPgmVxLL5vEeLR57ZK+WCJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659917; c=relaxed/simple;
	bh=OzpunsyFjzkjz7JKRvbCBvzbGocVJ8ZKii+Xgy+hg6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ava3QFZsrZHbcm5rfGbRS2GLxf66XVhoiYQLm5hfYOksaq8BerS1uRpKJyV0GwvXCrC8EqolFqZV4yNwSHfyloiosvOAOQDQ5z+B7KtS7EXFlz2oowpDltEhdBL37BXhMc/SBsw9K4WAIdkC3yEwQ1MKG/J1dkCeJz2aynAyKsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mA24MY54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mA24MY54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BAF1F000E9;
	Tue, 21 Jul 2026 18:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659916;
	bh=I7F9y5w0MHyixIViagDTkj/U/CMflx+kfxnpkQxCdBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mA24MY541medCEWaR4ODPOK44MtCjRmywrKFUOtdP5+EFxslGqEuhKD8beTiNO0x0
	 7wARskeXDEc4NzT0WXUzLfYhZpkGxtmY61G9raDYXFwUJvat6FesZ9nf3N/kBLSUqc
	 1dkxGz85bcje9YIuPwjj7JrEX3HnvvpQlvqDLJIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Alejandro Lucero <alucerop@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0738/2077] cxl/memdev: Pin parents for entire memdev lifetime
Date: Tue, 21 Jul 2026 17:06:51 +0200
Message-ID: <20260721152610.203305086@linuxfoundation.org>
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

From: Dan Williams <djbw@kernel.org>

[ Upstream commit bd3a6ff4b84e0fc3fca8556d338270603df13f2e ]

In order to be able to manage the driver that uses a memdev attach
mechanism the parent needs to stick around for the
device_release_driver(cxlmd->dev.parent) event.

Fixes: 29317f8dc6ed ("cxl/mem: Introduce cxl_memdev_attach for CXL-dependent operation")
Signed-off-by: Dan Williams <djbw@kernel.org>
Reviewed-by: Alejandro Lucero <alucerop@amd.com>
Tested-by: ALejandro Lucero <alucerop@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260519210158.1499795-4-djbw@kernel.org
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/memdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 80e65690eb773e..91c99eeea92ce4 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -25,9 +25,11 @@ static DEFINE_IDA(cxl_memdev_ida);
 static void cxl_memdev_release(struct device *dev)
 {
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct device *parent = dev->parent;
 
 	ida_free(&cxl_memdev_ida, cxlmd->id);
 	kfree(cxlmd);
+	put_device(parent);
 }
 
 static char *cxl_memdev_devnode(const struct device *dev, umode_t *mode, kuid_t *uid,
@@ -707,7 +709,7 @@ static struct cxl_memdev *cxl_memdev_alloc(struct cxl_dev_state *cxlds,
 	dev = &cxlmd->dev;
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &cxl_memdev_key);
-	dev->parent = cxlds->dev;
+	dev->parent = get_device(cxlds->dev);
 	dev->bus = &cxl_bus_type;
 	dev->devt = MKDEV(cxl_mem_major, cxlmd->id);
 	dev->type = &cxl_memdev_type;
-- 
2.53.0



