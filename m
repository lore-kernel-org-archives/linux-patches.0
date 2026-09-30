Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA2B51A73A;
	Wed, 30 Sep 2026 17:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789779; cv=none; b=fZPNL+aG5oIHvwFbdBeUF2OUdQR14aRAZHwaw/QuwD+qaofe0NwhTgVHMOSfnUB1jYAmhOmtx1HmqSXfdyin79cdI9eR5dC+K+fpsCpsXx7uZ9/pwuLG//eR9vgmBSNX3YgdudH5mKQYnss+ISn38sBuOtqKUyQ02dZ73Aw8vl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789779; c=relaxed/simple;
	bh=ja9raiBMN11NC+2mXDgxZnKrVTr0cJQ75yVzFVmK69w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAfVraH0witgzck4+JR2YXkdLyb4uCpaPFbcRbBlbP48OVaVPDH5ZdOVRB+doeq51rQulaC1Sx5PmMnLNcbya75zrD5U1lRgySD8kWpSHBPkSYDqGgNp2e7yJ54I/rA7yYdmHnFUuSsHRiSkoo/oUogpqMauaoIe4fxLDiZtmIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHPf5Q4l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHPf5Q4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450AB1F000FF;
	Wed, 30 Sep 2026 17:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789777;
	bh=j8xHquKYm0tnxJ+QRzjb6y4KzoJ9Hnbtn0yqDQ2o3SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHPf5Q4lpGTp6w2m6OX5fkOyKedCfkDu1tb1tXJcNxNyear891p4HlZBTtBA2G3Je
	 wBP8H9nFxY7lMa5NBH74Xhxi+a5pRIHkJIAtwiN+w/YO+UPWE/w4sdKC3JW6xR+U0L
	 aI4+ZWAvHm8cgJCS17w+tQGYbraKJ605u0Sy40Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 542/877] Bluetooth: mgmt: fix race in read_unconf_index_list()
Date: Wed, 30 Sep 2026 17:24:13 +0200
Message-ID: <20260930152426.337421896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit b5dbb41b212c50c095a4dbee3017a84fe94f033b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -498,13 +498,9 @@ static int read_unconf_index_list(struct
 
 	read_lock(&hci_dev_list_lock);
 
-	count = 0;
-	list_for_each_entry(d, &hci_dev_list, list) {
-		if (hci_dev_test_flag(d, HCI_UNCONFIGURED))
-			count++;
-	}
+	count = list_count_nodes(&hci_dev_list);
 
-	rp_len = sizeof(*rp) + (2 * count);
+	rp_len = sizeof(*rp) + (sizeof(__le16) * count);
 	rp = kmalloc(rp_len, GFP_ATOMIC);
 	if (!rp) {
 		read_unlock(&hci_dev_list_lock);


