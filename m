Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590923;
	b=UbfbxjihGuK6iJAMUWEweQZZok59Z2bMHepnLjePLY/B0OXvfzMlLBKUAINo54PfA0/Q
	 ahnWLPEnxpQp0xvkKMO7R0Uhb+/Vv7rzbzJLdl8Q2Utl8e+bNKBvzV/5U24fpoEIfNegA
	 NYe+NCNlA+2NGJKQnyNmPVEGkZGVXwydDHIt0E6xM1giRQ7cooccmZl8ekPP+hSPKU110
	 9Rt4/P9a8LemC6sIIe7L+sw25C2TNXMNmFexrHRn2m8ASPltnNLOfBkezD6PwJQGFJVTN
	 i2Z544jOqoNF2N2stcHvlQysjzpc19bDJpy1MVT8TVNL/6s3RucE07TbB+k6pxvocoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p2PWV+2BV7KmTGFE7cA5FQ6y1uuyX2TWmdugfCQJMr0=;
	b=JwIZ4S4ureqMF3dwjLE0s1TcMgTRfiKCkocghHekjFrgCbwE45aRdGaietqBeIRGstsd
	 QfYYpOsOej8pt81SplSi6QpT2SMUGPLzOhWCohXsh8Iopdwf/UngNLWNfaS/1ZTrCIAGy
	 x5M2Je9BuRPRbhgKy5cjx4xDJE1S2Oo+r/sIsnjy97Xaqt/K+bTLBDSVgot2oeL/Ks1Rh
	 hgPshyifAIApSrL7AjMlF+hBbAzz6S6fhRX7u7jxzFgQBb6BKlyOd9JxNCVaAv7ZgK6Rc
	 iaCzz90FTmLrfyXQSO3uIN/Z4n10AiJ1oQbEdiRKBKYB3q5X8U3dOXOKV1QC/0pWdJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ReTdybV6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCB6606E65F;
	Fri, 13 Nov 2026 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ReTdybV6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAE81F000C5;
	Fri, 13 Nov 2026 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590923;
	bh=p2PWV+2BV7KmTGFE7cA5FQ6y1uuyX2TWmdugfCQJMr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ReTdybV6alqU8Zr1YDe9bPy8hY17dzmXfY3af6rirAjw/DA2FvKS+GQFvPvbj8tmr
	 YV4qP2jWmkNKXgxr7JJacIJFDOTUX0VzgkzEJ/YgAkaFsh081sPUI1JRWb82hLcTrJ
	 MZ0GdRGh3gpJ8a/NRGP8moXpQkz4pCbn/zSLsD/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/670] 6pack: restart the transmit queue when the interface is opened
Date: Fri, 13 Nov 2026 10:44:35 -0500
Message-ID: <20261113153815.610836816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

sp_close() stops the transmit queue, but sp_open_dev() never starts it
again. After the interface is set down and up the queue stays stopped,
sp_xmit() is never called again and sixpack_write_wakeup() cannot wake
it because sp_close() cleared TTY_DO_WRITE_WAKEUP: the interface no
longer transmits until the line discipline is detached and attached
again.

Start the queue in sp_open_dev(), as mkiss now does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 0bcb990faaef028c18b553d416037efad044c81f)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/6pack.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 437e5e391a770..5168658ed2c9e 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -256,6 +256,12 @@ static int sp_open_dev(struct net_device *dev)
 
 	if (sp->tty == NULL)
 		return -ENODEV;
+
+	/* sp_close() stopped the queue: restart it, or the interface
+	 * never transmits again after it is set down and up.
+	 */
+	netif_start_queue(dev);
+
 	return 0;
 }
 
-- 
2.53.0



