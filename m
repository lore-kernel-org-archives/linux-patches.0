Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B287C2E3AFB;
	Tue, 15 Jul 2025 13:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586703; cv=none; b=Nup7i7QVBJ4GNrxjv4f4AeenKMgZ1vOjtOPm1nW0aSZUZuBeLrFCLPbvsZcxmS/dzgyZtBU2EPRxDwDlVUUB4MnQxL8LN9BugY2nfqT15mr4AQHkye+z8e8haXHErT5plbgIHsF4T8fyleCcNC3AuTyv05EADxOeP7Odb6KgGCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586703; c=relaxed/simple;
	bh=Bc3+ApIlseck3qkWSyJsO9ZxEHCcnOyqbaTnlGjoqG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGy9SFWBYp8sAXE2J7gjVO8qRmy8ZO1iPBcExRygS7yRIKWhrwhDEFIQgwHX1FlMqy9jQrPLtV8bVuNweRywhFcOv24HP/6KcTNAnhHBYMTu3WMdP2EZ+8VsA8aiNl5noEAQ1xQBerwLlVewVYmEAKSWl7PPRoQ4hPWV0/aLa5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3ZTlWxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3ZTlWxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339BFC4CEE3;
	Tue, 15 Jul 2025 13:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586703;
	bh=Bc3+ApIlseck3qkWSyJsO9ZxEHCcnOyqbaTnlGjoqG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3ZTlWxK0S+eQkTpYrigKK0Jm9pSnPiGBgMqmc6EKfFz6PQH3TX5Ga/wAri8ZjZ2c
	 A4EmKsvaCuVEn0XcbvZN4aeBtpl0QkaUfjlQKRgMVBxjRb4Mynl2oJJZunVhLD05mV
	 BaDed8ZMdl7vakTTSJZMREHsZhnB1Ifxx9JAQ0kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 017/192] Bluetooth: hci_core: Remove check of BDADDR_ANY in hci_conn_hash_lookup_big_state
Date: Tue, 15 Jul 2025 15:11:52 +0200
Message-ID: <20250715130815.555589074@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 59710a26a289ad4e7ef227d22063e964930928b0 ]

The check for destination to be BDADDR_ANY is no longer necessary with
the introduction of BIS_LINK.

Fixes: 23205562ffc8 ("Bluetooth: separate CIS_LINK and BIS_LINK link types")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 6e9d2a856a6b0..1cf60ed7ac89b 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1346,8 +1346,7 @@ hci_conn_hash_lookup_big_state(struct hci_dev *hdev, __u8 handle,  __u16 state)
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(c, &h->list, list) {
-		if (c->type != BIS_LINK || bacmp(&c->dst, BDADDR_ANY) ||
-		    c->state != state)
+		if (c->type != BIS_LINK || c->state != state)
 			continue;
 
 		if (handle == c->iso_qos.bcast.big) {
-- 
2.39.5



