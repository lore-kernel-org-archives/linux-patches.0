Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4841E55E4C;
	Tue,  9 Jul 2024 11:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524780; cv=none; b=UVMMXfHrjlOdBgFQJpGSDMDe+8UlaobV+GSBLEdPYCOl9bRuXPfeKlhfVNn5WlInQGHzA6xovJDqJJV0CoN7LWRGB3hjzc/i6Q2GJKaEBrivYD/eVVb9t3sHIx/LMpsN4qyna3FISM6HfVvzwhBfPLIDNMesb2vcK54/6QVzxKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524780; c=relaxed/simple;
	bh=g3jW3wyhuwealZ+7FJNLyVgeoaRe0PRBdK7Vs0sBCQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCrFixF/GwTmobTZ9jza1XUyRGpfOl7PWxETpRiukhdiZ4At+9Lyo6fGHGiveB2t7cTJLeS2JzAPckCKiteIxxGCW30mavlC+rd3dtIrQzPQ9Z9HnUbyrEQ7PLQg3BOt1cj1J99q/htE96+drjjFF0qzoKS010JwPQq0w1PQrgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQ5ciSWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQ5ciSWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0985C3277B;
	Tue,  9 Jul 2024 11:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524780;
	bh=g3jW3wyhuwealZ+7FJNLyVgeoaRe0PRBdK7Vs0sBCQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQ5ciSWB6iBjjlzflLtnfIpdWR25L+5YnBQNVkhe+kyhDpAYF4TqdkVy99A+wupi7
	 hwNjKSi/PJ3Iq/YWZ69GDWaR1ucR3RrPJ4VcZHvciGpQdoriBCGRgYUkUViN+vYFQk
	 mPeV41XrTr7PR02xGcrqnfLuLpzdsK9ViEvwWpS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+71bfed2b2bcea46c98f2@syzkaller.appspotmail.com
Subject: [PATCH 6.1 099/102] nfc/nci: Add the inconsistency check between the input data length and count
Date: Tue,  9 Jul 2024 13:11:02 +0200
Message-ID: <20240709110655.216764340@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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
index 85c06dbb2c449..9fffd4421ad5b 100644
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



