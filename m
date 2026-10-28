Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208466;
	b=tj4XW3RHATKcv65WBPvh6i9j3SXEtHjn9rm/WnQpXdahjD9kr0ksWIKByIDhSEPkx1g3
	 vICFf5/vr8yymQM4WPmGK4CdWeRJOWiS3gZcZ51NZdpg+O9kTLxe7d1NsnQe180oCAfBL
	 FjHwncECrSyrq0i5/LoO4zLeNNElOkwhcB4c3lcXbbcdOrDXdY313gPJ9aknlULMGz/Af
	 D4U0ahCBOVvCwFLhhvoRkVw4qBDZjWHosi/bBenwq7zi83a69XcSdfbLtWrelSGqO218n
	 64omYASuWOYSDt2yYfWsil1YY4oLUFyamO7kG03ZaCD0KnqQLWC6t9yaJnPxt/qm+Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0tmEJkjlGCNeF/I4tXeppwqmBIiAGUlCg95rbg7OvCs=;
	b=Ra9vw8RLsmvgDSGWYS/1SormVYg0peLnaOnwe4rpmsV/EH76ab3SygPKMk4Y3hWdHBT1
	 HnbyfJiVPirzAN1bGQrJk1sS7VUMZ3mMixKRolOeCz6JPfkCzmMkU9f+4zDwYZ0OKZNUW
	 yUJveNtfyBpxN+mm/yWNNyGq2q7fjgGRQRTMsewtByRjfmu66JGfhZyz3nzkBYyiQcLdo
	 XzklsGFfkLoGXjInWOVTfUQMQh7cZ1XCizt0p4dIPrn6a3hPf3C2bky5LPUEPtoT4vgOJ
	 6ma4k/3F8neXDbJIf+VKmDq6FZU0Gv/htvF//qGBzOmqo+4i6iJRK/raXULYVU22Vug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hi3LhULA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB4A606A31C;
	Wed, 28 Oct 2026 17:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hi3LhULA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0728A1F01825;
	Wed, 28 Oct 2026 17:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208465;
	bh=0tmEJkjlGCNeF/I4tXeppwqmBIiAGUlCg95rbg7OvCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hi3LhULAvGQ7ZZcxyZqld9hqcGqolvAUq5N6FNv6+k2ir24ubLdi6WachAeTcnN90
	 oBLyZhngki0Td5J/a9hz6Jo/ayc9YCPE4iKQuoxiBXtwzYiZGWufnZ5uDe6J/sQvfI
	 5P04MMmYbq6qZAjKCFLBZiua7I/X1k/02BvUE40o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/516] Bluetooth: mgmt: fix race in read_unconf_index_list()
Date: Wed, 28 Oct 2026 17:54:40 +0100
Message-ID: <20261028170006.545598218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3647e51d31062..eb5217b79e598 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -454,13 +454,10 @@ static int read_unconf_index_list(struct sock *sk, struct hci_dev *hdev,
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



