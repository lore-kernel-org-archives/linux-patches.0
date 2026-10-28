Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208702;
	b=emeEwE0Oeb0119y4EGSbl0mex/7dDBdfPITh275zmiub5pBM4kEV4bzlrbA5q1sLPfKo
	 DRVX4e/ia8Kruu9olMfxp6hc8ZVtl3dVIleTjnR7C9aymEZ7E8kUrydrvu3QFgw5OnRoy
	 uQyIJDAoKjtdyKaOIztF5euTNKazGaQUePwDaoP+QHVqyphqdbP7R+dPwb3LZWd3b3rjG
	 NGES5f/Tbf8M72ZbJYmQXbho13P4azy2TP0aQjbEr6YUig7ZnTVUkTy/a/Kx5FTrhJNYL
	 bhTPYoadkBwGacRQZwWI/0ooBXPkHhzKlnPw4HYhACboSFQFiOvZP0xsSPkII6W58Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QTnFaiBzozxk6l2y1zg0xEF0iodS2Npf4Ozybr1SYMQ=;
	b=Etha7MJFobyFHM4pw5nerPjT8aD5I356XiJsPVp4J/uREVi9VdBxoavy1JduN++diEX5
	 f7vKwK/R5zR7on8Ddh43gOo13LC9Li3PspKP5wfDrDk6sVgOWoT/kKlglkLWd8/q1FKQe
	 U8Cri7Pn9ivjKuAknVOak10Bzuf7TPl3xHcGT8lFKUpTl/rbN4Z9UBspgYczAKBTFcrrN
	 Z4HRp+cLsQBFfgp58BZXEeN3Dlhwh1ICeuQvE7EFURlTE037Xey3vTemWQcvLiPHA5Hk6
	 SVS6RmgNrIDuN2iMjq5jCpPJAdOmsxqgV5s+lzVsLxko2zGsJAyy3cy2lP1OXE8Dh6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JEhoyQrz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEA0606A31A;
	Wed, 28 Oct 2026 17:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JEhoyQrz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444FB1F01825;
	Wed, 28 Oct 2026 17:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208701;
	bh=QTnFaiBzozxk6l2y1zg0xEF0iodS2Npf4Ozybr1SYMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JEhoyQrz+xQZ2kY/MBPCHW5Cf7+2Ev/NgY9qRdosD8b7OH1EX8mfTcc2suzOMucME
	 d6cJ1KV/LXluvVvXkaE+yHEH9ZMXHSnzBALgct6yU9wd03nOo2xmj5aoeiBWeGl48a
	 iChYfpk1ycVFfxmtTf7vlkmpYGIqguHjsffIIy1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 212/516] Bluetooth: btintel: fix buffer over-read in btintel_hw_error()
Date: Wed, 28 Oct 2026 17:56:04 +0100
Message-ID: <20261028170008.521987921@linuxfoundation.org>
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

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

commit 40eb4b18ad167b63644c27fa67a7400ba050379a upstream.

The "Exception info %s" print uses skb->data + 1, but the 12-byte
payload is not guaranteed to be NUL-terminated and can be read past
its end.

Bound the print with "%.*s" and skb->len - 1.

Fixes: 973bb97e5aee ("Bluetooth: btintel: Add generic function for handling hardware errors")
Cc: stable@vger.kernel.org
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -210,7 +210,8 @@ void btintel_hw_error(struct hci_dev *hd
 		return;
 	}
 
-	bt_dev_err(hdev, "Exception info %s", (char *)(skb->data + 1));
+	bt_dev_err(hdev, "Exception info %.*s", (int)(skb->len - 1),
+		   (char *)(skb->data + 1));
 
 	kfree_skb(skb);
 }


