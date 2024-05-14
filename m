Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2748B54BFE;
	Tue, 14 May 2024 11:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685395; cv=none; b=fePxc9Qv2ns5R2EM0tsASq2FN4NEpdZDab5FPZAKzMSswWyZ0v7xmT1gMFCZsIq/Dp1CWMwMC2NnP6FhPdfOSwrtXrj2ZKImKAHt0I1Hreg1U2IWfzo901mJAukQqF5S24tqkENDtpDxbJWjsAYgX4SzLotlEMqWHzGv+WNjo/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685395; c=relaxed/simple;
	bh=bqLo8Elj7qSXvxJNo9CIh1IA7z5ecVSH+Fw792Rg5Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jj8ClxNqfcomo59mTdSHcMjU3/EjNbSHFiDomcW/x+8m5DtfigFIo/PvOQBcLGjQ5hXKfloTK3HjpN3Rqvc3yFSolKTxbqE4GqsTH5IorAnBD79XXmpstU1tKGyL0wcyY7wGppNLueCFpLbPtVJDjMTMhr4zqJEfI2SJYOTooiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kx5ZbzuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kx5ZbzuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D03C2BD10;
	Tue, 14 May 2024 11:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685395;
	bh=bqLo8Elj7qSXvxJNo9CIh1IA7z5ecVSH+Fw792Rg5Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kx5ZbzuQvhoMJ1XUKxYfNwTxAAb7EE0mqV9BoqQnJ585++J5QlBlqVMTOy5gEKby8
	 CxlGouVBwoFRcNbLm5brDRz7q02wbU0cEdMY7ABMFPHOyyJ2cu19v3TBRd8kY70WYh
	 NypaakaPW4PwjwvOmiy7/fkciSFbEUgTZER1SrFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungwoo Kim <iam@sung-woo.kim>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/301] Bluetooth: HCI: Fix potential null-ptr-deref
Date: Tue, 14 May 2024 12:17:32 +0200
Message-ID: <20240514101039.090383400@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Sungwoo Kim <iam@sung-woo.kim>

[ Upstream commit d2706004a1b8b526592e823d7e52551b518a7941 ]

Fix potential null-ptr-deref in hci_le_big_sync_established_evt().

Fixes: f777d8827817 (Bluetooth: ISO: Notify user space about failed bis connections)
Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 1b4abf8e90f6b..9274d32550493 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -7200,6 +7200,8 @@ static void hci_le_big_sync_established_evt(struct hci_dev *hdev, void *data,
 			u16 handle = le16_to_cpu(ev->bis[i]);
 
 			bis = hci_conn_hash_lookup_handle(hdev, handle);
+			if (!bis)
+				continue;
 
 			set_bit(HCI_CONN_BIG_SYNC_FAILED, &bis->flags);
 			hci_connect_cfm(bis, ev->status);
-- 
2.43.0



