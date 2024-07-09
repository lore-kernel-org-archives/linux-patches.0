Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E8E55E4C;
	Tue,  9 Jul 2024 11:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523868; cv=none; b=t0dXrGCfc3ShNA+ip5QuiNdYAQbtOsCIb0ZvymndBGDWhV9d/iz6mMr90nVmzG7xUBd1ePo3gv8fAEZoBCTtlNteR5HXlF9M01uRVx2SnO8J0y2swVm1Cum5DjLZTT2076mX4SXUd3U7j7yD5u0SbRpe69xh9TU6m12ROjWvovo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523868; c=relaxed/simple;
	bh=ISPi45uWQiWOzZ9FkBIn+r0tNcpO4qwlmhmhewdEqII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SA2D892w/4CtHOoJLk70CE8eRVlR/sfZm/KT67xYjAKZiJV7imWWHGWKSjsP2Kc4v3BRsuZQ23E9Cv3/4PYJZ1qv444YB8Y+CYSL/v98s2femSe3WLVKQMddrW5rSSrqDOobj5SEdE7+Z36l7z3k4PjLwE6GZGZW4MRxxk1kZJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9O3Qdx6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9O3Qdx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6ACC3277B;
	Tue,  9 Jul 2024 11:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523868;
	bh=ISPi45uWQiWOzZ9FkBIn+r0tNcpO4qwlmhmhewdEqII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9O3Qdx6Tnpuk3/94GagDn670SsUolQYfMdikN/Dc08x3Gh/dwQIzfhZACpGYqcak
	 wGGfpH0C/Ond6qCj4SOKkJYebg+qvg7B+EDu6Hk2IYaJF78IfrCN9SVMXPhDRId5XS
	 BzoASLMci9UR4wp/oFtMvpOPvtE8Qr7NEVQE86Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+71bfed2b2bcea46c98f2@syzkaller.appspotmail.com
Subject: [PATCH 6.6 134/139] nfc/nci: Add the inconsistency check between the input data length and count
Date: Tue,  9 Jul 2024 13:10:34 +0200
Message-ID: <20240709110703.346846325@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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



