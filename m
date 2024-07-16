Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34FC19DF9D;
	Tue, 16 Jul 2024 16:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146156; cv=none; b=r4rYoX+SfzPjD3JKILf9AU4968VqVrrFAJVe+mLwgUWe5yE6nG2zyllCZAff+bqYjIGFimalD5617bEzR6mbdjGlPZPGJGCuf0Kzd6Y7S7dNOty6f3jdoC3x9pNsE47v47FHDIBB5mnBtNuixdCLdY0E8piI3hh9ylrrtHA1Nro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146156; c=relaxed/simple;
	bh=kYe86WbFQxjhTuTfm2qY17StPN1N4Yq/3ikNlHOHC0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6f+9zXcokTLEeMaTdKFWpnOLaalcLv0MGGtdSJEe2CoPgtPTepinkeEnmLXrEu4EncfSIueqDGy30cv2uISlc2ymYb2UuBqQe2qWOnnyUMLGrxTX3bKOqRIjisEIXEdu1KrO+1sD4g43wopteAXQJnnWhOJEYgKsVvH1hLQGgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJsDLxeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJsDLxeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A34CC116B1;
	Tue, 16 Jul 2024 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146156;
	bh=kYe86WbFQxjhTuTfm2qY17StPN1N4Yq/3ikNlHOHC0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJsDLxeYSpBlmMh57DuZqo471X2UUefEC48jruVvpsZF6fco5sl6qixJuqkBCWxOQ
	 RF5ukf+/E+DQrFBb/CkbL28biqfE+ENTjujdt+/G17I8BKGlD0PZ+s84z2UQKqxVMK
	 YHDUH+HQOncm/ddJOSZEPo7Ta2BNBCT9tPUGxC78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+71bfed2b2bcea46c98f2@syzkaller.appspotmail.com
Subject: [PATCH 5.15 076/144] nfc/nci: Add the inconsistency check between the input data length and count
Date: Tue, 16 Jul 2024 17:32:25 +0200
Message-ID: <20240716152755.466865121@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 068648aab72c9ba7b0597354ef4d81ffaac7b979 ]

write$nci(r0, &(0x7f0000000740)=ANY=[@ANYBLOB="610501"], 0xf)

Syzbot constructed a write() call with a data length of 3 bytes but a count value
of 15, which passed too little data to meet the basic requirements of the function
nci_rf_intf_activated_ntf_packet().

Therefore, increasing the comparison between data length and count value to avoid
problems caused by inconsistent data length and count.

Reported-and-tested-by: syzbot+71bfed2b2bcea46c98f2@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/virtual_ncidev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
index 6317e8505aaad..09d4ab0e63b1a 100644
--- a/drivers/nfc/virtual_ncidev.c
+++ b/drivers/nfc/virtual_ncidev.c
@@ -121,6 +121,10 @@ static ssize_t virtual_ncidev_write(struct file *file,
 		kfree_skb(skb);
 		return -EFAULT;
 	}
+	if (strnlen(skb->data, count) != count) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	nci_recv_frame(ndev, skb);
 	return count;
-- 
2.43.0



