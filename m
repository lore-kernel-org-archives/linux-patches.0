Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A4E22D4C3;
	Mon, 10 Mar 2025 17:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628346; cv=none; b=jKnoZm/1Ipv6Dh44Z1TI+6hoCqbIowpCVvaNRwsxq3rl4kKnhQpS11mcuFHvYNfOT+tytanOR+bnDS71ZaTtLkMbl9sB567xUHeqSx+Ld6XZj6btpaqoA+B69JqtflKCnsLvFr9hVHQ9sX2Q4sy0TjsIjlr7Q8riTIKyF/Odne4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628346; c=relaxed/simple;
	bh=XwTKVDogXgjxZxV8tXO6mISeJwOPFmwFe7C9WH6G28c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cykxz6nYuRnZ3RR9VoJ/JQvq7488BNoo22l9GJHys9eG02aJ7vCf+1KuQf8ply4g8sG2qJxfKLiNoX6A9EGhfMDob/vgf3iZVlH+P0vyKyhNm/tfqflzQ6UiKzJ9aplln3Jc0RuoOptpkYC3LXxJSfL0FjlXROppjHxt76dWCng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUrxCvY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUrxCvY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D414CC4CEE5;
	Mon, 10 Mar 2025 17:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628346;
	bh=XwTKVDogXgjxZxV8tXO6mISeJwOPFmwFe7C9WH6G28c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUrxCvY9ywXc5uEdCzzpMzCI1yr3Ltecz2H/O+vUOANSxd0pOLTu7OJlaJmKVZi/z
	 vDB6cNhYQWISFsbL9AOyNYFTkISBK9FcpE1L4YvxAjkXirYzHbRh/aXFavNQgcND01
	 /uMEJGUntV5Q6PezUGWxKioHUISkj/s40iOKjhZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 027/109] Bluetooth: Add check for mgmt_alloc_skb() in mgmt_device_connected()
Date: Mon, 10 Mar 2025 18:06:11 +0100
Message-ID: <20250310170428.633253837@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit d8df010f72b8a32aaea393e36121738bb53ed905 upstream.

Add check for the return value of mgmt_alloc_skb() in
mgmt_device_connected() to prevent null pointer dereference.

Fixes: e96741437ef0 ("Bluetooth: mgmt: Make use of mgmt_send_event_skb in MGMT_EV_DEVICE_CONNECTED")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9733,6 +9733,9 @@ void mgmt_device_connected(struct hci_de
 				     sizeof(*ev) + (name ? eir_precalc_len(name_len) : 0) +
 				     eir_precalc_len(sizeof(conn->dev_class)));
 
+	if (!skb)
+		return;
+
 	ev = skb_put(skb, sizeof(*ev));
 	bacpy(&ev->addr.bdaddr, &conn->dst);
 	ev->addr.type = link_to_bdaddr(conn->type, conn->dst_type);


