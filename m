Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210724;
	b=uwpu7nlYQ9LEW/x3LTt5N3l9/fd/8i1eoywKXof6DFLXGbdD5U0tH5k2fjtxOQM5MzfY
	 K9Y5i5BrG/IzoNjvM0gcQ+srmrEOxSM0mDnYQjfuqxTYTSjFa1kl4ZJbhQTq40vCJtguK
	 aVSyYSNciCUjpECxVkpLiL8M4vAwL4bAQ1Rl1Wl0z8pNYiYVv09a50LM+BpiQ1ssgYHRU
	 DbXmoVNqoyH5ZOS9wKI/XHoX/DtaiCrTKhtJeslJzX3hAwLBckvsWuwV5sLFPeZuVrhn0
	 2FWF1BKK9zExLIgERcLobyDYkKM29QlmeFwpc1Bte1nHOtcOBKls0qQgquIkEXE54UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QKXt6E9quC3RV8gmCvqSEJpfWSZ4xsBZd2cOR1ocLX8=;
	b=tPjQugByw7vmaGCgPw+pkhWI8/fQiISCXg7NS0c/GJSvjo/pE8PoJPVPYTW8X2/g3qtT
	 Vkh3DznaE+XXx2stQpfpstG8d8rMmswZv9mMVfnKlxDHte5xSl4Qgv3AcPSVuclcwFITl
	 //1ztFZ01OrIhtF+rqyrfHasboHG8g0VyykF4038Smsm0Xe0Uw+OrCGTfMriqtJuF1Cv0
	 pDSkvZzuWHrkIm0/d8RsX2Usmeuzv2c/T9gcm/RgwCPQV2MAtdeL0a5Pe4GJZ4R4qXtWQ
	 T3e8/VpSf6voWgbj12LpPXBezazw0mRHg6sTspv9csznZvej9OuU7nwcypBEkKN+zRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=smyCqEbq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA994606A332;
	Wed, 28 Oct 2026 18:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=smyCqEbq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F3C1F031E1;
	Wed, 28 Oct 2026 18:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210723;
	bh=QKXt6E9quC3RV8gmCvqSEJpfWSZ4xsBZd2cOR1ocLX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=smyCqEbqVCTAGS5dy/cLDfoZj9P2UHrCcoDSBg9jzpyGdSzDKrhxa+6VEuiTkQ6U4
	 Ls3WX6E8+O2YsFOTCNolvXEwPa+6ouoPo9HdtJxbLKEtS0k4ib39ri5r8fTe44/t5W
	 Ad8YEPmmlMxw8ocxZ7WLYpLKK7+SCvjguGkNTyuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/571] Bluetooth: mgmt: fix race in read_unconf_index_list()
Date: Wed, 28 Oct 2026 17:54:31 +0100
Message-ID: <20261028170010.960650795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit b5dbb41b212c50c095a4dbee3017a84fe94f033b ]

read_unconf_index_list() counts unconfigured controllers before allocating
its response, then checks the device flags again while filling it.

hci_dev_list_lock stabilizes list membership, but it does not serialize the
per-device flags. During asynchronous controller setup, the worker can set
HCI_UNCONFIGURED and clear HCI_SETUP between the two passes. A controller
omitted from the allocation count can then become eligible for the fill
pass, causing an out-of-bounds write to rp->index[].

Allocate space for every device on hci_dev_list. Since list membership
cannot change while hci_dev_list_lock is held, the response remains large
enough regardless of flag transitions. The reported count and response
length still include only eligible unconfigured controllers.

Fixes: 73d1df2a7a10 ("Bluetooth: Add support for Read Unconfigured Index List command")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ replaced unavailable list_count_nodes() with an unconditional device-counting loop. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 5b67247587ba6..76d7dd7772255 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -459,13 +459,10 @@ static int read_unconf_index_list(struct sock *sk, struct hci_dev *hdev,
 	read_lock(&hci_dev_list_lock);
 
 	count = 0;
-	list_for_each_entry(d, &hci_dev_list, list) {
-		if (d->dev_type == HCI_PRIMARY &&
-		    hci_dev_test_flag(d, HCI_UNCONFIGURED))
-			count++;
-	}
+	list_for_each_entry(d, &hci_dev_list, list)
+		count++;
 
-	rp_len = sizeof(*rp) + (2 * count);
+	rp_len = sizeof(*rp) + (sizeof(__le16) * count);
 	rp = kmalloc(rp_len, GFP_ATOMIC);
 	if (!rp) {
 		read_unlock(&hci_dev_list_lock);
-- 
2.53.0



