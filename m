Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0136312E;
	Tue, 23 Jan 2024 01:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974998; cv=none; b=BhN+HefeAU4dOOtYEaDUDJFiCvipMHo2QxHkcG/+Soh+fjtObGkZLb546sAo56zriL2lUS5yxN6xmboXW6EOP6TBYF4oKOB9MJR5YpV9INBFYhCJgavYtO+ALRza1u5Ti1cT5uWgDgUO1nE+xC3PPD0bNFCrfQm3Fj6Vk5/qTtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974998; c=relaxed/simple;
	bh=qoPtLPXz5LQqq/VHO6mpi001bdxQBGEvEW35F5TjX0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1K4NsyvbOzV5OmjwNgoDdPrJ4XHctNmgtud7h3SlQk1FqFjhrhB8BRmQeGHldK2BXgnsdYuAZKSHbCFWcnXGTFP3b3XNzCA9DYwiEnJhTuv8xgsSukd1LOJ4C6CRJmk0MX1YZbsuURycznkaRL5Y1uJitExzA/qyCcKIUggRfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQEO+R5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQEO+R5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC2BC43399;
	Tue, 23 Jan 2024 01:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974998;
	bh=qoPtLPXz5LQqq/VHO6mpi001bdxQBGEvEW35F5TjX0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQEO+R5DHbsMt9D7zURMNUgSRprcc3mQ8g+qF+SPHIdoSAGQt0B29v933H+LgPK0m
	 3TolN9wGf2ciy3seGBCBYJclAX3Gn1RTu6mB47OK+O8VxMK5/3qUzDqP7AFcye1gWq
	 tjpSeHg5r6pjaJNEE9yuOP7XrCdLFOspJPFi/z0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/583] scsi: hisi_sas: Replace with standard error code return value
Date: Mon, 22 Jan 2024 15:53:31 -0800
Message-ID: <20240122235816.940222020@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit d34ee535705eb43885bc0f561c63046f697355ad ]

In function hisi_sas_controller_prereset(), -ENOSYS (Function not
implemented) should be returned if the driver does not support .soft_reset.
Returns -EPERM (Operation not permitted) if HISI_SAS_RESETTING_BIT is
already be set.

In function _suspend_v3_hw(), returns -EPERM (Operation not permitted) if
HISI_SAS_RESETTING_BIT is already be set.

Fixes: 4522204ab218 ("scsi: hisi_sas: tidy host controller reset function a bit")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1702525516-51258-3-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9472b9743aef..6dfa8be17ea4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1565,12 +1565,12 @@ EXPORT_SYMBOL_GPL(hisi_sas_controller_reset_done);
 static int hisi_sas_controller_prereset(struct hisi_hba *hisi_hba)
 {
 	if (!hisi_hba->hw->soft_reset)
-		return -1;
+		return -ENOENT;
 
 	down(&hisi_hba->sem);
 	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags)) {
 		up(&hisi_hba->sem);
-		return -1;
+		return -EPERM;
 	}
 
 	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 089186fe1791..568bd8052639 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -5148,7 +5148,7 @@ static int _suspend_v3_hw(struct device *device)
 	}
 
 	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags))
-		return -1;
+		return -EPERM;
 
 	dev_warn(dev, "entering suspend state\n");
 
-- 
2.43.0



