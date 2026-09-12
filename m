Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E9C343893;
	Sat, 12 Sep 2026 09:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206751; cv=none; b=Ei3xLd3Pcd/s3DEYM6DXYnDleyJPlAQTIB4+CqhOj64t9f6uaD0KNUqWJ24D3lfHgK39gzFYQ0oz6Ki4eC8mkkRHMaqCm3S4sO0gpjftypsDEejSO3ke0JCyaSKheYlAjMq2jNc/ryOeUJh0tLsQFBXCkPrPpx3EFunvhhdwsws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206751; c=relaxed/simple;
	bh=YTjlA7c0OSX+K970RM14aecxt+UOm40Z3hINsvPzm2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTdzxfTJSvPKJPfXE3IpNFGa3aHSC1NQo8kN2ri8kOqz/BTct7Q+VuzjGDyxW79w93JwC6/oU0ala6FSBa4TCmPxfRU8AiBJ0iClVgeHubPyVcHGS/FNBSfndlwuD+HxsS8j+b3N144UpkyEpYlfUw4rCOCEwcENcEL1RomUolE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWVfbs3R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWVfbs3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AB61F000FF;
	Sat, 12 Sep 2026 09:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206750;
	bh=g0XUrTHN+htG1NfdGE3ONfqAgOG2vZfMlRjLriFSZ6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wWVfbs3RYEA3N6wujgRGs+M6kPRZ2QzJJDIInRnmkC7K94Ay6yDHn4B+Bzu8vm/Do
	 Z+37q/F+mKjDwms+Qi/DcW7BDaGgQHH9D5KNMLZJhVJRvr++levno7LkixMlpcSVF6
	 eIDOWJlFzmz5MDMV30exztVs3c68XF/xQqjsf9e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0269/1518] usb: typec: ucsi: unregister debugfs entries on teardown
Date: Sat, 12 Sep 2026 08:40:38 +0200
Message-ID: <20260912065629.572136098@linuxfoundation.org>
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

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit eed73a65ab609b79d53de88cccc34b36dfe753c4 ]

ucsi_register() creates per-instance debugfs entries, but
ucsi_unregister() keeps them around until ucsi_destroy().

Drivers like ucsi_glink that unregister/register the same UCSI
instance across remoteproc restart then try to create an already
existing debugfs directory and log:

  debugfs: 'pmic_glink.ucsi.0' already exists in 'ucsi'

Unregister debugfs entries as part of ucsi_unregister(), and
clear ucsi->debugfs after freeing it so repeated unregister
paths remain safe.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Fixes: df0383ffad64 ("usb: typec: ucsi: Add debugfs for ucsi commands")
Tested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com> # X1E80100 CRD
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260611-usci-unregister-debugfs-v1-1-f4a518a94f27@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/debugfs.c | 1 +
 drivers/usb/typec/ucsi/ucsi.c    | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/usb/typec/ucsi/debugfs.c b/drivers/usb/typec/ucsi/debugfs.c
index f73f2b54554e2..414ffe1d23780 100644
--- a/drivers/usb/typec/ucsi/debugfs.c
+++ b/drivers/usb/typec/ucsi/debugfs.c
@@ -129,6 +129,7 @@ void ucsi_debugfs_unregister(struct ucsi *ucsi)
 
 	debugfs_remove_recursive(ucsi->debugfs->dentry);
 	kfree(ucsi->debugfs);
+	ucsi->debugfs = NULL;
 }
 
 void ucsi_debugfs_init(void)
diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 85e2e7fcd02cd..2acd48a0a6a2b 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -2275,6 +2275,8 @@ void ucsi_unregister(struct ucsi *ucsi)
 	cancel_delayed_work_sync(&ucsi->work);
 	cancel_work_sync(&ucsi->resume_work);
 
+	ucsi_debugfs_unregister(ucsi);
+
 	/* Disable notifications */
 	ucsi->ops->async_control(ucsi, cmd);
 
-- 
2.53.0



