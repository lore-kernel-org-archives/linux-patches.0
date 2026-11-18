Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036436;
	b=Aj4VpVHPKWTg/sB7k2NPARdGANCusTEwKGoyb+LzgN4X+eprD6Uh34zKASnHGvffmO5V
	 uptDbYwmCjcSJhpmo6lUO8SBJqhIfrp0eytFIMQxORajAc+Qr2yveimADt3UG8R2WYFQJ
	 pejW50I1JAt1SAszjvJ59JsGRF1IvisxsueSJEdjl6ICDSJg73i6iaPwuSoCoTzNPBbpH
	 VeMGY+0VhKp+8XK9xI8JWF7M2T0CV7vPXZRFWMpJNIMdd+4gL2iz3vtK7PfYExOUFMp0d
	 jt6ZUbiAICk6/JMEhiu1rd3Gq7y/YWb/TdYkoiwmqboIFCHMiBwyDUwYHBhD+n1iNTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GHrGPbXn3Qi3MYR7u2t/Oi/9FHzRfwJTI0XOJXnkRAo=;
	b=E6s9eCV7hnzmszVg0pqMI/fEHSoSCKe4SRRy+h3Yw16jXi+1i+zsLvT4CisFl6+0CRsI
	 GP1wHD2k0BCptGcmJNZ1/q4sBsKxp2JRJ745822GPom/oxdPt8yvo2CZM8S5PXg4zh8K1
	 CnEdpXQIoEyRbdjXtykW4nD0lwjrggtsl/EjieqxQTj3uygutb6YAws3sHDiXBbFnoDtM
	 18vEmzsB+5jr1GBGiqhIDelKKEBSfS1iSsNtBMXLViQ29sImjiTn9XrDkHCk2PRyqJsRS
	 PCECs6mspasig1eW60eDhaB7wxde7VDQYfWztVogbgJSYcKjzIF9/JXgaGKus37s5rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mtSjsbza;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C25606A336;
	Wed, 18 Nov 2026 21:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mtSjsbza
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063BE1F000C4;
	Wed, 18 Nov 2026 21:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036436;
	bh=GHrGPbXn3Qi3MYR7u2t/Oi/9FHzRfwJTI0XOJXnkRAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mtSjsbzaQ3Ob1ZI/SeRePEwuvcYQrj7r9rFsQpbXazTpD5Gf6Xe3E+flt3hlH1Wmc
	 i7wQK4ffYCnxmr1mdqcTq6jKT7Ued8uKg4ugnUk0mgypprjcVYqPnYKG+xxSM4/ak2
	 9tCODUpL7DsfCSRnPVqaEqR3k89dkJdN9vOaPHdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1057/3318] slimbus: messaging: fix leaked PM vote on tid allocation failure
Date: Wed, 18 Nov 2026 15:27:59 +0100
Message-ID: <20261118150351.656914307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

[ Upstream commit c26cc979e28f5193310e4379e14aa6417375c565 ]

In slim_do_transfer(), when a transaction needs a tid and
slim_alloc_txn_tid() fails, the function returns directly instead of
jumping to slim_xfer_err. The runtime PM vote taken earlier with
pm_runtime_get_sync() is then never released, leaving the controller
permanently powered up.

As txn->tid is still 0 at that point, jumping to slim_xfer_err drops
the vote exactly like it is done for other failed transactions.

Fixes: d3062a2109309 ("slimbus: messaging: add slim_alloc/free_txn_tid()")
Cc: stable@vger.kernel.org
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101448.1084691-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/messaging.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/slimbus/messaging.c b/drivers/slimbus/messaging.c
index 245e9c7f92cdc..e9bb49bbbd082 100644
--- a/drivers/slimbus/messaging.c
+++ b/drivers/slimbus/messaging.c
@@ -138,7 +138,7 @@ int slim_do_transfer(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 	if (need_tid) {
 		ret = slim_alloc_txn_tid(ctrl, txn);
 		if (ret)
-			return ret;
+			goto slim_xfer_err;
 
 		if (!txn->msg->comp)
 			txn->comp = &done;
-- 
2.53.0



