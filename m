Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623149;
	b=b2EEAww+r6k8BoHl6Gc3/G905JSFYkmIV2h33W/fB6HPsuQEZmCyNVePW+IyfgGB4L9F
	 lqHj/fn1BMFZohqXyMbPIIOrlOQHt1VpzaRqnh+DbajoaMbz0WPbqS4DMnCfftKDy8e0A
	 WYnpjh7ggWodnf5LcnbynYMdemeHp/Gz/grmKw83tpaHaa7smjJXZi6Ce1nlIfmHKGgLh
	 +n6xXnxF6XzNP6YWqVi3sSrZm+KXcNG+wZABtSKL6JMNb205iLWDYCVE1B1RhwOszGS+s
	 gsKgf0mweWWmvl8PQmJ5IEzxfoBFGUfpOQm1f0VToC9tKKJl9Kzw+RJOfQgprcxA3Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LNyVrcn49iBy9vGV9mQDbyQ8gjr3+vEPNuwW/gN+IYY=;
	b=vuBOc+ghM8ZHNabOxJmHEjIe+5t0OkCrCVtxJrSGO+PmN3B0JrBg9PFcIKJC3Dar7clk
	 Z1oHbnSdC1km7ctssyKGDzM18oMimjoE4cJvbMewaT/jlnVNoEQ+90owXNNb1mUO3OnZS
	 M9nH04ZwB5+da88YrGjOBiT//91m6W0/IQqMN05klBswSjh16tZmJTruM6aTv2YqHrj6Y
	 mF2TokyIodGHL1MqZpEx7xwIGM1HFn+to0y+RqbpyhAY38aqy59uY1PbNZS4UjokadKgj
	 4DF01Gk2L8Boz6IK4Prm3gHzdwDQbXVtnmNzYC7d2w1k7Xg2Pek2eA2saBZSDnwXGfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u9O7X4Dq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C85606A321;
	Wed, 25 Nov 2026 16:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u9O7X4Dq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326A11F000C0;
	Wed, 25 Nov 2026 16:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623149;
	bh=LNyVrcn49iBy9vGV9mQDbyQ8gjr3+vEPNuwW/gN+IYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u9O7X4DqUFc7ODOKnLCLGb/AXGs5ppI/phhnoWxFMetj4RN0xCZDkJogqkdrwTy8r
	 6pc6ugUYpRkHhGx8Ue5USweqIaiUAaebPvOn8Tf8D0nLZ7ToDMhnVvl2MxMcl/v9Il
	 Q0xOxw2gukTMsdDbKYPyL6NYRbhapTWE8TysA1qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunjung Ko <hj351016@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 766/990] tpm: flush timeout work outside buffer_mutex to avoid deadlock
Date: Wed, 25 Nov 2026 15:35:33 +0100
Message-ID: <20261125143839.997618699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


