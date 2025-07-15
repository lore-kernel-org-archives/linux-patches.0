Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEED2ECEA7;
	Tue, 15 Jul 2025 13:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586701; cv=none; b=teEKjM3KOCoUtuxIURnaZjkrU2KVbTijZvd3gTXzfmDzC3XiBVZmjrMkxvQsMslJoym8BBs32vZAH39kAtW2Bbh3zrIFkpMSxWsmpp2ioo/ZmbyQLCCm5ixNGY/PSqVvkBhO7hrb33LvDD0qZ79AnwtHW0C2TnZtWKyRzq74SNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586701; c=relaxed/simple;
	bh=SZHTLh39OpjqPfqQ9zlPn3V3y1Q8TAJGwhERBAe3/kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m763/Lf9ojI43vYTKvpu96fKyEhNCPBaVNHeraW0qCWFdzdK5CUk3iGk26o1cE3kL3U/C6ZjxvHIxVgAPVEco13j/6Tm9/1LPnXsf9udJKqQsC9/tfo9bLdh56fjjbNt9zaLzeJfPv/BMDrCWWV6195G88cJaOGYaxj3lTL+9W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRPLKYoi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRPLKYoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8E6C4CEE3;
	Tue, 15 Jul 2025 13:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586700;
	bh=SZHTLh39OpjqPfqQ9zlPn3V3y1Q8TAJGwhERBAe3/kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRPLKYoiKbe8DvQX/FvlM8ktEOcbTgawbD0F5+6JIRXwCK5PAV3+niWSmbuVi3rtl
	 ucHehvwr+PdYCBpn8UR2Jp3dpDwJXbMKaXo8lbEImuA4EqnSg8/L+KhjpYShrUMk50
	 va+Bk+N7gPsnyp85A+y2jQgAeqm3YpMLwI8X8BPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 016/192] Bluetooth: hci_sync: Fix not disabling advertising instance
Date: Tue, 15 Jul 2025 15:11:51 +0200
Message-ID: <20250715130815.514824142@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit ef9675b0ef030d135413e8638989f3a7d1f3217a ]

As the code comments on hci_setup_ext_adv_instance_sync suggests the
advertising instance needs to be disabled in order to update its
parameters, but it was wrongly checking that !adv->pending.

Fixes: cba6b758711c ("Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 2")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 9955d6cd7b76f..f3897395ac129 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1345,7 +1345,7 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 	 * Command Disallowed error, so we must first disable the
 	 * instance if it is active.
 	 */
-	if (adv && !adv->pending) {
+	if (adv) {
 		err = hci_disable_ext_adv_instance_sync(hdev, instance);
 		if (err)
 			return err;
-- 
2.39.5



