Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2B7847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81F3C4339B;
	Fri, 10 Mar 2023 13:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456438;
	bh=vAflRujeIwd5yjmRltTAMz6oUcD44FHsFvN0BM2wRmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqK+W/MWKFiZ+K6frfOM4hGwFKlM5gBn82U9hGUD9lrtJ4bjvJLE5ZzHTef5Pn7/V
	 6ADQnAXd9bhjsF/gC6plXxJpvYcVhLdLFZdzymSvnYRND4ovfgkTcM/NCuoXsl52fo
	 xFvLilDX4hF21bXWEEIppBg2vQj4iaEG+RLreVIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 172/193] nfc: fix memory leak of se_io context in nfc_genl_se_io
Date: Fri, 10 Mar 2023 14:39:14 +0100
Message-Id: <20230310133716.849553363@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 25ff6f8a5a3b8dc48e8abda6f013e8cc4b14ffea ]

The callback context for sending/receiving APDUs to/from the selected
secure element is allocated inside nfc_genl_se_io and supposed to be
eventually freed in se_io_cb callback function. However, there are several
error paths where the bwi_timer is not charged to call se_io_cb later, and
the cb_context is leaked.

The patch proposes to free the cb_context explicitly on those error paths.

At the moment we can't simply check 'dev->ops->se_io()' return value as it
may be negative in both cases: when the timer was charged and was not.

Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
Reported-by: syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st-nci/se.c   | 6 ++++++
 drivers/nfc/st21nfca/se.c | 6 ++++++
 net/nfc/netlink.c         | 4 ++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index b1d23b35aac4f..c0fbd88651b12 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -676,6 +676,12 @@ int st_nci_se_io(struct nci_dev *ndev, u32 se_idx,
 					ST_NCI_EVT_TRANSMIT_DATA, apdu,
 					apdu_length);
 	default:
+		/* Need to free cb_context here as at the moment we can't
+		 * clearly indicate to the caller if the callback function
+		 * would be called (and free it) or not. In both cases a
+		 * negative value may be returned to the caller.
+		 */
+		kfree(cb_context);
 		return -ENODEV;
 	}
 }
diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index 21ab3e678cf36..7946a2ee7bff5 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -247,6 +247,12 @@ int st21nfca_hci_se_io(struct nfc_hci_dev *hdev, u32 se_idx,
 					ST21NFCA_EVT_TRANSMIT_DATA,
 					apdu, apdu_length);
 	default:
+		/* Need to free cb_context here as at the moment we can't
+		 * clearly indicate to the caller if the callback function
+		 * would be called (and free it) or not. In both cases a
+		 * negative value may be returned to the caller.
+		 */
+		kfree(cb_context);
 		return -ENODEV;
 	}
 }
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index be06f4e37c436..9898b6a27fefc 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1450,7 +1450,11 @@ static int nfc_se_io(struct nfc_dev *dev, u32 se_idx,
 	rc = dev->ops->se_io(dev, se_idx, apdu,
 			apdu_length, cb, cb_context);
 
+	device_unlock(&dev->dev);
+	return rc;
+
 error:
+	kfree(cb_context);
 	device_unlock(&dev->dev);
 	return rc;
 }
-- 
2.39.2



