Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627D74E3236;
	Thu, 17 Sep 2026 15:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660221; cv=none; b=o0sj/8g+zBdnLHkgYurn5yPiNnINNQuAwJeiIxeJw3Wms+12yLpNHSYYJKzHsO2/ZCP/2K3W7YsbbGbsbgRqHpRgFYQM6EbHrmGB98sH0Cr9+tf2EaaT2mIb6K4CJbpsSKXuFe41SWuwAVJdY3JS6/iN7BOT1aNKh9smQKDnkgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660221; c=relaxed/simple;
	bh=4YHjsupvEbg/FugPo0cT5WZDAclKS3W0DTibQ9pIP0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPh9sBQbaVGaWA3NkbMp14s6rmBeG8aW9Q1TGa1QQgtSyxU9NFCD9/nPgR+m1JBLUoTWxyyFZR6khzDbZlMIsJ0tFP5E7bh5xQ2d7JdWWYYqGsdW/J917PS6uLRuKeT0XUiVZaB4NIxE2x1ue2OEG6kNRWMISencfpZmXPsHFy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POXhLVu0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POXhLVu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17641F0089B;
	Thu, 17 Sep 2026 15:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660212;
	bh=Hjj6wMtBElPKPvOTNix8v+1YZ5WeFrLwoZflbJGZCb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POXhLVu0W/NgrAq5hR/8+Aa4R2cc+yzdhOeTcrjKB6COX3exSeQBzpFfDT0PHg1WM
	 3JBwBalBqt/6Argonc8a12u/5zvkVeJhQuaUewnTK0eBfEvMBwopQE5LDrYIBfU/rJ
	 NVA1GP0Z+hJbYgXtv82hzSGD3lqoFez/Gg2fad7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Xu Rao <raoxu@uniontech.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 516/733] Bluetooth: btqcomsmd: destroy RPMsg endpoints before freeing hci_dev
Date: Thu, 17 Sep 2026 16:13:44 +0100
Message-ID: <20260917151405.003120396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit f5a427b16e45210dee656b0860728f3d496dee85 upstream.

The command and ACL RPMsg endpoints store struct btqcomsmd as their
callback private data. The receive callbacks dereference btq->hdev
without taking an hci_dev reference.

The current teardown order frees the hci_dev before destroying the RPMsg
endpoints in both the hci_register_dev() error path and the driver remove
path. If WCNSS delivers data in that window, the endpoint callback can
run with an already freed hci_dev and pass it to the Bluetooth core.

For qcom_smd endpoints, rpmsg_destroy_ept() closes the channel and clears
the callback under the channel recv_lock. The receive path holds the same
lock while invoking the callback, so destroying the endpoints first both
prevents new callbacks and serializes with any callback already running.

Destroy the command and ACL endpoints before hci_free_dev(). Keep
hci_unregister_dev() first during remove so the HCI core stops issuing
operations before the transport endpoints are shut down. In the full
registration-error cleanup path, return directly after freeing the hci_dev
to avoid falling through to the partial-construction labels and destroying
the endpoints twice.

Fixes: 5052de8deff5 ("soc: qcom: smd: Transition client drivers from smd to rpmsg")
Fixes: 9a39a927be01 ("Bluetooth: btqcomsmd: Fix a resource leak in error handling paths in the probe function")
Cc: stable@vger.kernel.org
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btqcomsmd.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/btqcomsmd.c
+++ b/drivers/bluetooth/btqcomsmd.c
@@ -188,7 +188,10 @@ static int btqcomsmd_probe(struct platfo
 	return 0;
 
 hci_free_dev:
+	rpmsg_destroy_ept(btq->cmd_channel);
+	rpmsg_destroy_ept(btq->acl_channel);
 	hci_free_dev(hdev);
+	return ret;
 destroy_cmd_channel:
 	rpmsg_destroy_ept(btq->cmd_channel);
 destroy_acl_channel:
@@ -202,10 +205,11 @@ static void btqcomsmd_remove(struct plat
 	struct btqcomsmd *btq = platform_get_drvdata(pdev);
 
 	hci_unregister_dev(btq->hdev);
-	hci_free_dev(btq->hdev);
 
 	rpmsg_destroy_ept(btq->cmd_channel);
 	rpmsg_destroy_ept(btq->acl_channel);
+
+	hci_free_dev(btq->hdev);
 }
 
 static const struct of_device_id btqcomsmd_of_match[] = {


