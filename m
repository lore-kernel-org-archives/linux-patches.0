Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412CC3B52EE;
	Thu, 30 Jul 2026 15:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426957; cv=none; b=LdP+2pJD0C8VVrhUDF1SbcsiozwiuNA7Hvg5RG2UZfstKQreTrAXocTgszJ6IKA4E6Vgk+Ezp2sYKUE0qfu4zEC9CO6X5n+xQE4alAW3D31NfMt7TVeS6XJKxaAkAGFUTU3PdNkf6JjfeRu8duvP52/gzgsJjC5dxClPGdp3DX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426957; c=relaxed/simple;
	bh=6il7SY8ao8sxm9B8c0OyFGVW/TzXH2ZKUWZMLIT56r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWdlQAhshvvXc1AOWgCTblQro9FkgwMH/CQxukAVp5OWaZhv4naS1KaH7k7H3Zgb4sm62uq5LQ8/1tpdqcBoUvTjrIEhMBBvbFwcQYyiAsRO4kFtoFx0+JKHdnP+eRew/NoZ8YyjAgvcZVyv61NTN1uM/YQBtYWypHyZmWQPG1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8HJMnLr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8HJMnLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D40D1F00A3A;
	Thu, 30 Jul 2026 15:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426956;
	bh=+ykH/2zy9gMvlB5BMrMADIw9wd89Eoj/EmIAGEKC8HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e8HJMnLrQm0gBFxXWMaMp403tkvQ5NQ/2Hg0lRU8Mt8eJ57JnMZ13CSN8n2QlmSib
	 DTJv0lRkHFGjkONdnC3ikY6wqnuajd7zxuu7KjHbDjNX9GnXpQtZV7175+VrmDV6M+
	 GPRMuimWcjVDGFrMUkDSu5S5OqEZj48Jc9hVu6Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavitra Jha <jhapavitra98@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 600/602] Bluetooth: hci_conn: Fix memory leak in hci_le_big_terminate()
Date: Thu, 30 Jul 2026 16:16:32 +0200
Message-ID: <20260730141448.663593557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Pavitra Jha <jhapavitra98@gmail.com>

commit bfa9d28960ed677d556bdf097073bc3129686229 upstream.

hci_le_big_terminate() allocates iso_list_data via kzalloc_obj but
returns 0 without freeing it when neither pa_sync_term nor big_sync_term
flags are set after evaluating the PA and BIG sync connection state.

This early-return path was introduced when hci_le_big_terminate() was
refactored to take struct hci_conn instead of raw u8 parameters, adding
PA/BIG flag evaluation logic. The existing kfree() on hci_cmd_sync_queue
failure does not cover this path.

Fixes: a7bcffc673de ("Bluetooth: Add PA_LINK to distinguish BIG sync and PA sync connections")
Cc: stable@vger.kernel.org
Signed-off-by: Pavitra Jha <jhapavitra98@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -804,8 +804,10 @@ static int hci_le_big_terminate(struct h
 			d->big_sync_term = true;
 	}
 
-	if (!d->pa_sync_term && !d->big_sync_term)
+	if (!d->pa_sync_term && !d->big_sync_term) {
+		kfree(d);
 		return 0;
+	}
 
 	ret = hci_cmd_sync_queue(hdev, big_terminate_sync, d,
 				 terminate_big_destroy);


