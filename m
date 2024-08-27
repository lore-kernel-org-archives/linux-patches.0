Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7B51C8FDF;
	Tue, 27 Aug 2024 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772244; cv=none; b=ZYV24s79daRI6MLJmPfFgkb2kNEEsYsuXSZhLjYKnP6XOkgwkdmdz/z1VgSV80jqT66GBu4QhrcoPKMREOG7m890oJdfWDPW6HFVKVwXKSBYHZTvHZIM/+aEZTyvqUvQ6WrrmeLd7wkAMC6GDeLFiUgpe20K37h+PYPLgIfKvKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772244; c=relaxed/simple;
	bh=3ORSHeCg7fFDo7PWp7zxIHkijxK2+R2Acw7jK2ra9yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YehT0ZoHId9Utf7HoDxH5WVe2/a5Ww390sRfqWv1Vlm6yWicaRgitJFriRxKsEOmQXsJbKZ4gAHekB0P8HPNHMhOiNdqQhWVeekgcXeUOoAD5EYOjksYKyV5v4tV7QyEfvdwjAJO/c27C4Cs3kPbUGSzvKexVOv1vuklHt046YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ka3hWhnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ka3hWhnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF7CC61069;
	Tue, 27 Aug 2024 15:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772244;
	bh=3ORSHeCg7fFDo7PWp7zxIHkijxK2+R2Acw7jK2ra9yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ka3hWhnUa5rwOhM5nYTmI1qA5nCzEINhBmfzJakW/L7bXWJjqbgeadfUwKl/Qdaun
	 aI8SGNKGtUXlie6a9K/1ONytP2V2rPFKrLA9shUUrzes+H+mczhiYhJkZAd3k4v6UX
	 hdBADkC8gl9WjUqlKg9AeAP2f/oNZ0B8Hfy6J85s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/321] Bluetooth: hci_conn: Check non NULL function before calling for HFP offload
Date: Tue, 27 Aug 2024 16:37:44 +0200
Message-ID: <20240827143844.170894365@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bac5a369d2bef..858c454e35e67 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -293,6 +293,13 @@ static int configure_datapath_sync(struct hci_dev *hdev, struct bt_codec *codec)
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
@@ -338,9 +345,7 @@ static int hci_enhanced_setup_sync(struct hci_dev *hdev, void *data)
 
 	bt_dev_dbg(hdev, "hcon %p", conn);
 
-	/* for offload use case, codec needs to configured before opening SCO */
-	if (conn->codec.data_path)
-		configure_datapath_sync(hdev, &conn->codec);
+	configure_datapath_sync(hdev, &conn->codec);
 
 	conn->state = BT_CONNECT;
 	conn->out = true;
-- 
2.43.0



