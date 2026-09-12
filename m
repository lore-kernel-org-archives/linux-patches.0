Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3A32264A6;
	Sat, 12 Sep 2026 10:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208799; cv=none; b=YXNKt5tQMCcHfW5FDQ3XMz+PBv7qJX2BeMTPRuZBPgFKjHICnGQL2Gs4hQbIqHPzmImKjvzn7sAlI8hhwWQgue2TienNI70vQC7auKrY8xkavEqZxUVouHcFa84nteNu7tlKdjXd1RmIDSMHJF8rSXvOzOekoachLNMq21izCtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208799; c=relaxed/simple;
	bh=EnI3QZTp/Ua/AQnhR6rFQjj5CBHeeyCEV2/FjIhWNKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2An7KuOHBiE9UHTtCBIE6nT+K8Io3sd/nOK7RzLFKXi0OfPsmsaaZimtWaUtGPcsqywL+DLwJTeEGGYj3MYFWShJAatk5mc9r2lCWccDquZZB5QI3SXqKEptoJjagfHMLaTYRnI77GXIlimXgI4o0r0IeO8Ndr6F7kdbTuvens=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6U3ghDV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6U3ghDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E761F000FF;
	Sat, 12 Sep 2026 10:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208798;
	bh=sowJm5N5Xqoe3vUCC99eQkBBbR+ZVyMCas3jdxhMAw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k6U3ghDVWenN470NDqVSHDTa9EWjb80uFmfQuFHEW74SRM/voreSmQG5Vy8jF2an4
	 88hGnzC4eMZb76ZSeG8cI8QC1+xWeWylK1EgYIEr1c16rSZY1+kEDA4Q4BwFNXPAxt
	 9drUPF8PxSx/WbNqn6gRA+ZKuyFIeGVZDoiFlEJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0649/1518] bus: mhi: host: Fix controller cleanup on EDL sysfs failure
Date: Sat, 12 Sep 2026 08:46:58 +0200
Message-ID: <20260912065638.112452046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 0d5b9e66591d4e2a4376ac82c8cda889a29ba3ee ]

mhi_register_controller() adds the controller device before creating the
optional trigger_edl sysfs file. If sysfs_create_file() fails, the error
path only drops the device reference and leaves the device registered.

Hence, call device_del() in the error path before put_device().

Fixes: 17553ba8e19d ("bus: mhi: host: Add sysfs entry to force device to enter EDL")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/host/init.c b/drivers/bus/mhi/host/init.c
index 099be8dd19007..504a5d3f78309 100644
--- a/drivers/bus/mhi/host/init.c
+++ b/drivers/bus/mhi/host/init.c
@@ -1042,7 +1042,7 @@ int mhi_register_controller(struct mhi_controller *mhi_cntrl,
 	if (mhi_cntrl->edl_trigger) {
 		ret = sysfs_create_file(&mhi_dev->dev.kobj, &dev_attr_trigger_edl.attr);
 		if (ret)
-			goto err_release_dev;
+			goto err_del_dev;
 	}
 
 	mhi_cntrl->mhi_dev = mhi_dev;
@@ -1051,6 +1051,8 @@ int mhi_register_controller(struct mhi_controller *mhi_cntrl,
 
 	return 0;
 
+err_del_dev:
+	device_del(&mhi_dev->dev);
 err_release_dev:
 	put_device(&mhi_dev->dev);
 error_setup_irq:
-- 
2.53.0



