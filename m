Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEA735F184;
	Sat, 12 Sep 2026 08:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200300; cv=none; b=s0Kv0FfH5Jf2HIsQLOd/0idD7DlmQXFk6jw1x2VobgoqbXKzBv0s8GNn2TaEz99KGmymTtT4Tz+e1x3aT4VO+RjQLKlj9uDhCBpp6SDPHoohrNZPswtC9LnqAXuzBV54PLRKiUug6c99wn4PcZl4gJ+9iyUYoqAe+ViceWo9Un4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200300; c=relaxed/simple;
	bh=Evgp1VJQ7Cj4hBS4KiapSsMaAJL4aC5a8uSBszEWANs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrXS4GqcUtOOiokTgki7brDtSWVIlXUltgwXlLQTl5+Fba25IMwVDAuLpBOAht/aukcxTZxMWUERkZKgXadlat/1ax/WSBQVChLiHa8d+3O2Ngph/A52jDUJOTfVzcoUNybiZw+kDsgfEYe3whQBNDhVKnmujvgrVf6ONNIxA/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+SVL2/g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+SVL2/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F201F000FF;
	Sat, 12 Sep 2026 08:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200299;
	bh=CGeFCy9AY9QFLqVPMJFboE/pOlvNNapwcUH+SS9eodw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+SVL2/g/NXV8FHETiYf/upynp2Edrt53zqwQ6Jwpfo0YZWgSlR7RUWvSq8t33diY
	 oQ9EFt/7WsWkQhCnBsy6h2ufPeu2JEhfH94GRQpn7eaNR2lQPL6OsKn6Ty/2i4g7G/
	 jWXGlzYW2PLzKTSk6X9hIxinw4kiiJbEp/jQLFyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0761/1815] bus: mhi: host: Fix controller cleanup on EDL sysfs failure
Date: Sat, 12 Sep 2026 08:41:51 +0200
Message-ID: <20260912065706.773406527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 12dcb1a2753c7..fd3050889412d 100644
--- a/drivers/bus/mhi/host/init.c
+++ b/drivers/bus/mhi/host/init.c
@@ -1029,7 +1029,7 @@ int mhi_register_controller(struct mhi_controller *mhi_cntrl,
 	if (mhi_cntrl->edl_trigger) {
 		ret = sysfs_create_file(&mhi_dev->dev.kobj, &dev_attr_trigger_edl.attr);
 		if (ret)
-			goto err_release_dev;
+			goto err_del_dev;
 	}
 
 	mhi_cntrl->mhi_dev = mhi_dev;
@@ -1038,6 +1038,8 @@ int mhi_register_controller(struct mhi_controller *mhi_cntrl,
 
 	return 0;
 
+err_del_dev:
+	device_del(&mhi_dev->dev);
 err_release_dev:
 	put_device(&mhi_dev->dev);
 error_setup_irq:
-- 
2.53.0



