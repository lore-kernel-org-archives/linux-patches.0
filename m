Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08923146D53;
	Tue,  9 Jul 2024 11:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524474; cv=none; b=GZqwCAqKnpdltbi6/+sC23ZOPrUXPorTjFW3jjRw0sgmbR/30cXP91mnBF/ZufDB082lREIls4OmucTTa6O5l1N6cxghWtfYoH/J/dn4Y7qj+n8kMQPstBPU28Q5of6orilQXgA4Z+cdu6UwrNGNai7luEzaUS2lIjc8cWjPEA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524474; c=relaxed/simple;
	bh=TeK9n2py4Al6y+CFhyfg0EO26XP5KURFiLWNxVWKuRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQnVLUD64RHj2PH2I2xidZXGhnOlu5xMuKNoMrwBTA9ruMoxM3fjr1uTh3Av6ZcRYXCgdCiVlEP6gbF/DpC684OhqV7LkK3iaoNCnOcnwU1U/wtOdxwusWo4V8sJXxOvKib6yBmsM//SU/QYTJD2CnhRN+qlQNg6zXcORVH/nIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMApgdrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMApgdrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AC7C3277B;
	Tue,  9 Jul 2024 11:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524473;
	bh=TeK9n2py4Al6y+CFhyfg0EO26XP5KURFiLWNxVWKuRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMApgdrUMmxHoDUewRZ9t/dnjt7Wsa5T1IIqWZOIoAU9nkxvcnyOOgFaS0wwvsU3n
	 cFMKZsmWdM9vgtb1Cia6e4E0eWFLAP+i8MNIymVvqamxmAaTNLCVVlw1WWOpLktGOg
	 NW/tKewONC2TD+iOg7XNxOzhm7hmmrjT95MQBo2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+71bfed2b2bcea46c98f2@syzkaller.appspotmail.com
Subject: [PATCH 6.9 191/197] nfc/nci: Add the inconsistency check between the input data length and count
Date: Tue,  9 Jul 2024 13:10:45 +0200
Message-ID: <20240709110716.331114786@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 590b038e449e5..6b89d596ba9af 100644
--- a/drivers/nfc/virtual_ncidev.c
+++ b/drivers/nfc/virtual_ncidev.c
@@ -125,6 +125,10 @@ static ssize_t virtual_ncidev_write(struct file *file,
 		kfree_skb(skb);
 		return -EFAULT;
 	}
+	if (strnlen(skb->data, count) != count) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	nci_recv_frame(vdev->ndev, skb);
 	return count;
-- 
2.43.0



