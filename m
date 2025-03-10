Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B612C1A7264;
	Mon, 10 Mar 2025 17:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627981; cv=none; b=KGqBI8hbtXgGiCo9QKrvMhS9AG31Tk80rO3cOcTa6mZDM/n1nK27HxOHIOFmYi95b+mJEMvaxW8mELCMV3YcUgz65ASxg61pW8EpDUbhwiKLJR8HDxWGjZJtViOxpxNoUm6yECMNoht/09QOjV5Dy+q6BEwn3wb+o0BsgoQlQac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627981; c=relaxed/simple;
	bh=oB0/tzJw7k/fsPuLavSfO9rzjh6L+/gkh/9LBg4EaRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4AhEpZcD3XGi7FEMW+fM7QCe36diSiEX02Q15fT1ciF69xSNw4TACGVAsJy78qgBloN3NMBA7BGp4szGbQC60FkQ1w18eXYbbVQU8hWM979rS7jKi43EMWsIx6BFivuckeq+LcuLGzpXs/Hs2GvKs3m0lqkq8j34y9ZPgsZ8Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajUs+ICh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajUs+ICh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB40C4CEE5;
	Mon, 10 Mar 2025 17:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627981;
	bh=oB0/tzJw7k/fsPuLavSfO9rzjh6L+/gkh/9LBg4EaRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajUs+IChZun8nXAMmnHVmbzKydbNpx05E47KZ/UzBItkCcLbFAzfj78xqIknVK4s3
	 CWoMPTA3BoBtZR5MB/O+bU07SVwKKlAT7FLnLVHX9+xSBYaajKOVYqyi3U9vX+V+hn
	 cRq1QFofZbYw1zZgY2ltaovUhWqHCdsXyKA8Luqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 047/145] Bluetooth: Add check for mgmt_alloc_skb() in mgmt_remote_name()
Date: Mon, 10 Mar 2025 18:05:41 +0100
Message-ID: <20250310170436.635598489@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit f2176a07e7b19f73e05c805cf3d130a2999154cb upstream.

Add check for the return value of mgmt_alloc_skb() in
mgmt_remote_name() to prevent null pointer dereference.

Fixes: ba17bb62ce41 ("Bluetooth: Fix skb allocation in mgmt_remote_name() & mgmt_device_connected()")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -10443,6 +10443,8 @@ void mgmt_remote_name(struct hci_dev *hd
 
 	skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND,
 			     sizeof(*ev) + (name ? eir_precalc_len(name_len) : 0));
+	if (!skb)
+		return;
 
 	ev = skb_put(skb, sizeof(*ev));
 	bacpy(&ev->addr.bdaddr, bdaddr);


