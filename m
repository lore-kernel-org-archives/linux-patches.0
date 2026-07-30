Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC2D374192;
	Thu, 30 Jul 2026 15:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425807; cv=none; b=U40jAUm4x1ac6/Tzn8zVkh1zB438t6mNyhu5uXO2dxb/n0QS2M/nzMC/gFfSEn+17jpIBbGt2G+aLS60BMlVKMbLKKpHHBrRbjcFynMsOM+OL73fjNdj7ihkbfuf3GP5Uc4En0X05JqSCeF1M7TbVBTc+XXEWipmHw0i2ANBhi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425807; c=relaxed/simple;
	bh=V0Y5edW/aECL74qqZyJDPBfYRf+ijULoIFxYePcj1Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XN/LJE1rYbMUcdHVFJ8YbiOspEw+iYd3Qp35c0yqtOXXWWnWp7jvmNIqji8yWcXIDehdBa8W5Emq/jibPCFz3tnenhuISnCJKKxHQdRiUBar68v01eyDlXHCDEWH2PT2fCU/lCJwq4KlcKoi0ww2Dzf+mWS0ZpmMYkLRTVxZl9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+gcCAo+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+gcCAo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85B61F000E9;
	Thu, 30 Jul 2026 15:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425806;
	bh=k1F6u/TyVN10sVEVQCWFxAvCSD1k8KletOPcH9P+XsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v+gcCAo+uWrLnNOBcnlXxTfpj/dfkEp+aW1msWe5zUwnTIcvRtgh3gQPYcayGsVJp
	 YDpNBv8uIvOGMRgF5pLCYacf7ZIRubB6MxwOBQdYXWmxhWLBm5iGtXpEhq0zj78aLt
	 fNllJkrqqP3lnYehZJatbi4ELr0aTRiwL9wpvsrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nils Juenemann <nils.juenemann@gmail.com>,
	Rishikesh Jethwani <rjethwani@purestorage.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/602] tls: device: push pending open record on splice EOF
Date: Thu, 30 Jul 2026 16:09:51 +0200
Message-ID: <20260730141440.140173424@linuxfoundation.org>
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

From: Rishikesh Jethwani <rjethwani@purestorage.com>

[ Upstream commit eaa39f9f8ac8c1d032cd26b9cd572804e9d7683f ]

On kTLS device-offload sockets, sendfile() with count > EOF can reach
->splice_eof() with a fully assembled but still-open TLS record left
pending. tls_device_splice_eof() only flushes partially sent records,
so an abrupt close() can drop the final record and the peer receives
a short file.

Fix tls_device_splice_eof() to also push pending open records.
This matches the software path, where splice EOF already flushes
pending open records.

Fixes: d4c1e80b0d1b ("tls/device: Use splice_eof() to flush")
Link: https://lore.kernel.org/netdev/CAMPsyauZ+jzG9AysO0FWv6ZY0kvCUpjX_U7o=oOjCuOQ87BCgg@mail.gmail.com/
Reported-by: Nils Juenemann <nils.juenemann@gmail.com>
Signed-off-by: Rishikesh Jethwani <rjethwani@purestorage.com>
Tested-by: Nils Juenemann <nils.juenemann@gmail.com>
Link: https://patch.msgid.link/20260709224436.1608993-2-rjethwani@purestorage.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_device.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 5c6a4c9a2df755..942edc9b3157af 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -594,13 +594,15 @@ void tls_device_splice_eof(struct socket *sock)
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct iov_iter iter = {};
 
-	if (!tls_is_partially_sent_record(tls_ctx))
+	if (!tls_is_partially_sent_record(tls_ctx) &&
+	    !tls_is_pending_open_record(tls_ctx))
 		return;
 
 	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 
-	if (tls_is_partially_sent_record(tls_ctx)) {
+	if (tls_is_partially_sent_record(tls_ctx) ||
+	    tls_is_pending_open_record(tls_ctx)) {
 		iov_iter_bvec(&iter, ITER_SOURCE, NULL, 0, 0);
 		tls_push_data(sk, &iter, 0, 0, TLS_RECORD_TYPE_DATA);
 	}
-- 
2.53.0



