Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B521196434;
	Tue, 10 Sep 2024 10:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964229; cv=none; b=a9/+7mUoqsLVm5BQ1gqNhdtJMokkfX68B3gy5+vJEPOaWaKocTXmGwqnYdSFYFApoLHkdvFD7xkvb4uCoLiEMvg40HGAv1u7Ir2LeFBL7mKRijJ15Eccx1GEs3SLGiE7JVECbXrOZPQfol7LbWA8E7wgvygDXK02KfZz6591+F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964229; c=relaxed/simple;
	bh=McFEryEOgzwfX/BWWnOTmZdBxGtjWZfeQ2Uh4PlGkPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKZL++bGsJxKLRB2W4HfpScazMA+LKiVU8WqIeVvoAecUXwarpkJiQkfX+rWtaLo/F1wFTq/ylCXr4mWuv815fIafWaK66h/6HIt9IDQVMdZoRl4PUBBHGjZ2EZ+m0z6KT1Yj2JWkySV8pks+FjgJamN/TjVi16jt50ONkVw5A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KuUtyKA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KuUtyKA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9DAC4CECD;
	Tue, 10 Sep 2024 10:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964229;
	bh=McFEryEOgzwfX/BWWnOTmZdBxGtjWZfeQ2Uh4PlGkPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KuUtyKA5rMmEby5S16JEA6WNZkq4reLfcIt+rhcCIfWTz4omYLuYVnWP9j4xqfjqF
	 lG50bpeHjPwqsE7qyuqixzUhWRJUNs/v8iUlfx9tcHaBhc4t0AwOQElqy8sKDHoTaT
	 okycLu5NQvfqARfvTQlqvHIWWhMlndmU1c8HbhOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/269] Bluetooth: qca: If memdump doesnt work, re-enable IBS
Date: Tue, 10 Sep 2024 11:31:38 +0200
Message-ID: <20240910092612.148072067@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
index 9082456d80fb..7a552387129e 100644
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



