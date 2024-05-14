Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A2B4F88C;
	Tue, 14 May 2024 10:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683873; cv=none; b=A3BnmmSgxSlUZ/FN2yCVHW96cJK3gicvpelXi7nVY8nW7EUC3kC/5EQ/RxIVuVS9oQFqqnP0Awcqcs+WKHLHZDPgsbvKe7jLCOdcxTzJf2VEmqX0rcGwhXr4o9IKsotBl7tOnBdTfWqh4ryXM8RtcZGM1/e7bXQuGp05/qo1VWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683873; c=relaxed/simple;
	bh=fuVyx1cAq2VPG9iswknsiKBOhhFoHlxw5gTVwIznHp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMjuU8vYMqcNSyLdz/+HKrsRyBIuwIQ7xxknB7MbQgrTwkG8xy0fwcbLELNzVt1CSEXGF4kAMwqTPDwbts3mjySLIsCE670ejc1kUCdVLuuqHwXwH2EFCMq4A9cUdCrdziO3mz8Qnqa8Y0Kt5sLbcgQ1c8iyrsfrBiqX/FScP0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glLj4BeZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glLj4BeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82619C2BD10;
	Tue, 14 May 2024 10:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683873;
	bh=fuVyx1cAq2VPG9iswknsiKBOhhFoHlxw5gTVwIznHp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glLj4BeZGgE3KddBQXveKonl4ycyMpeqYljk+5GzLenElGtS0dTtXti4HGaiTyFm3
	 gjh0tIHJ3Epu0m25rHEhHgsTq+gbjn3WGD4dskNdvUGAoE+Eyl4ZWaO5NZCVO5FbOu
	 4JgImGngq9VKdDs0f9SrVO6j+T9jufFEOyzNFZtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Viken Dadhaniya <quic_vdadhani@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.8 288/336] slimbus: qcom-ngd-ctrl: Add timeout for wait operation
Date: Tue, 14 May 2024 12:18:12 +0200
Message-ID: <20240514101049.490320429@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <quic_vdadhani@quicinc.com>

commit 98241a774db49988f25b7b3657026ce51ccec293 upstream.

In current driver qcom_slim_ngd_up_worker() indefinitely
waiting for ctrl->qmi_up completion object. This is
resulting in workqueue lockup on Kthread.

Added wait_for_completion_interruptible_timeout to
allow the thread to wait for specific timeout period and
bail out instead waiting infinitely.

Fixes: a899d324863a ("slimbus: qcom-ngd-ctrl: add Sub System Restart support")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Viken Dadhaniya <quic_vdadhani@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240430091238.35209-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1451,7 +1451,11 @@ static void qcom_slim_ngd_up_worker(stru
 	ctrl = container_of(work, struct qcom_slim_ngd_ctrl, ngd_up_work);
 
 	/* Make sure qmi service is up before continuing */
-	wait_for_completion_interruptible(&ctrl->qmi_up);
+	if (!wait_for_completion_interruptible_timeout(&ctrl->qmi_up,
+						       msecs_to_jiffies(MSEC_PER_SEC))) {
+		dev_err(ctrl->dev, "QMI wait timeout\n");
+		return;
+	}
 
 	mutex_lock(&ctrl->ssr_lock);
 	qcom_slim_ngd_enable(ctrl, true);


