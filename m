Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E27115F41B;
	Tue, 27 Aug 2024 14:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770181; cv=none; b=A4sO9lqluXNNhBgD13Yx0UtzZSbDQV28UACED01CgsRFqh3w5qiJWVAUZ4zEcNQP8KesCxnmbyQTMYggyhhOSaKCnBiARJ/6h3K+TnJj5zPf26ySv63Mh+pZ54N0ro50D8EeygbHo5743gYio4UFviRIiQyvmOSHIzM4HNyLzkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770181; c=relaxed/simple;
	bh=xl8lZbUSfOIWPGTO3DOPu9jTZXa1vlyBOL5q3Ung+ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0ue5pE48XU7alWPWcYgNICp55Chcny+y5GDoQgID0NY0eQ/nkjeSZi7I7wpJVYNE484OBhA7iXiyle8KAFHtb2+QEovpUdX3Nm8aPynGW+lcbywciJaYPFQdABemftMytpuQwkFbnDHvLd6cNG/qvBmBcWbNGMn46QOOAFdk9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jn7UHe52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jn7UHe52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151BEC4DDE5;
	Tue, 27 Aug 2024 14:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770181;
	bh=xl8lZbUSfOIWPGTO3DOPu9jTZXa1vlyBOL5q3Ung+ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jn7UHe52eBrZVfp65CqfBQXMa28guSzwN05vyxXy2YcA3aAtIQHUArfusu6BF5bZr
	 5lhvhog5FGB/OADQXOFymcy8m+y2q8tGmTMAO5Sx7JCldZcVNnjn4x0jlbx9MKPE/1
	 l+gnm+1Dge8PUZoW1DPoMeMskFLHv42hovCP8ZbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/341] Bluetooth: hci_conn: Check non NULL function before calling for HFP offload
Date: Tue, 27 Aug 2024 16:36:21 +0200
Message-ID: <20240827143849.126898694@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 132d0fd0b8418094c9e269e5bc33bf5b864f4a65 ]

For some controllers such as QCA2066, it does not need to send
HCI_Configure_Data_Path to configure non-HCI data transport path to support
HFP offload, their device drivers may set hdev->get_codec_config_data as
NULL, so Explicitly add this non NULL checking before calling the function.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 9c670348fac42..dc1c07c7d4ff9 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -299,6 +299,13 @@ static int configure_datapath_sync(struct hci_dev *hdev, struct bt_codec *codec)
 	__u8 vnd_len, *vnd_data = NULL;
 	struct hci_op_configure_data_path *cmd = NULL;
 
+	if (!codec->data_path || !hdev->get_codec_config_data)
+		return 0;
+
+	/* Do not take me as error */
+	if (!hdev->get_codec_config_data)
+		return 0;
+
 	err = hdev->get_codec_config_data(hdev, ESCO_LINK, codec, &vnd_len,
 					  &vnd_data);
 	if (err < 0)
@@ -344,9 +351,7 @@ static int hci_enhanced_setup_sync(struct hci_dev *hdev, void *data)
 
 	bt_dev_dbg(hdev, "hcon %p", conn);
 
-	/* for offload use case, codec needs to configured before opening SCO */
-	if (conn->codec.data_path)
-		configure_datapath_sync(hdev, &conn->codec);
+	configure_datapath_sync(hdev, &conn->codec);
 
 	conn->state = BT_CONNECT;
 	conn->out = true;
-- 
2.43.0



