Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D34913AD09;
	Tue, 10 Sep 2024 09:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961811; cv=none; b=aF/C24wyVE9K6UaS5IwG9Tl+nVStZ8V1Nnz3tcqfHjdpy5hzF3LZ23RgAByKS7a4R9mOaFXLpeXbVoiMxwN+9Kq3fo6R+7hsvj3CaJBsyc3lD6TXFH9wTEjMpoteBmQtd2mzi2Hc5JT6ELfadxFn4zakrSFcqpQ4+U6s2R9OitA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961811; c=relaxed/simple;
	bh=QWOu/UejiMCpKmGZ8CiWH4yNZFE65s5WU7GJd7DV7C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQA5pm1BZCzz1vFrvelWWFyjZpxnfNkyz1zhFKfiCGaEjo4kohtrzid/EtpF+44chuDzh4dnHuyPA5n0iR9N9MHH2giM5+sNXSqNGhI19LF1Z6l5pcQPd7gjsHCzZYXWc+iksi8Fqlq6vTHCkGFCeEyK4l3Kk8k1L+FjOQzSDV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vb6sz9w3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vb6sz9w3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D59C4CEC3;
	Tue, 10 Sep 2024 09:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961811;
	bh=QWOu/UejiMCpKmGZ8CiWH4yNZFE65s5WU7GJd7DV7C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vb6sz9w38dhzvWH+S++BMeQ5ewaUxH+8j799KzEcAR23SYYN9hTrZaxwQxhSW2Crv
	 JBzrkKRr1f8D96CnFRzHWEqlvR1I2neOdu6Zq0ThxdtYuw4b0gVHMaxy/k0szTz8sL
	 WvjsPMxsHVble3UQcL9wLw/UNRusvjNHYiHdrfjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 170/375] Bluetooth: qca: If memdump doesnt work, re-enable IBS
Date: Tue, 10 Sep 2024 11:29:27 +0200
Message-ID: <20240910092628.184568390@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 8ae22de9d2eae3c432de64bf2b3a5a69cf1d1124 ]

On systems in the field, we are seeing this sometimes in the kernel logs:
  Bluetooth: qca_controller_memdump() hci0: hci_devcd_init Return:-95

This means that _something_ decided that it wanted to get a memdump
but then hci_devcd_init() returned -EOPNOTSUPP (AKA -95).

The cleanup code in qca_controller_memdump() when we get back an error
from hci_devcd_init() undoes most things but forgets to clear
QCA_IBS_DISABLED. One side effect of this is that, during the next
suspend, qca_suspend() will always get a timeout.

Let's fix it so that we clear the bit.

Fixes: 06d3fdfcdf5c ("Bluetooth: hci_qca: Add qcom devcoredump support")
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 34c36f0f781e..c5606a62f230 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1090,6 +1090,7 @@ static void qca_controller_memdump(struct work_struct *work)
 				qca->memdump_state = QCA_MEMDUMP_COLLECTED;
 				cancel_delayed_work(&qca->ctrl_memdump_timeout);
 				clear_bit(QCA_MEMDUMP_COLLECTION, &qca->flags);
+				clear_bit(QCA_IBS_DISABLED, &qca->flags);
 				mutex_unlock(&qca->hci_memdump_lock);
 				return;
 			}
-- 
2.43.0



