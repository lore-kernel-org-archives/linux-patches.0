Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9AD346E51;
	Tue, 16 Dec 2025 11:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885553; cv=none; b=PmeKRZWZ2xLEUJU8Xd/WA6g7oVy6uIChevCv+jnm3nSRkH0ycVP8SvpM6iTVwmoTtZDgUw/HsBcpGtIIUO8rSIGdwbxEPpp/OUqAzdkp+sUjq766hIhRjjjpvlk81gJ+8sKoyK+1w19X7w08rXljMNyA3fmnQzabWo9OkRC6/QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885553; c=relaxed/simple;
	bh=FQ3B3C6JXd5bl4UL4qRcwkf7yrJGLCdbyJ0dj7dfOWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqJhpjUc7n7L0veTxC0Omt7M//s0Hs+9KLdLGWjdvmvJaJQQh5c3YvCXt7gyG1depkOdNfiNzTS4GcatsaW31RI1gNkH5tcvmbJhRyMQgvkDNL6HkP8WwWzoHaoPj1BbhWeqUQednpK0CWD1kmnrV5SpYddT7ZvDXR8eCnyM8mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oy15ZxQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oy15ZxQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0521C4CEF1;
	Tue, 16 Dec 2025 11:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885553;
	bh=FQ3B3C6JXd5bl4UL4qRcwkf7yrJGLCdbyJ0dj7dfOWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oy15ZxQS63Uy8moFkLAameI1A1QvfQ91fJSytKoUzfRe1cAPijNs+7Nh4skqi1UGA
	 sosFGuBKXGqOujeF+ODUnaqtmFbYQLQ+oWfI7QlCdDa428D3IJBpAl3FtNwKe35F+e
	 Nek7urk9dMK+punCilFYpYTfz8vYFUvUBquhu1tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	a-development <a-development@posteo.de>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 139/507] wifi: ath12k: fix error handling in creating hardware group
Date: Tue, 16 Dec 2025 12:09:40 +0100
Message-ID: <20251216111350.564599316@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 088a099690e4c0d291db505013317ab5dd58b4d5 ]

In ath12k_core_init() when ath12k_core_hw_group_create() fails,
ath12k_core_hw_group_destroy() is called where for each device below
path would get executed

	ath12k_core_soc_destroy()
		ath12k_qmi_deinit_service()
			qmi_handle_release()

This results in kernel crash in case one of the device fails at
qmi_handle_init() when creating hardware group:

ath12k_pci 0000:10:00.0: failed to initialize qmi handle
ath12k_pci 0000:10:00.0: failed to initialize qmi :-517
ath12k_pci 0000:10:00.0: failed to create soc core: -517
ath12k_pci 0000:10:00.0: unable to create hw group
BUG: unable to handle page fault for address: ffffffffffffffb7
RIP: 0010:qmi_handle_release
Call Trace:
 <TASK>
 ath12k_qmi_deinit_service
 ath12k_core_hw_group_destroy
 ath12k_core_init
 ath12k_pci_probe

The detailed reason is, when qmi_handle_init() fails for a device
ab->qmi.handle is not correctly initialized. Then
ath12k_core_hw_group_create() returns failure, since error handing
is done for all device, eventually qmi_handle_release() is called for the
issue device and finally kernel crashes due to the uninitialized
ab->qmi.handle.

Fix this by moving error handling to ath12k_core_hw_group_create(), this
way the issue device can be skipped.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00284.1-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: 6f245ea0ec6c ("wifi: ath12k: introduce device group abstraction")
Link: https://lore.kernel.org/ath12k/fabc97122016d1a66a53ddedd965d134@posteo.net
Reported-by: a-development <a-development@posteo.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220518
Tested-by: a-development <a-development@posteo.de>
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20251030-fix-hw-group-create-err-handling-v1-1-0659e4d15fb9@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 5d494c5cdc0da..a2137b363c2fe 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -2106,14 +2106,27 @@ static int ath12k_core_hw_group_create(struct ath12k_hw_group *ag)
 		ret = ath12k_core_soc_create(ab);
 		if (ret) {
 			mutex_unlock(&ab->core_lock);
-			ath12k_err(ab, "failed to create soc core: %d\n", ret);
-			return ret;
+			ath12k_err(ab, "failed to create soc %d core: %d\n", i, ret);
+			goto destroy;
 		}
 
 		mutex_unlock(&ab->core_lock);
 	}
 
 	return 0;
+
+destroy:
+	for (i--; i >= 0; i--) {
+		ab = ag->ab[i];
+		if (!ab)
+			continue;
+
+		mutex_lock(&ab->core_lock);
+		ath12k_core_soc_destroy(ab);
+		mutex_unlock(&ab->core_lock);
+	}
+
+	return ret;
 }
 
 void ath12k_core_hw_group_set_mlo_capable(struct ath12k_hw_group *ag)
@@ -2188,7 +2201,7 @@ int ath12k_core_init(struct ath12k_base *ab)
 		if (ret) {
 			mutex_unlock(&ag->mutex);
 			ath12k_warn(ab, "unable to create hw group\n");
-			goto err_destroy_hw_group;
+			goto err_unassign_hw_group;
 		}
 	}
 
@@ -2196,8 +2209,7 @@ int ath12k_core_init(struct ath12k_base *ab)
 
 	return 0;
 
-err_destroy_hw_group:
-	ath12k_core_hw_group_destroy(ab->ag);
+err_unassign_hw_group:
 	ath12k_core_hw_group_unassign(ab);
 err_unregister_notifier:
 	ath12k_core_panic_notifier_unregister(ab);
-- 
2.51.0



