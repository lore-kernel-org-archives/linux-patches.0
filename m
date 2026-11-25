Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619859;
	b=uem7S4nTUZuJvvq+gSVgzWnyJEmPgOdmTFRkU6cD8+tBR0SWXy7qRJ6D5odxnHUNb22B
	 SpGM3n2Pt2qKRPy3ncRErfRzMEmKA3Lc224PPj6HAlsgCdHv6CXC+l0X6HLnaKMqtnzXr
	 HfSOwINpuWKjnLJ89XNpqVLxSzxp0mNMIXDubREdzcb8mxvGYSUHqVBJhoby3H/T0hOCj
	 u8rP5HCfsLoVN9CU5IbUIx3QcN4VUJhPFUtj9RlrHXqRBOVuIzHi7kVfqDNJPgkE0VLtI
	 bXAEN3dgag0ow0O144qV2Vzriz4r6h3P1uiMO5K3Ddc5F4UT5jZ25dJVuvMPNAOqXgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OW17Z5Yd/Sfu//3q597eIWERvRVy4B4kfsLBfy4LBbc=;
	b=1MILBUHl4/CxdgVwCmUmZ5JJK7Ocoi2E/FXmgJ1D4aW/qKEZ4WTBsJD0qEwfaJtkKNIl
	 TNw4tCj/uK8C4R9jIqjRZyA+bXubRINm2jWqmBiby5VAU//7GiijvSRH/hBQ7ip3megE+
	 H43/kvapsFSuVwaFMbxOdKKJl5JSgFtzHc4qt16PcChAPOvh8k1If7TpQWUV7OhHpyk2q
	 TxOK5p4uZ/9Gq0y6ggcwca9jTTidrhax3MKKt/fRImVxkPSnaLKepwCBaNf05Ma/G745d
	 BeQROAHG4qXGakrEGWfjJFKbxDI0fNSHvffGh6LryFJvdIxHXDSE4YO9h9IucmrBIuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=npR300Bg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7878606A323;
	Wed, 25 Nov 2026 15:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=npR300Bg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7487D1F000D8;
	Wed, 25 Nov 2026 15:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619859;
	bh=OW17Z5Yd/Sfu//3q597eIWERvRVy4B4kfsLBfy4LBbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=npR300BgY9PYpZjStTGpBonTx0KLGoeV6u9DIHNoJB2pc39USY194hWcDjjSBWabP
	 LZ0NuybtyonR2rGKRjjtvA5KCMSGnIA0prpQXvBwKgzCkICCeHuS7WZRNctgneg5Qk
	 HVaT8SQhCGUPrV8ivfwwekUciekdrAOTGKMpz94U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunjung Ko <hj351016@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.3 0729/1005] tpm: flush timeout work outside buffer_mutex to avoid deadlock
Date: Wed, 25 Nov 2026 15:34:27 +0100
Message-ID: <20261125143838.840293561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Hyunjung Ko <hj351016@gmail.com>

commit c22052a012698ce56d599d75b669d55778521c7c upstream.

tpm_common_read() calls flush_work(&priv->timeout_work) under
priv->buffer_mutex, but tpm_timeout_work() also takes buffer_mutex, so a
running timeout work deadlocks the flush. Flush after unlocking; the timer
is deleted under the lock, so no new work can be queued.

Fixes: 9488585b21be ("tpm: add support for partial reads")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunjung Ko <hj351016@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20261108165812.676876-1-hj351016@gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm-dev-common.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -132,6 +132,7 @@ ssize_t tpm_common_read(struct file *fil
 {
 	struct file_priv *priv = file->private_data;
 	ssize_t ret_size = 0;
+	bool flush = false;
 	int rc;
 
 	if (!size)
@@ -164,9 +165,18 @@ out:
 	if (!priv->response_length) {
 		*off = 0;
 		timer_delete_sync(&priv->user_read_timer);
-		flush_work(&priv->timeout_work);
+		flush = true;
 	}
 	mutex_unlock(&priv->buffer_mutex);
+
+	/*
+	 * tpm_timeout_work() takes buffer_mutex, so flush it after dropping
+	 * the mutex to avoid a deadlock; the timer is deleted above, so no new
+	 * timeout work can be queued once the mutex is released.
+	 */
+	if (flush)
+		flush_work(&priv->timeout_work);
+
 	return ret_size;
 }
 


