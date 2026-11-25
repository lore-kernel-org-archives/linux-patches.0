Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621574;
	b=3sLfgePqlf7/1yW0vyUwqJMEX6JqXRWtgP48nu/ig+WaNpVadPXc5f0VGQgcNc9NO4i3
	 zHoUn5ZBk8p3iRweRMDts0hiq1FjV5A4ley+RAX0UfHpMt9Ovt/G2dxHAXUsLpEaC7kEi
	 f2YuAKp7rQaSPXokbMXPvj6e2HRQB/VI2RPCdnLoPnhH6j3ZRm/IdoMGEsje7F7xe8sxD
	 y6k7HYi8pkvwrMj1W7QsdqTNsE600S0aAMLGTgx2ddSbgrwdLr8KQsNTIAo0kpYgR3qhL
	 FAT55xFkATmgX/g29LhNfAuFZbHMmBfpyaG/pJiKLRgjxSq5CNHTqHyN4OD2hujMZXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qhdcHHG7TS7l1gStW6XKuC0VDzuBRaHkl5aPHpIm1J0=;
	b=s24fr/uUqL9GhRmoy+ZrtUJtXQxSrPo4O7bUiV9T+487xFUlvqMShX+fTUu8uBLrdB1E
	 QqE2pB36nBpS4zR4iDeCoYgPwe9mwURCrKEmIUeVNuNVUsBKwP4gsXnw5JtidQ79OBpjE
	 E0A9uYE5O82XihitLhxmy4dyhqnYjTD1baUz9leTFrJZyYJb9vrpBBvSKDqRUTi0mxnso
	 JwffOR0j3f4Sv5XQzzlVeopzHUS0SEiCTAUXfdOr5uZ6BjaIJIhzkGXnCCfq0Fo+ClbQz
	 P1HMYyfKfMHluJAdiwvNALzGhzwjwchFzqJ3EPr2s86/5xaVKDv6qze9YreLS1TuxFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DE4DkH1k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCAC606A331;
	Wed, 25 Nov 2026 15:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DE4DkH1k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9561F000CF;
	Wed, 25 Nov 2026 15:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621573;
	bh=qhdcHHG7TS7l1gStW6XKuC0VDzuBRaHkl5aPHpIm1J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DE4DkH1khpp3gR/u+MZOZXXy3jV9JSx4yTZ9htPwMtvrfh1gbAV1LRsE9a5ZFM+CU
	 kBipl+hB1WBcf9dmZwmbS9B+lAA97Og0aD3p3tMNgAffm2xPhXK6qkRb8YIlbu2tZS
	 gbQxMTYmd5ahz/i2jsbBaE8HGUfzD/b+ggXwI1Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 270/990] Bluetooth: Fix not updating of hdev->commands[] after reset
Date: Wed, 25 Nov 2026 15:27:17 +0100
Message-ID: <20261125143828.417657733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit e00aa1a33f81a5e25b510f569ab9cb9f97eb41b9 ]

Read Local Supported Commands was only read once during the INIT/SETUP
flow, but the supported commands bits may change at runtime, for
example after a firmware change applied with vendor commands, so update
hdev->commands[] every time the response is received.

Fixes: 6a070e6e81ad ("Bluetooth: Store supported commands only during setup procedure")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 8b9b27f2d8916..3e487963eaff9 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -792,9 +792,7 @@ static u8 hci_cc_read_local_commands(struct hci_dev *hdev, void *data,
 	if (rp->status)
 		return rp->status;
 
-	if (hci_dev_test_flag(hdev, HCI_SETUP) ||
-	    hci_dev_test_flag(hdev, HCI_CONFIG))
-		memcpy(hdev->commands, rp->commands, sizeof(hdev->commands));
+	memcpy(hdev->commands, rp->commands, sizeof(hdev->commands));
 
 	return rp->status;
 }
-- 
2.53.0



