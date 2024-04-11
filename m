Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA801422C4;
	Thu, 11 Apr 2024 10:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829813; cv=none; b=FwffrlR81twNQTF/tN+y8nZBxtw0yNeTk3+ICMWokfdAAQy+Fe33olWs+kd06QDCvNm47N4cl2e/w1Q6PVU3Lyy/uy4U+3xAqBfHwYKrsAsMHzWrSXqmI0iguysorUOEZfMCYWXWtpLopX6S7U8ayJnveDnG5ZwubqJDxuhvQN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829813; c=relaxed/simple;
	bh=VFyTgVy0bC/o4H+HUdnH7SbkGhm5R55HTDi3Q784MeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnCWQPzooCujHGCkNxL6cHKinUMk+m7L503+DhmKH6vxlWgDxIy5oN44dFEUtBnBETk3c3Mfuj5afWlkfbgucQc7/4q+LQt7e1WUqB+jjx5h0qegbW5RHCW37RDs2JIN/8bc4YaZs7DicsJBBpStJUEioFl2qht8ENk8ejZTr1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STT9OENO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STT9OENO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDB9C433C7;
	Thu, 11 Apr 2024 10:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829811;
	bh=VFyTgVy0bC/o4H+HUdnH7SbkGhm5R55HTDi3Q784MeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STT9OENOEbtW8H7bvw0JmMf+w0uEGM6KZ6YNkIN29XYQC4jos/WNT+Ver5UrBjCC2
	 v+vOGiGx2rpozaC+sATsABxV8DS8i2BeCNAu0nkpWpfcbSZcArS3PB/L7PQvjjkxbt
	 RfdB1LB6zFFlghjxDbrOmM4pb9CW8f7P4CO2p8L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Jeremy Cline <jeremy@jcline.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+7ea9413ea6749baf5574@syzkaller.appspotmail.com,
	syzbot+29b5ca705d2e0f4a44d2@syzkaller.appspotmail.com
Subject: [PATCH 4.19 112/175] nfc: nci: Fix uninit-value in nci_dev_up and nci_ntf_packet
Date: Thu, 11 Apr 2024 11:55:35 +0200
Message-ID: <20240411095422.939091456@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryosuke Yasuoka <ryasuoka@redhat.com>

[ Upstream commit d24b03535e5eb82e025219c2f632b485409c898f ]

syzbot reported the following uninit-value access issue [1][2]:

nci_rx_work() parses and processes received packet. When the payload
length is zero, each message type handler reads uninitialized payload
and KMSAN detects this issue. The receipt of a packet with a zero-size
payload is considered unexpected, and therefore, such packets should be
silently discarded.

This patch resolved this issue by checking payload size before calling
each message type handler codes.

Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation")
Reported-and-tested-by: syzbot+7ea9413ea6749baf5574@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+29b5ca705d2e0f4a44d2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7ea9413ea6749baf5574 [1]
Closes: https://syzkaller.appspot.com/bug?extid=29b5ca705d2e0f4a44d2 [2]
Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
Reviewed-by: Jeremy Cline <jeremy@jcline.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 2e885b7a02a15..1f863ccf21211 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1511,6 +1511,11 @@ static void nci_rx_work(struct work_struct *work)
 		nfc_send_to_raw_sock(ndev->nfc_dev, skb,
 				     RAW_PAYLOAD_NCI, NFC_DIRECTION_RX);
 
+		if (!nci_plen(skb->data)) {
+			kfree_skb(skb);
+			break;
+		}
+
 		/* Process frame */
 		switch (nci_mt(skb->data)) {
 		case NCI_MT_RSP_PKT:
-- 
2.43.0



