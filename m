Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827224;
	b=B15zRBbxDvpAp9b7cG5eKy41mi83hXB0cHqfpk27X0EGDP7jfB0jiA0ininr0Eg4FE3d
	 DMpLX99JurdfPGiZ90gomD4/fBAkDjFQhyDq13E05Moprf/g6otMubo0Y9WXsQJys/N+1
	 MNT9OPmC4ITIXvY0vA9HoRkRGqkRy/FGDyrpQYNfyJfGZv7+Ou6pSyzSbJnCcdjnDoXan
	 JB6oZtObXjuoSNj8tGWCcvf8eqO06gTxV8dXBDUYbRVy+Gh+o+vhNfimuFtQQxEBF1osK
	 yesPZTRVxGc8LIN+QnUu8P+U8zPziKBZeQfNs6gHlr+0QV9wfQnrV1BLOgcuJqwIqHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9fME2ajxKzboMsO1tpxTxesIsBUtIyjl4nv+OEXZSfU=;
	b=uy/gPO+wfw1ygWXVqk6szDlgBriG/tx9JrYvBgpDiDtyMfSn53HZMurIqk9m0dJuTMJz
	 cc7tcGKNekJl8Kjg/1co3Qy5pWSpgEHFEupCSQ7mc1NYblfelJ8/tE173Js53nB62pVTU
	 H5j3Ov19XmszOdf1jBjFX8mbaMIssHgtSzp05bw89jcOPOfBEyXywo5FZmh6rFj3LSy76
	 0LDTecXXLOjZ5M4CIeCD3NF0KLBeoRH83LFp0OLxr9Yow2vXPdHCiJHyrnUE7wQoQ24C7
	 2WP1tCFXB/PT2RmjImgKitz7Ud+dOmfGTbwU9bMUlg7FBqZqPD9xCdY4c0ha5fj/V8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8Hvj6A5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC6C606B3B7;
	Wed,  4 Nov 2026 21:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8Hvj6A5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5821F00919;
	Wed,  4 Nov 2026 21:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827224;
	bh=9fME2ajxKzboMsO1tpxTxesIsBUtIyjl4nv+OEXZSfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8Hvj6A5ZI3EwuoWwhqO/AXqWxcN7GpLJXuIfR0oZ1/7IxhdsGOwI8WTzXAhzV8IG
	 JRGXmFbUc3opcsytX16rr2UaaXdK/lIyWnOMHohnYdXDfeKaejrnXed/3R9Le84OJA
	 N9GFQyp9igO08c9mSBS0932cWrvWRB56KYrZDSRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 262/547] media: rc: Ensure that rc_unregister_device() does not free input device
Date: Wed,  4 Nov 2026 16:07:26 -0500
Message-ID: <20261104211045.635761738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit 61c7ca95d2483c77dfdde1b007cbe846f145dec4 upstream.

During or after rc_unregister_device(), IR may still be reported which
results in a input event being reported. This could result in a null
pointer deref in rc_keydown() or a use-after-free of the input device if
the pointer was read before it is set to NULL.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/rc-main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1742,7 +1742,7 @@ void rc_free_device(struct rc_dev *dev)
 	if (!dev)
 		return;
 
-	input_free_device(dev->input_dev);
+	input_put_device(dev->input_dev);
 
 	put_device(&dev->dev);
 
@@ -1854,6 +1854,8 @@ static int rc_setup_rx_device(struct rc_
 	if (rc)
 		return rc;
 
+	input_get_device(dev->input_dev);
+
 	/*
 	 * Default delay of 250ms is too short for some protocols, especially
 	 * since the timeout is currently set to 250ms. Increase it to 500ms,
@@ -1880,10 +1882,8 @@ static void rc_free_rx_device(struct rc_
 	if (!dev)
 		return;
 
-	if (dev->input_dev) {
+	if (dev->input_dev)
 		input_unregister_device(dev->input_dev);
-		dev->input_dev = NULL;
-	}
 
 	ir_free_table(&dev->rc_map);
 }


