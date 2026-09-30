Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622D9449B17;
	Wed, 30 Sep 2026 19:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797237; cv=none; b=KYdOY2mhJtEwzsrTAunZR+TmLIveaHiU8W9wFjTrhwRFFAlsUnjRjWGRaOl4CmWQBE7l8j798XaSnfoXnAQId7HeF2HZbLuNVFp7zz2Dohsc280lpTtnbijrZ79AwfluhrFnDtiPlxKjucduC5wYAid7i0G4vmSqiNhOM5qmxw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797237; c=relaxed/simple;
	bh=UZaWcTc/tjUf+PfaqBnxpLHeaiDz1thDYLbZJjZVWMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d69KYcjbbutgpT3csNSu63XWhlByjgk0XMfliA2NqOBZuY0BXpZuZutNkFo65UNFwxJBwzyXrEAgURtMSwYwmwbhR52faCOy7vj2vZ8ih3Y9zWucz9YcnlpbnqILSOfWeEGugtIEaUNYajDfSNfGyF28jmzKtiBR809d/f551Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqgZt784; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqgZt784"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC141F000FF;
	Wed, 30 Sep 2026 19:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797236;
	bh=7R0vpeV2N/Iuzrw43dQED/DOlCRE4dnEkW/J5bU5XYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BqgZt784MN7FxIwp5zB4rmg2A/QPJ5lLwyA7uPNo+FJf4hYxTCXudy08P5ty/ZPF4
	 6g96RRB+06s20rcl3js7AaaAubavNC4Q9JDve9vVJ5uKI0oxGd5lQBEC0V1SQM46JD
	 3JSE39YDjIKU0gm0/CeTxgiQVqpvEs4tZ9nppOlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 1150/1193] Bluetooth: mgmt: fix race in read_unconf_index_list()
Date: Wed, 30 Sep 2026 17:30:34 +0200
Message-ID: <20260930152459.789483899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


