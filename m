Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624525;
	b=pvhKJx87f2a5DUaPRqsbiu0XbSV5ccVanZISgAeAWgVITkB6SvLU7WscvVdrkcvmq0lP
	 9AYpU+TUDu7ii7q1yFAA+Mgw1a05CiJCLh1UtuInxWN3M7sJRlI/6sHReXc8HtAeaJsoX
	 ahz8pJfpc6gw9ljIXI3N9uqb/7kl16WhM2eGxCh2c5qAj9hTjlqi7ujzmsM6E8yG848E3
	 cjwkxpzGZnBDSzVYwawK7C/7dKiERWDw5IylioLFh8kFRuboaRST7pCqe4/vbhVRGtZoT
	 lLJ+6tmhVNAl6Q/I3BARc6jKqoDBGLzwWCUniRI4OkItgeEsso3QVBrypApNfnAQ+TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zaV0og6fys0leE/cDjlOL+hXgguRfp3Q+cRDQiS3msw=;
	b=NQEZLKYrhpyqPBx9GApENfF3Nombww3G4DKjuusagBtvPrB+CJJX5GPyDg5T6KjnDye1
	 6dw1xtG9ZF9l6Zq6fzhCSxoJADMFU3smRurd6pNKUiTtE8MsmETRU84QtTbVn9dBXew4R
	 zTMkvrG42DC+HzFbcpT2fUIoIZaO6firl7S+gjpK7khW7t3gw1cgcRK90JULlSgvTdGa/
	 VWfz5zkPQttmSNr8ZV2edWw6nExS3EqptDwpgPXtMegrkW8cosZOfNWWMJXXp8oV1feHW
	 KIs5RKv1Xg82lj3JCy10kt5iM1fK5a3LrnEkspsoqZXRsw7RgPZxBQL74WLiP2zKM8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nC/JVqgL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34758606A33A;
	Wed, 25 Nov 2026 16:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nC/JVqgL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A1E1F000D1;
	Wed, 25 Nov 2026 16:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624524;
	bh=zaV0og6fys0leE/cDjlOL+hXgguRfp3Q+cRDQiS3msw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nC/JVqgLsDtOJLArK2JPj+fBuwzXbok7yo95mvcflI0cLtLkVUW6d/dYnLIiKO/rq
	 imh2o/2A2QNm6UaUw4Hy38CD1B2V03eRyuJJ8thoQX4JXppKO075ZRlTVPYC1c5pL/
	 tH3zUzg48EYVA/suJdaaYrlWSbYJupZaK2kjFt7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 219/816] Bluetooth: Fix not updating of hdev->commands[] after reset
Date: Wed, 25 Nov 2026 15:29:27 +0100
Message-ID: <20261125143854.274147828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 1fb641656fe0a..3eea2343f1977 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -781,9 +781,7 @@ static u8 hci_cc_read_local_commands(struct hci_dev *hdev, void *data,
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



