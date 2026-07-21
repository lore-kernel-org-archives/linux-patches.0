Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1504D1F3D56;
	Tue, 21 Jul 2026 17:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653807; cv=none; b=kQUGG8sTC+hUZoXczdDm9TjsXL2FRJYMU6aqWy503HZJzbxB2xh8t2yXT8ldIao4zRHVzWp+wmzLrC98aP576VlfSaC68meVj+yI7wkM8X35eh9d54Wm7G19U578YJmEOtzWxp96Km9xqnpOgB0pv79+1ODZz67Fj3o5/Midlyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653807; c=relaxed/simple;
	bh=hgoeu2YpCUjJ3JnmeedakK214uPSEOXhZazEhApp3cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrYwT8sWkWkWAAzMXOtltbHnT/WOYEj3WlKYjPtJ/vleUo9J6pvaG1o1ncSrNdPFmTjBqU7W63gkuqXjVwXBde8qvh+Cw6TYpVBDFWDYOwCfx0utgPcZVW4sxg1lkk7hUc9foysZ6tLCOS1VZhDB/FUmLOmQzK2Z+ZrO9ax5PW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MjETkoYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MjETkoYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B13B1F000E9;
	Tue, 21 Jul 2026 17:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653806;
	bh=BelA6K8RJIE2hlwjwU1OLDjbxDGd9LDm0VaMRsAt4oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MjETkoYDhFbmCgzBT1Q6a+ruDWhspMSJBZeoXuCoQSW0k8ATT8m0LUzRkh2Ec10DV
	 t02Ij/XbhJTk0zP5JdMGnvkiWqvD8LRg9ruG6dl/ypY7RoGuSY+Twbu7pkcIK195ft
	 UuijzBojKtuWpC5hDN6G/vzthH51SJxxoisoz9Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1465/2077] Bluetooth: bpa10x: avoid OOB read of revision string in bpa10x_setup()
Date: Tue, 21 Jul 2026 17:18:58 +0200
Message-ID: <20260721152627.353091998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit dd068ef044128db655f48323a4acfd5907e04903 ]

bpa10x_setup() sends the vendor command 0xfc0e and passes the response
to bt_dev_info() and hci_set_fw_info() as a "%s" string starting at
skb->data + 1, without checking the length:

	bt_dev_info(hdev, "%s", (char *)(skb->data + 1));
	hci_set_fw_info(hdev, "%s", skb->data + 1);

A device that returns a one-byte response (status only) leaves
skb->data + 1 past the end of the data, and the %s walk reads adjacent
slab memory until it meets a NUL. The same happens when the payload is
not NUL-terminated within skb->len. The out-of-bounds bytes end up in
the kernel log and the firmware-info debugfs file.

Print the revision string with a bounded "%.*s" limited to skb->len - 1
instead. This keeps the string readable for well-behaved devices while
never reading past the received data, and does not fail setup, so a
device returning a short or unterminated response keeps working.

Fixes: ddd68ec8f484 ("Bluetooth: bpa10x: Read revision information in setup stage")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/bpa10x.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/bpa10x.c b/drivers/bluetooth/bpa10x.c
index 2ae38a321c4b3c..e63d1af250ec91 100644
--- a/drivers/bluetooth/bpa10x.c
+++ b/drivers/bluetooth/bpa10x.c
@@ -255,9 +255,13 @@ static int bpa10x_setup(struct hci_dev *hdev)
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
-	bt_dev_info(hdev, "%s", (char *)(skb->data + 1));
+	/* Bounded print: the device controls skb->len. */
+	if (skb->len > 1) {
+		int len = skb->len - 1;
 
-	hci_set_fw_info(hdev, "%s", skb->data + 1);
+		bt_dev_info(hdev, "%.*s", len, (char *)(skb->data + 1));
+		hci_set_fw_info(hdev, "%.*s", len, skb->data + 1);
+	}
 
 	kfree_skb(skb);
 	return 0;
-- 
2.53.0



