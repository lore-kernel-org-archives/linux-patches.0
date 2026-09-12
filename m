Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BCA4BEE22;
	Sat, 12 Sep 2026 12:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216451; cv=none; b=DJsPFppTuPuODJ2xGioprdy4p/M4bBYbIK9oQbX1yhn9baHVAxIV7cZtPijeXZsYjhFFYMBVr6mkHaH1Qiz0YcTW9ZKjEy8iY8D8iJdUbgu5BYmf0f3lyoT6F1r7oMNLAO3aLV8tLb4weludTOu1SBQsyc16dxMZJS34dLZvjb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216451; c=relaxed/simple;
	bh=f1jl8SPCZgwCznc3mhwDazhyxVgodAXSQD3YQuBn7TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcwrDoPP4tyFtagN0bHLW6qTXdEt5ae3HxkRDviyDvmKHZcQlgC0XKvm7GIAvnSjqw3Fm7K7opmA/ssDDjqdxunRsmwxDOyJz0YihbCZ5BO9Vu+0h64P/1W5G7kIxyxESBHQ5ino5QBNb2O1/tVNEnATVwP6oFTVNK/qNviUmFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5jH0Rm9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5jH0Rm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9951F000FF;
	Sat, 12 Sep 2026 12:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216450;
	bh=q3xWsWEtJrqaUc7b5nkyYxfIB9DRgEHJsZLq/jtrCR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5jH0Rm9xUB136RQTTvao7wCeuawtCFUzrdEnRx+Ft60LYjkOvJWOUCmL4PjWyHwl
	 9tnA1mxy6bXV6zX/+0iT9/SxdCn8AhPoZhcC9DkLRhTXmUyALDR+cDff4MVs6TyaTh
	 v8UkUV/Z0Ww2y/q/xnnbmPoXtSKIzKnPJ71gRVK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0737/1376] bus: mhi: host: Fix controller cleanup on EDL sysfs failure
Date: Sat, 12 Sep 2026 08:52:43 +0200
Message-ID: <20260912065623.969239980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 223fc54c45b3e..9a917f14ab1b7 100644
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



