Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031919;
	b=BbBhdZESsR+gJvdw2epHMgmJEW+L9eUOFpo3QBqbOGOkwBCuyC2xX/Rk594MRzbqW70I
	 U0tgBsPW7vphciQ1vA4tf8Nup0jtUIpBXs1eELzf18KmmSn6+dq0aoBRidXa5y2Oea+oR
	 HJYuSrw238rBKE4LHURFd7wqLhCNGB2RCLOhY3jnTkzrm6xx+FKCBVW2O28wLnTxuHBgX
	 89CTK9WE+p8OSrVAMj9ZlegvTKfBYkhtUGp5/mMOv/pswov7Eipi7OnEkoQ+U9tIxAySR
	 oG97M1eP6yyfflVkWWw+MqrfgetlRbpqvejGe71o76zeXYRwcNwm6eGOynpCmgY4Z/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=suPt82SFk3o/eKssJF/RhXpKXiNR/S6RM7OPozZQgxw=;
	b=lX6E6AFaXTVhwkrL+aKgFjZXYudbWFdJc5WT13gjWQpTD5RES8TpYaJp41zci36dR+bk
	 7et51x8AZcHoVGO5uK1e1/cVdQyWr4esUMzcVDorpyQEQS6k53K8rW31y+a2TKVwcJ3Iy
	 gfRed6cIIXmra+PECL7UnR+7vUUMVtjnn8lnL08icW04wZdBaxLMHREOI7eDUtHLBFxAS
	 KOWugQypUWWqO3HeMcLVp5eS+gCQ4rqRsgaB2OiJZEGUJMF045dEPO9Rr+QHycXoaXUGC
	 Bq7ALyq1vkNBgpEhhJ5srLKVcSHwulN/yYpGDTcBzdJjrJ413HTnVfxBkCOzEOcsnJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="o4/Y/ao3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931D3606A31C;
	Wed, 18 Nov 2026 19:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o4/Y/ao3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22FE1F000C4;
	Wed, 18 Nov 2026 19:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031919;
	bh=suPt82SFk3o/eKssJF/RhXpKXiNR/S6RM7OPozZQgxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o4/Y/ao3ExkXC6miSLn2fCOl8dyQ3uInsdmMbVCIRT0OJrurlJ9qUN5Nvh6I3y9WQ
	 3gQkuJsvsHfDMUwjc10I1nW39dRYe6OVLWbWb8FhluOMnjFF9MzO7GqB0LJNbp6Pyt
	 S1nbN64zlHfysw6iUcf6ixev9hE0JCt5ZtzsUESY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1227/1756] Bluetooth: MGMT: Fix pending state of instances added without HCI traffic
Date: Wed, 18 Nov 2026 15:55:54 +0100
Message-ID: <20261118150058.659630445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 5548fb51aa3cc24545029a286882d261a8e77d8a ]

When Add Advertising completes without HCI communication, e.g. when the
device is not powered or the instance is overridden by Global
Advertising, the instance is left marked as pending, so a subsequent
failure in add_adv_complete would remove it despite it having been
successfully added.

Fix this by clearing the pending state before completing the command.

Fixes: fffd38bca51c ("Bluetooth: mgmt/hci_core: multi-adv for add_advertising*()")
Assisted-by: OpenCode:claude-opus-5.5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index d2fe93d0b3b1e..b2c06ca7c0e37 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9117,6 +9117,12 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
 	if (!hdev_is_powered(hdev) ||
 	    adv_overridden_by_global(hdev, adv) ||
 	    !schedule_instance) {
+		/* Instance has been accepted so it shall no longer be
+		 * considered pending, otherwise a later failure in
+		 * add_adv_complete would remove it.
+		 */
+		adv->pending = false;
+
 		rp.instance = cp->instance;
 		err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_ADD_ADVERTISING,
 					MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
-- 
2.53.0



