Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F28B51C041;
	Wed, 30 Sep 2026 18:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793640; cv=none; b=QATv4POzCsMYVFNDa/+GsGOUZt02oWpGuNWn8BiVnBJ8RMk25BGo2CfLFyggeAquhAdUoG5Q0UDflkOz0GmmU+WjiNcBRip78pM0bJf2ynpqeQFYuvtHRmodGMmA/5fSuHLUPdtbl37n3SzR6mY7R4g+UX/aBXFe8HF+WYOrsVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793640; c=relaxed/simple;
	bh=GzRSxc81NFXR5+0+/WZCFoxjhlP5lxWrGf+d18Mf8/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nw59QVWurpSB7AmKjcjXjHLohRQRX5Iuf1/eiiGwVY9UFjwK2WgVe0OQvxg5nf00z1zfHZolT06mV0JtryEw3+MXkhn9wVt7/rxFy1cMU96dP+GH6f/DckooObuQ37dErUBnMYeG+jjj0BX4yB5kdAqZLFjo0eOpXWPJvMUMjsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txBlgJQ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txBlgJQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72F41F000FF;
	Wed, 30 Sep 2026 18:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793639;
	bh=mMvcEPee+r+lu1b6GDLwHZ+pwanV7IMdx655lgU+RNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=txBlgJQ5GdSD4bJRTCegrBynh4X+6yO5UHRuTHXhDXiS05XPNUKfOewpeidd59YW/
	 yJdy7jlLemPUAEKHYxoIP2dxE6V27sVyC4zOC+hg3sZ8EFlEYPb30U1Ju/J2DLvb7x
	 xrzLG5ULGWYMS+tSIYguaDLExbUgbMC28Kh+/PGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 327/395] Bluetooth: mgmt: fix race in read_unconf_index_list()
Date: Wed, 30 Sep 2026 17:29:49 +0200
Message-ID: <20260930152347.755088459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
@@ -499,13 +499,9 @@ static int read_unconf_index_list(struct
 
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


