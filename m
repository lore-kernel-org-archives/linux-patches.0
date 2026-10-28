Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216266;
	b=OGzoXt5JV4FQPN8HUIDIQgPF6YALPk12m0EILf0JynmpiL4ZcvmaS8GpqxuBg3waWJ3l
	 WvMyPuYecsTkZaFYqE4+r/mL0l/KeYHB/iyzAMynRvWKiHia1oPkCly0QsdfFQvQxgNBM
	 FyFxqIc3xzwKEODSQOO0j1DGU8+CG50vkz7tIC90NBsU1S3zGQejiHyJl6/OhdaHY3VMY
	 318q1l44Y0tdUej30VbJadbS7Pl3pZSSJG8MsSwBcmvH5flNCMqWHkkzt0ZYTnpLu5UpN
	 DgcI7x9xfEl9DLv8SE5qMs5pfeqVqSkA1M6mPs4XZ/RzKkkuZyNitx2iLy5nNeXa/9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QC78ALNvs/iFndd/DEEN6HIWxVy/1eiX0GnyK6oVYoY=;
	b=SEh4iMU048s5yr5SipoFKmKYZCLqqF4T1qG+4zfiHjQN3kdeUv7mWnxPQ4z5yy1hh1Dc
	 92GwQ7Q/AUDembb85X4eroTDmDcqhnT2D2yxL2F0txDo/KX4b8jmhAI3p/uO0TEpJWeCt
	 JSWJNceN+CyAx3GwGyoW9llCZYyaRNAFtzSZVYH1nfvvq/g2fnpLt65Ej4mKF27NRZ4Hs
	 PsSH4sYfUSQdHMoC/GV3jolyfwZ5hyB2bOWP0TK+wOdvAoZH4GY26urQrlfTi1YWShIpU
	 gCB6JuNo/iyBLnBooOM3B5mXWff4oRnXrHJ83dZ58J7UmRbZIBAYlZO1moWTsKAyg1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4MTj8UC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86ED606A32D;
	Wed, 28 Oct 2026 19:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4MTj8UC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D011A1F01828;
	Wed, 28 Oct 2026 19:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216265;
	bh=QC78ALNvs/iFndd/DEEN6HIWxVy/1eiX0GnyK6oVYoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4MTj8UCjJcNmLuiaqocVL7dXtaqElfcRqWBrK+ABvSXWBb8COC4YLTLiEXQjlzRh
	 vSxP88MsQn3ble9qybnGCcwzF0DMkZOu39YwFUBeKbAkEcvyLURiXCK39I4x1/4vCH
	 EOaHnvpDm49ASmWFipnfNaBofXKRqIVXNJrnxWdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Walters <jaggyaur@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1461/1887] Bluetooth: hci_core: Fix UAF in hci_unregister_dev()
Date: Wed, 28 Oct 2026 17:59:17 +0100
Message-ID: <20261028170532.703938548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jordan Walters <jaggyaur@gmail.com>

[ Upstream commit 5edcc018fa6e80b2c478454a4a8229c23d67c181 ]

hci_unregister_dev() does not disable cmd_timer and ncmd_timer
before the hci_dev structure is freed. If a timeout fires
during device teardown, the callback dereferences freed memory
(including the hdev->reset function pointer), leading to a
use-after-free.

Add disable_delayed_work_sync() calls alongside the existing
disable_work_sync() calls to ensure both timers are fully
quiesced before teardown proceeds.

Fixes: 0d151a103775 ("Bluetooth: hci_core: cancel all works upon hci_unregister_dev()")
Signed-off-by: Jordan Walters <jaggyaur@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 20bf36e88bea3..d01a91fa88797 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2718,6 +2718,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	hci_unregister_suspend_notifier(hdev);
 
 	hci_dev_do_close(hdev);
+	cancel_delayed_work_sync(&hdev->cmd_timer);
+	cancel_delayed_work_sync(&hdev->ncmd_timer);
 
 	if (!test_bit(HCI_INIT, &hdev->flags) &&
 	    !hci_dev_test_flag(hdev, HCI_SETUP) &&
-- 
2.53.0



