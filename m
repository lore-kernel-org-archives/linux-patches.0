Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331E2299920;
	Sat, 12 Sep 2026 12:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215043; cv=none; b=a1QT5GLrtGENHIba4HY/ZOII7/vejuYY04ojgbLiDG98tT17YCqtxMyVnw02Fa/MZMAiSQFCIEGxpZPNC3CPUgeRx3/YQkDS+v3aQoQTdpq0zHFgN5oGEHooYN4FyDHvVe2PqedEE/IslFzLkkeSipUAfZr9XmnkLiiHeZntl1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215043; c=relaxed/simple;
	bh=tW+OrfkLpkU6lOgn7Gc9CXC2VhHmbaUt48Cse5vPFKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1QVnMANbMW44qvw8qp46r1NJPYxdNAfzmAbwbN6vEWMdl/c1xdVqkWwnKk5HPqsooPmLKtK/zjwvpCav65O9dC9ySHEMKX63pADd9m/YASQM32b1p+jjTQVV5SODnYqFccfiO77lc+0qIyscG9K1JlzNpQ8mvW0U11Sa7wmW10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqJA7ewJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqJA7ewJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30E31F000FF;
	Sat, 12 Sep 2026 12:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215040;
	bh=ek+RG31eM2PDLLQRFLd5LIm7FRnYvHEKRTHUQEVZ264=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iqJA7ewJ4YOilEuCVfxvnSA9h0CbM/FGECDWFEQ/mznQyB2kKp94L5kXtwTZmIXnK
	 EcXiFnoQoklMdR1I/SVsOqiECmU5AkonUYxrYu3V5y37QG4LCQwddjff4gBl7SFkpJ
	 Z2Teo1mNkqdLw97pWPX3J4NqTc/9LBXAWNdRWX14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0450/1376] usb: typec: ucsi: unregister debugfs entries on teardown
Date: Sat, 12 Sep 2026 08:47:56 +0200
Message-ID: <20260912065617.561365867@linuxfoundation.org>
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
index f67733cecfdf5..2f5a3ae1fd852 100644
--- a/drivers/usb/typec/ucsi/debugfs.c
+++ b/drivers/usb/typec/ucsi/debugfs.c
@@ -89,6 +89,7 @@ void ucsi_debugfs_unregister(struct ucsi *ucsi)
 
 	debugfs_remove_recursive(ucsi->debugfs->dentry);
 	kfree(ucsi->debugfs);
+	ucsi->debugfs = NULL;
 }
 
 void ucsi_debugfs_init(void)
diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 5e7226aed7005..b80f68e34d21d 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -2102,6 +2102,8 @@ void ucsi_unregister(struct ucsi *ucsi)
 	cancel_delayed_work_sync(&ucsi->work);
 	cancel_work_sync(&ucsi->resume_work);
 
+	ucsi_debugfs_unregister(ucsi);
+
 	/* Disable notifications */
 	ucsi->ops->async_control(ucsi, cmd);
 
-- 
2.53.0



