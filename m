Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247CA2DF73;
	Mon,  8 Apr 2024 13:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581683; cv=none; b=g38PPeguYG75r6RdCh4al8ixbayF4hUUjfqjOj7Hc3fd9RncbfcADuF9rC3Us3jrzeXMgSh5SN29NZlDx0BN8UJtCP1JaFqGlQXYOoO2s/oQl2n+hH53DnZ8ZJ59lblruwub7zYLuT3TDwl7I4PAdnFr+doq+T6lYfiiThJd0h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581683; c=relaxed/simple;
	bh=sIibRmTEO9bPy+OwmWF/hejFB9eYy2oD2wA4qE8Dn94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOeqPx5d0sD5CuzWfmUY7GhDegkGpA2zZaCVA5sHTGN6/E4DZezyv88T8Gieis/sb+YsC95SoluFfF3jQXOE/g/k3V5NJi64Sk74LxrNwL0HH1AdeeDpWePbh8QnqNrdmfSV5zObRX3huMgiRkywsSLst8GLXONAHs4fsg84H58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqw3cjnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqw3cjnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24E8C433F1;
	Mon,  8 Apr 2024 13:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581683;
	bh=sIibRmTEO9bPy+OwmWF/hejFB9eYy2oD2wA4qE8Dn94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hqw3cjnxmi+ZZPU+mZ1oLT9yOnFKBH8PwXl58sZzIvTndq9O0TWPEn3ZZbENYtYmJ
	 NlruWu0pubFWo1125UNkBPZRJl24gC8ag46bd0didz9TjrYkWRVpzPWdatG+J0UT5Z
	 8HpSMPEXwEmK+GD05sw1MW6k65FIyNGK+BUQR9co=
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
Subject: [PATCH 6.6 008/252] nfc: nci: Fix uninit-value in nci_dev_up and nci_ntf_packet
Date: Mon,  8 Apr 2024 14:55:07 +0200
Message-ID: <20240408125306.905310388@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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
index 12684d835cb53..772ddb5824d9e 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1516,6 +1516,11 @@ static void nci_rx_work(struct work_struct *work)
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



