Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E7D332EA7;
	Sat, 30 May 2026 16:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160366; cv=none; b=uItwxAVh/YGLtOk54ACdCWyeGKR9xO9E3n1ig1KRAqg3aaTnPz6+T+QB/k8SnOxoCK4llwugJqr06/e0IYmP4UoR1heyJ8WCieunQlCpW+K1ko5leIkZIg9mXiAX45ZzVUx84OZLMTd2crWodRWBa0p9JuftbqBcxMihsrYi1ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160366; c=relaxed/simple;
	bh=5VIdEr81m8qpuMVbLhYGHjxnvVj2B21zaTEQ9d2mIIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIYZCaZcu97VBuWIzr7tAcAv1P2zq10AAegOhdTIEYtAQuPt/PdXZdJOfotSMsBW2tGMyjAIY1Fnzi/uOHyvd/gXQD+5Trt+tpG9P+9DACaQvwuhLLtn8VTlg7vYvNkLPqXfAw2Ja329pIimL0Uz6TcXLmfGPDUskD5HwIoQnmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xg2BtSPA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xg2BtSPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7003A1F00893;
	Sat, 30 May 2026 16:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160365;
	bh=8O7Bpn3nIofmU72KC6qy1me8huTW3PR/D5lHILnRvzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xg2BtSPA9qL7sku6b2wUqHeWL8/UFOij6GueAzb6waliRAqzNbDZ1ph4Ho5vKa4Jk
	 qbVzYPRKBAh5TDGgoMsb6o0QXej+65y9mNOAwu0XfqHMsRkiPq2O5RU51jRwrYod7l
	 qzl2RtRNr1l4Dr0x9hM32U6fOSekMG3WRSN+uYzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 319/969] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_state_change_cb()
Date: Sat, 30 May 2026 17:57:23 +0200
Message-ID: <20260530160309.214914330@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <oss@fourdim.xyz>

commit 2ff1a41a912de8517b4482e946dd951b7d80edbf upstream.

Add the same NULL guard already present in
l2cap_sock_resume_cb() and l2cap_sock_ready_cb().

Fixes: 89bc500e41fc ("Bluetooth: Add state tracking to struct l2cap_chan")
Cc: stable@kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1663,6 +1663,9 @@ static void l2cap_sock_state_change_cb(s
 {
 	struct sock *sk = chan->data;
 
+	if (!sk)
+		return;
+
 	sk->sk_state = state;
 
 	if (err)


