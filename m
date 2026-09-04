Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5EB396D15;
	Fri,  4 Sep 2026 05:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500978; cv=none; b=YROWDMFVXG/hCrc82X75Kzj6uj+2ZMvKW4DEXmi2NANz00V2H4YdtrUCnHQUZJpwutvx2HZdR6N+1EWq0CkbMOXm1RCjt+Dobk4QtkMNyZHps6sbwqRsSiQXbhRA5N1K+0YvWjggtUhQKRpYS+as1QJK+QrKoYfTaKKhQXjnass=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500978; c=relaxed/simple;
	bh=IuTerob8m66jonRNfAk53IkskkUGd/WMzEkJLda8aJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxab/pfU9LXqFWrxmcISe9orUgjLKlRlhgFbwomSjZ2b+sUHRHR/tQVGGHJ2AX4cI5bBAp8xKJvUC4yR3hQjNk6oC1C+G8rRf0RtWPqzNNkdDnzn+FZwi1dK05kynvRpkI2p3/WjOfUbstbTAuJ9yAKnzym+63prS4nXsdva1v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLWMkeAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLWMkeAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75D01F00A3D;
	Fri,  4 Sep 2026 05:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500977;
	bh=eORDviP6BejyvCVM/L2N+wUPyaSu9OXOU+HrwUKsis0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLWMkeAuJzA6xWvojLzz6cMrvLEioJfbRUSUA+l3TTCERZZDdOXYyYogHwZiF11Fp
	 yiOWp3xNGzIhvsWFa6j7GkOLjvniSsVwtXdzU3t+dgP38mmwiXKS1xsfgWRv2YGzB+
	 rqEW7f2FXybMcflYvdyqUsTl05NP5c7mrvCyzge0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gongwei Li <ligongwei@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 246/552] Bluetooth: hci_uart: Fix false success return in hci_uart_setup()
Date: Fri,  4 Sep 2026 06:56:43 +0200
Message-ID: <20260904045755.113392047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gongwei Li <ligongwei@kylinos.cn>

commit a9355799343e10014f2acfd4b6844d2335ecafea upstream.

When reading the local version information for vendor detection
fails, the error is only printed and 0 is returned, which masks the
setup failure from the HCI core.

Return PTR_ERR(skb) instead.

Fixes: fb2ce8d11f039 ("Bluetooth: hci_uart: Add support for vendor detection flag")
Fixes: 82f5169bf3d3b ("Bluetooth: hci_uart: add serdev driver support library")
Cc: stable@vger.kernel.org
Signed-off-by: Gongwei Li <ligongwei@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_ldisc.c  |    2 +-
 drivers/bluetooth/hci_serdev.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -451,7 +451,7 @@ static int hci_uart_setup(struct hci_dev
 	if (IS_ERR(skb)) {
 		BT_ERR("%s: Reading local version information failed (%ld)",
 		       hdev->name, PTR_ERR(skb));
-		return 0;
+		return PTR_ERR(skb);
 	}
 
 	if (skb->len != sizeof(*ver)) {
--- a/drivers/bluetooth/hci_serdev.c
+++ b/drivers/bluetooth/hci_serdev.c
@@ -221,7 +221,7 @@ static int hci_uart_setup(struct hci_dev
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Reading local version info failed (%ld)",
 			   PTR_ERR(skb));
-		return 0;
+		return PTR_ERR(skb);
 	}
 
 	if (skb->len != sizeof(*ver))


