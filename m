Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041630;
	b=ivtf/JXFr+0puCzodq2eH2ISabc4rEYz9D88c2E24gwfOtvh1PfONUKUG7BvNHGEDR+w
	 CETWnLNgOuFsRIJD4OuYAZYuVZXwccaRSlt17B2FunnwfDEr/dF36H7s+ZvMQCFfoCQkW
	 3T9wQuAP/VXsPPKiAMBeTsN/PhE0UsknGyhVfvgyuxnw32tl+5KZ9wXlYoK8AuE4ddbFQ
	 DEmRnZDgNGhG+9YQ3cOQLwZ4Me7yxwGRPADqle+H0xJykdEfhg+dhhbYyxLhV3D+MRLNy
	 neXeRLgQFqXJJu91MWWuS0u0rvnoZZLkTIfNIuTvsbBMSj/b78oxvoliUkMgo26LbWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M4BGpA9x+myiOgAT2KjHu18MI3E1gci7KrrfHOJO8rY=;
	b=0/IQiUmjYjI1y+/4k76Us3cbx6x7EM6APltH5EUkmah4f63STg9mlpCoHM/EKxF1NQxx
	 mUfqwKkVeYs76QnBkPx7JHoiCDv2S8COJceDD66EgYd2OAZbYFMGUmNNGjyqkMH53M57V
	 X766AFiRl06GuRTNksGLyDvz7GR1tr/pKGA+AJ3F3lFrxCP1nQEuc71/BKJB6EkoaJNy3
	 3+L16kFMIZRblEQqp4yt11n8ZA8Im7+hE2/MNsFT6qg4JlmMgd3AvP3Q3uTD6gHFi+4Dy
	 lVDQrCwWVYuLrYWl31iKZcLfkbtBb4vVo4eV7DFFbmSvGf9vr402n5jDT9m2zLPP7aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f7mZoxbG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AC5606A330;
	Wed, 18 Nov 2026 22:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f7mZoxbG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459741F000C4;
	Wed, 18 Nov 2026 22:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041629;
	bh=M4BGpA9x+myiOgAT2KjHu18MI3E1gci7KrrfHOJO8rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7mZoxbGam5kGmhcHpBFE7/YM2IEHlaLpu+gT6N7BTX9qQ5u4aRM0bB3JUkWPAr6m
	 kJy1l4WIzsapIhVHxCqGgX2B501ACNuxpp+k3m0QGWUYUg/dYGf4tCJoKWnC0taQPO
	 5pvQA5M9CKdm2THZvIldLdNlSxyICXVXSRrGqdyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2881/3318] Bluetooth: MGMT: Fix pending state of instances added without HCI traffic
Date: Wed, 18 Nov 2026 15:58:23 +0100
Message-ID: <20261118150446.962015104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 20984813a145d..ff5e6d25d753d 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8988,6 +8988,12 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
 	if (!hdev_is_powered(hdev) ||
 	    hci_dev_test_flag(hdev, HCI_ADVERTISING) ||
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



