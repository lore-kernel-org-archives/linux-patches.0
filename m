Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711F028D8E8;
	Thu, 27 Nov 2025 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255394; cv=none; b=phu8TyUa6Evw+5fSMBxQ6Qv8d78syivRZlN6nDNol+tUsi9Wd8AjxdWj4aBlbu8EYWpioqL13fZEkCuRIlcPlqGEVj6A9eIcqnW4idUUbsULr8Ei1j4nSCKKKcSvqD87bEeaL591NbbCpxD/fy6tqMOVZfjJilk+MD8ZtoQ6ejk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255394; c=relaxed/simple;
	bh=np5yfpPxC4O+NirhD+CzbL7j7kkHKFI/+gZqNwznFbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilbPR6GWRsn/ZrEXucIwdLwr8Xk13MCYgw126YX/pY4/JjZ+NItZGsZ8+BgXjT5nwMP9Y4J1fh5ZfwCEmL3qMn+ecyxtBQsjhRKChhShEN5FgpVaCRyZnDEkIv4jtnL+KuDSUj7FhjMma6Af53cCImc6n5K3ol8/WO+O26lMN0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3jFkesu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3jFkesu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5F2C4CEF8;
	Thu, 27 Nov 2025 14:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255394;
	bh=np5yfpPxC4O+NirhD+CzbL7j7kkHKFI/+gZqNwznFbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3jFkesuxWB4zGmnY/6KjP69mUXL4lQKBK7DBxSAjVBnGpkAY0GVfBhWLKLWCJo/7
	 gNv7oqEJ7HAlT1vmH5LeBb4D8+RYiUIAds9AXO+cnwuNpaDm9pbmN+WW2fH0OyIR6T
	 S7v6uzhTCGw3yYNJtfUf+zJwyH3XG/qFbr/tj0Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/112] net: tls: Cancel RX async resync request on rcd_delta overflow
Date: Thu, 27 Nov 2025 15:46:32 +0100
Message-ID: <20251127144036.137179372@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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
index 181173e62a068..3f4235cc0207c 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -464,6 +464,12 @@ tls_offload_rx_resync_async_request_end(struct tls_offload_resync_async *resync_
 	atomic64_set(&resync_async->req, ((u64)ntohl(seq) << 32) | RESYNC_REQ);
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
index dc063c2c7950e..0af7b3c529678 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -721,8 +721,10 @@ tls_device_rx_resync_async(struct tls_offload_resync_async *resync_async,
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



