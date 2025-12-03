Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797C9346A1B;
	Wed,  3 Dec 2025 16:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778305; cv=none; b=a0ks1RvQXdSdaIWExWY2QiEoXhTN9B7rgof/w/Z6Ve9MjgcpmOKwResbr7as0QpU+Z8S1riK9LdwTanULz/HDZqnR/yuY8hna+4q/0TA3Cpwo2qLSVGZU0EQ/NbWE/o58zaeVtWE+0EOJUvCKWOZ5KLYvHl4AgE7tnfBeG77bNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778305; c=relaxed/simple;
	bh=C2PEzuHipy09YcoZzCO3hv2ULL3a2MV+WMtyElF09oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcyC1usCb/R4yy38bXXHux3lNPCap2jH8BJQSOSGHkK82M8hdSMZr+KGyn1r5E+BMoh9Yahl9kQ6VDbNJX+7pKlHKrJL6M2+0/HkZkcDKvuaXs6+k/4kDKcKbrOmJBb8Gky8U3buX7ExxJxcDE07L69ijY6N5wolBds422d9UEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEPLwQ0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEPLwQ0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF5FC4CEF5;
	Wed,  3 Dec 2025 16:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778305;
	bh=C2PEzuHipy09YcoZzCO3hv2ULL3a2MV+WMtyElF09oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEPLwQ0UJuMffv3imRYRWjCa5+iUkf6dhRMrymlGF8zvE86Rk3QcYk/ZCFqY9XOLV
	 5grW0iEYZuvnNBPks/sEFctHCRvnUcyMrrgKuwNF34Yv8dpUyqnFOD0HgfnM82StOe
	 iL0rDm/6wfrQvDZbhZd3sl9SCWO/L1aqmcCSZSWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 304/392] net: tls: Cancel RX async resync request on rcd_delta overflow
Date: Wed,  3 Dec 2025 16:27:34 +0100
Message-ID: <20251203152425.351430879@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit c15d5c62ab313c19121f10e25d4fec852bd1c40c ]

When a netdev issues a RX async resync request for a TLS connection,
the TLS module handles it by logging record headers and attempting to
match them to the tcp_sn provided by the device. If a match is found,
the TLS module approves the tcp_sn for resynchronization.

While waiting for a device response, the TLS module also increments
rcd_delta each time a new TLS record is received, tracking the distance
from the original resync request.

However, if the device response is delayed or fails (e.g due to
unstable connection and device getting out of tracking, hardware
errors, resource exhaustion etc.), the TLS module keeps logging and
incrementing, which can lead to a WARN() when rcd_delta exceeds the
threshold.

To address this, introduce tls_offload_rx_resync_async_request_cancel()
to explicitly cancel resync requests when a device response failure is
detected. Call this helper also as a final safeguard when rcd_delta
crosses its threshold, as reaching this point implies that earlier
cancellation did not occur.

Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1761508983-937977-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tls.h    | 6 ++++++
 net/tls/tls_device.c | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 59ff5c901ab56..db0d1ec04f39c 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -665,6 +665,12 @@ tls_offload_rx_resync_async_request_end(struct sock *sk, __be32 seq)
 		     ((u64)ntohl(seq) << 32) | RESYNC_REQ);
 }
 
+static inline void
+tls_offload_rx_resync_async_request_cancel(struct tls_offload_resync_async *resync_async)
+{
+	atomic64_set(&resync_async->req, 0);
+}
+
 static inline void
 tls_offload_rx_resync_set_type(struct sock *sk, enum tls_offload_sync_type type)
 {
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index e7c361807590d..1338e4e2c0f40 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -694,8 +694,10 @@ tls_device_rx_resync_async(struct tls_offload_resync_async *resync_async,
 		/* shouldn't get to wraparound:
 		 * too long in async stage, something bad happened
 		 */
-		if (WARN_ON_ONCE(resync_async->rcd_delta == USHRT_MAX))
+		if (WARN_ON_ONCE(resync_async->rcd_delta == USHRT_MAX)) {
+			tls_offload_rx_resync_async_request_cancel(resync_async);
 			return false;
+		}
 
 		/* asynchronous stage: log all headers seq such that
 		 * req_seq <= seq <= end_seq, and wait for real resync request
-- 
2.51.0



