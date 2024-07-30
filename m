Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23111A6192;
	Tue, 30 Jul 2024 16:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357473; cv=none; b=GmnCQ+cwkJMYvrkeqxPIgvZ0VKVI7tE1DcaBaSjGxeDEUaKpt/mOyDS5jprFiFHDm05rKv1Y9bf/8oHmtxgePDmOxZzGn8u16iVaP+ShmRzKUuEneLmR6ZlR2o9b3Dv6VGpDo65JBqpVVvyyiH3G/SKWzNe0PRT+HP0q1wfiV14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357473; c=relaxed/simple;
	bh=dXitW7tTj8bg0PZGXg7MuMzL6UD572CeB5juD0/vcC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbimEyoLJxfPzzd7aO3TfNcky0a1Ur479GpccZ0XgbkNHLiVMiJtNQi9Jsi/24rUgwpp4HHcB9dyQskOmmvkB0T0+a+FFM6Rxa+wm0jhV2yxp3y+iMLvlAojJUm87flD/5y7xHB1NUCpGiC6cr7WdGbyrv3rtrMeAaEmTan9z+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZzT/5oT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZzT/5oT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721F9C4AF0F;
	Tue, 30 Jul 2024 16:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357472;
	bh=dXitW7tTj8bg0PZGXg7MuMzL6UD572CeB5juD0/vcC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZzT/5oTe1rn//YNbFPdAttifMEjvjAQmRAMdMHfpcjgNkiFV18Upt8Alr1WKxoJx
	 twC8bELxx315tMYAV4G5rx9nfUHFoeMJI3dIckb9k8p/G1z0je244w2sMb5dl5nZHR
	 AC96H1t7wOp3LSn9W3/h92lm6TBTlqWzL7pPozeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 257/809] Bluetooth: hci_event: Set QoS encryption from BIGInfo report
Date: Tue, 30 Jul 2024 17:42:13 +0200
Message-ID: <20240730151734.747299650@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Iulia Tanasescu <iulia.tanasescu@nxp.com>

[ Upstream commit 5a820b13db3988122080f8de2920721f770c37a0 ]

On a Broadcast Sink, after synchronizing to the PA transimitted by a
Broadcast Source, the BIGInfo advertising reports emitted by the
Controller hold the encryption field, which indicates whether the
Broadcast Source is transmitting encrypted streams.

This updates the PA sync hcon QoS with the encryption value reported
in the BIGInfo report, so that this information is accurate if the
userspace tries to access the QoS struct via getsockopt.

Fixes: 1d11d70d1f6b ("Bluetooth: ISO: Pass BIG encryption info through QoS")
Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 93f7ac905cece..4611a67d7dcc3 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6988,6 +6988,8 @@ static void hci_le_big_info_adv_report_evt(struct hci_dev *hdev, void *data,
 	if (!pa_sync)
 		goto unlock;
 
+	pa_sync->iso_qos.bcast.encryption = ev->encryption;
+
 	/* Notify iso layer */
 	hci_connect_cfm(pa_sync, 0);
 
-- 
2.43.0



