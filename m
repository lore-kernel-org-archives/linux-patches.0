Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ACD35C1B7;
	Wed,  3 Dec 2025 16:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780139; cv=none; b=lSQCTpZkV6MqlPOP1ayvWR1AllB7np4RY8oTXmMTEkv/CGONjKAVwYKei9M1DiDZ2eqTEuWI0iEwq5r06EZ7cL6pOEOsCdYQ97rn+f4LOOsFDCMM+m9EOBOBY3kYzj+0yiox1JdxGmc5Uj9Ym+akGfjXtunkqeE4FScPFTNfPuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780139; c=relaxed/simple;
	bh=4AJNGZMS5AKQaevPdZT/sgR+kMK8Y8YtaWUrTXbbvpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkffyU8MKLDu+XTAO2sy7xWXvGB3zkbitGJqVw9456kYvke5Bes1oZ9G5b3In9LksJorIUseIfmqwJh63a/4U5GDpGgiQndT8lVJ/6fvIcnBe3hPiyyvE3QmRSZZrALz4iVEVIIDR/HL8bE6LVGsKQtQf6Dz2Vj06mHhcN2zdj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMe2RKYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMe2RKYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD786C4CEF5;
	Wed,  3 Dec 2025 16:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780139;
	bh=4AJNGZMS5AKQaevPdZT/sgR+kMK8Y8YtaWUrTXbbvpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMe2RKYNNqOtQw/lfczy1D/TplUWceEi0HYpu3Bq/LQL5tvC0uKAv2hmPWSt4GH2L
	 JfrAOhJsFq4kxTl4EH+vL1KKsdcRTa4IfsDrnmA7s3588eMa7OmHoX9gllVX8PtzdB
	 fObonFJesqG2tdxgWKuDOQUs4avPHyDFBRWALWmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 468/568] net: tls: Cancel RX async resync request on rcd_delta overflow
Date: Wed,  3 Dec 2025 16:27:50 +0100
Message-ID: <20251203152457.842821485@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 899c863aba02c..037049def8a7f 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -475,6 +475,12 @@ tls_offload_rx_resync_async_request_end(struct sock *sk, __be32 seq)
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
index 1849827884735..c51377a159bec 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -739,8 +739,10 @@ tls_device_rx_resync_async(struct tls_offload_resync_async *resync_async,
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



