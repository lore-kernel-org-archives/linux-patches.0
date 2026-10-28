Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208676;
	b=btM8qGV97TS5qlvGocVc+RLFJOy7qx9i2q12Le2gcjDPIwx/asvXtcC4+9bWceixbls1
	 BS5FwETlDJaKVKiWw+oEcfWhr6eSrOx63vCWLpsXVOVRWmpdeWWzltiF6XejGGlQ5Q3x7
	 bPuhGDrto7Hu9JcTvqENQT/48Lj2A5XDtFTiPLE3CJBUsJNuY3ck24wAJUu2X3qcX6Okd
	 qSvFEqvUob0jDczKFZSIVdxb4jx/jojyJ3b3boqlABkjCqQY4TBknqDT+Bd/LCCZxaxLX
	 p91IGuIC2A69D9Hqif/ABBjvzCfEvfqFpF5+LKjqlfu+pSvLX5k3PghvSkJWc+gjcaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zZbz4cEhkePOvaANj6skz7nd2uxzbQ6GTYV0i1WN60I=;
	b=SKM4FI8C4NcqWZUfZ4+QN/eTXQUnNtSz2GTUQ6vaqfvWrgtY/GUjCjalaBgUxqHZx6nM
	 0lYU6mzs3te43klQ16QeUFa4y8Mi5bkV8FA3n87ecZhyWU7gk3rklWEt9o/zfYxkpf0Ch
	 0Ndc91bb6rqfMF6C4dyrTLvG/fvkUvwGxjVUp2br+jSTKOXlSO4aJ0Zp9+hK7saXQI+Tc
	 goxTQVPpcuaaZ3Rj4JRrDftkDHpPK3jHj9aApyZV1oU0z4qDubMi5k/yGOa1IvAppdSJ+
	 vni4/cq4wIFB2sutVAvm8Hk1f1D+jfrjgqcKoS729bfo7D1UhjUAIfvFV5XH1lqy8cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ukFDH6L1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BD3606A32D;
	Wed, 28 Oct 2026 17:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ukFDH6L1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9739F1F01828;
	Wed, 28 Oct 2026 17:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208676;
	bh=zZbz4cEhkePOvaANj6skz7nd2uxzbQ6GTYV0i1WN60I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ukFDH6L1YDJLRBWBVZctIX6Q3ai/FpeC9y+e3lItiDlwgqU3qG2XaexdCdkW0AQbv
	 begtLdtI1QCZzamC+6NN/pQ3Io24zhSmDjcXH1bOqo+uUUn3ClRtnghT18HPovDcrl
	 yWY+/PqZoxIXilfsAVX4nHFmOitZsuR0iXcHg1x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 5.10 204/516] tty: vcc: hold port lock when clearing tty pointer in vcc_cleanup
Date: Wed, 28 Oct 2026 17:55:56 +0100
Message-ID: <20261028170008.336672362@linuxfoundation.org>
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

From: Joshua Rogers <linux@joshua.hu>

commit 03b49c991abb8d021ca6fe51cd173447236b0552 upstream.

vcc_cleanup() sets port->tty to NULL without holding port->lock, racing
with vcc_event() LDC callbacks that read port->tty under port->lock and
then use tty->port. This can cause a use-after-free when the callback
dereferences tty->port after cleanup has already destroyed and freed it.

Assisted-by: AISLE:Snapshot
Cc: stable <stable@kernel.org>
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260803-aisle-tty-vcc-v2-2-a50bc9b15193@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vcc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/vcc.c
+++ b/drivers/tty/vcc.c
@@ -1047,7 +1047,8 @@ static void vcc_cleanup(struct tty_struc
 
 	port = vcc_get(tty->index, true);
 	if (port) {
-		port->tty = NULL;
+		scoped_guard(spinlock_irqsave, &port->lock)
+			port->tty = NULL;
 
 		if (port->removed) {
 			vcc_table_remove(tty->index);


