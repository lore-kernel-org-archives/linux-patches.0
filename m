Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7037368D40;
	Tue, 21 Jul 2026 19:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662130; cv=none; b=sxGHFfSrrKjw9IowQsTxOMrNJdIrJLK78m/li67NbD+pFJWC77e9fxIKJTDkoAibFg7fCoR+kGUicOywj7wC4QIt6O6Z4q2wD5S/0q/+U1tu8X8xyFhZ2vgXQsZ2A05s/ve0NtX9vc1d7n5JUqkdpY+DaYalAZ15C31cmEH4ugY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662130; c=relaxed/simple;
	bh=EjURLW+WIEKKPXr4j6UOljro6cT8KIYZhE4du2WEMeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lo+zCkxtn3fOer/pmZFiZKIcxwHIAbV6d5BzMK0mfi3u2N4dnpGVGmxXLjXpo6e/2C1ypPF+PlYrk4GltaHmWOEwOmc+oXAOjEG8JCGuVVdQmlEmLlvSSfpWfL9PpKvn79x7k5v7wR1VukTgJ0ug6hfdk97uDcgNCN8eZ7teJS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmWdGhSc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmWdGhSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5CA1F000E9;
	Tue, 21 Jul 2026 19:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662129;
	bh=EFEJjerkFEWOQqmeJvm+s3TJw98s1pm56FXduPQ3Qqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmWdGhScqP9dqQDLjsmdwSesCQ9xoA2UN5J85rklra1UzIRTGP0MWclEd2f86varL
	 NAEwBOXBiFsfSic+cmRi0kALCGI4LZdP56DnRvS31YaOyoXiGPH9skSrWhSBOcX0Ts
	 iKaOm0cXBzRIx25toCPBb7SPRaB3Dcuubbi1pUVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0321/1276] Bluetooth: btmtk: fix URB leak in alloc_mtk_intr_urb error path
Date: Tue, 21 Jul 2026 17:12:44 +0200
Message-ID: <20260721152453.278444338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

[ Upstream commit f396f4005180928cd9e15e352a6512865d3bc908 ]

When btmtk_isopkt_pad() fails, the previously allocated URB is not freed,
leaking the urb structure. Add usb_free_urb() before returning the error.

Fixes: ceac1cb0259d ("Bluetooth: btusb: mediatek: add ISO data transmission functions")
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 08a8c3a5d7b7d0..4d3f440565c116 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1051,8 +1051,10 @@ struct urb *alloc_mtk_intr_urb(struct hci_dev *hdev, struct sk_buff *skb,
 	if (!urb)
 		return ERR_PTR(-ENOMEM);
 
-	if (btmtk_isopkt_pad(hdev, skb))
+	if (btmtk_isopkt_pad(hdev, skb)) {
+		usb_free_urb(urb);
 		return ERR_PTR(-EINVAL);
+	}
 
 	pipe = usb_sndintpipe(btmtk_data->udev,
 			      btmtk_data->isopkt_tx_ep->bEndpointAddress);
-- 
2.53.0



