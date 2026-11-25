Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621042;
	b=x1HZS41SFsA7XAfGLrLugERO+p64BVlctI0B0gI1pISmoaZoX3yPWQfre/tpw0lBgPqd
	 zSz1n07NFfEKchvv8jJirXBmQWYgsG1TndPrp4QeqqH6gp4p6A4xDHTSpPFLQnOvqV+iB
	 nbCwsjgQfNo6VDjIAAWQP6+vIVq/twoIdpEMGbVhJyG5IQ0Cw6jnHKfrm4KFXBkC62+/d
	 RL6Wv7kWcZohsqfwd8hsbHDSmLUASbw+UOPaNCNDlvpy2Pi8j9r4xK8FHtjTINcd7OSjO
	 3Wj/0xITBQG5pljMSUuWTt6QI7P4yUNJwNRUjdonfmEJoNeLo3crmTku/oh2tslRDjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+VUSB2iRK/oQmqF+AMG5yQFulzFLwsw85avW0TdDCEk=;
	b=za3Eo49RF3CSEfCPBmRdFqr4uuLiEqbsmHqEyBIKG3nhEyaqX94UWD7V2K/mQd2UYg3+
	 b+5SDZJAiHLbFO9oSpNoMVe5XQtLYjTCqaHA4XOGcBjvZjCMetzv7f7bsSKDWUshrKK6s
	 UD/OoGu3jA8csV0F1YZ0anvKS+S5vvCllNOCWprOqSNTHRuNYIpqUO4j7tfpv2Lrxplxr
	 T+xoeitUHyRQLz64Vq5UWVuha9vBgDqhex/09+QoIGv9lrnOMZaHIk351sYicx+QpmHaw
	 tTeSXkq0GmT8aGEjEOd3gj6bVUvt39K+vqojFIMLRMu7V6pNh04sUnFKdRD94JJeZPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RcUAHztq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E278606A683;
	Wed, 25 Nov 2026 15:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RcUAHztq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4719C1F000C4;
	Wed, 25 Nov 2026 15:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621041;
	bh=+VUSB2iRK/oQmqF+AMG5yQFulzFLwsw85avW0TdDCEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RcUAHztqvyD2ljVwCvY8oP/YnN/Whs2oMabDzXZTkIGCLhXo4BrFPn/Z0mDXhmF4V
	 0PhtnTIdUtwosgVyHcsqED5tT8Hv8WyhPTNp/ZB9zSb56h7WszLrq2SDzZXQUDnTZ4
	 WnoFho/C2b9mTFr+FUt+mzFrmiroolu0kQpnElQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	James Hilliard <james.hilliard1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 101/990] ptp: vclock: preserve missing hardware timestamps
Date: Wed, 25 Nov 2026 15:24:28 +0100
Message-ID: <20261125143824.456643022@linuxfoundation.org>
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

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit 63787dfd1b5ae720cc30dab5e66c8e4d81ff7391 ]

Socket timestamp delivery converts hardware timestamps to a bound
virtual clock before checking whether a hardware timestamp is present.
A zero timestamp means that the packet has no hardware timestamp, but
timecounter_cyc2time() can turn that zero into a nonzero virtual time.
The socket then reports a hardware timestamp which was never supplied.

Return zero without conversion when the input timestamp is absent.
This also covers skb_get_tx_timestamp(), which checks for an absent
timestamp after the same conversion.

This was identified during review of virtual clock sampling changes.

Fixes: d7c088265588 ("net: socket: support hardware timestamp conversion to PHC bound")
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Link: https://patch.msgid.link/20261026-ptp-vclock-sampling-v6-5-e705612541f1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_vclock.c         | 2 ++
 include/linux/ptp_clock_kernel.h | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 1a75a5b9bc058..0ecd63eb729a4 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -326,6 +326,8 @@ ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index)
 	u64 ns;
 
 	ns = ktime_to_ns(*hwtstamp);
+	if (!ns)
+		return 0;
 
 	srcu_idx = srcu_read_lock(&vclock_srcu);
 
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 884364596dd32..d199ac4ec1c8f 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -495,7 +495,7 @@ int ptp_get_vclocks_index(int pclock_index, int **vclock_index);
  * @hwtstamp:     timestamp
  * @vclock_index: phc index of ptp vclock.
  *
- * Returns: converted timestamp, or 0 on error.
+ * Returns: converted timestamp, or 0 if @hwtstamp is zero or on error.
  */
 ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index);
 #else
-- 
2.53.0



