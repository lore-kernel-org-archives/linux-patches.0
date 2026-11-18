Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032378;
	b=VagqiGq9sUH6QkwZ3Ip4bULuSZh16G/1KT6ylwu/k0ZR4BPSkcKgeZeUdBY9jlnUjtJ8
	 7295lC9TwX/F/qeKZICkDq72GM1euyDab7EPl8/8hVxdD+IuErO8+l2AThEXN692rzKXb
	 iVnRxVeiBKL3yaCVxRTuCTQFZkPvBmE++dx3qlSJVIri4fvrKqUDHmzFLUoUzZdtEAYai
	 6icAv9xnKTQQRovu/5/S5tKXHMh24zRE+UtTU20HUWgSGDdKMfG0WMvVqIVLJZXqXhdyY
	 ee3119CTg9a8JGTwclpoMrgMDVdpd7ZHljw1funsXG7+Pwb1NY7MjIo+SHelBjofamA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hy6NdBuf924mZwbPpw+tjJSN7fSxnHaFmdHyE4jCSxk=;
	b=rPD9YZcy1isWcuk/zfzaQIUilyd3ZgFejuHKswl2Qfx9x8GgxZlKU2EaKqL4h6xQLRTc
	 stezM04ifbsvop9h9elMLwc7+NxEElZtnoFqEdoDFfewi5u5GuNs9WSiRUhKkXSKHqYjt
	 MCgkXeSqXgjzc5vwox2rM6Vqhbf7LEYnRf9l6gZyd/o63ymTCoqxj25zWAEmtXyRvxv7h
	 9lf+S2jijJPvNXzdNo35OIQyL5QGsof52nHHVCJTlGu9ZljgLU4B3YIhQVA2wpM7xh+nm
	 QTdymjBl3BUTzhSvqqE9q8fazhuyR/1liW3Esp+XljV5FSIVFBXgL+MqJjdPxa9NEgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+RBdjc7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3BA606A320;
	Wed, 18 Nov 2026 20:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+RBdjc7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D603B1F000C4;
	Wed, 18 Nov 2026 20:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032378;
	bh=hy6NdBuf924mZwbPpw+tjJSN7fSxnHaFmdHyE4jCSxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+RBdjc74+92F0au96ptke43G80HmzDxbGSb8KCESFbak07En4Gb/fRoFnSVdNaI3
	 6I1wiTZvRoVEbB2FVcgBySMRCBtQDnXIo0duh/J+OFYeTXKWYsu4+NCxO36kXdRv8D
	 UNfQ3P5/zvQn1zbGjsJjBR1cOyAO4gGQYyZ1dtVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1391/1756] RDMA/core: Free unpublished port statistics after initial-read failure
Date: Wed, 18 Nov 2026 15:58:38 +0100
Message-ID: <20261118150104.527801653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit d74bdcfa89fa45d3a506cddc37b3bf1b76cea0ce ]

An initial port counter read can fail after allocating its statistics
buffer and wrapper. Free these both allocations.

Fixes: 467f432a521a ("RDMA/core: Split port and device counter sysfs attributes")
Link: https://patch.msgid.link/20261015-ib-core-fixes-v1-2-60f6da3ddec3@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/sysfs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 210092b9bf17d..254511d88ea99 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -1051,8 +1051,8 @@ static int setup_hw_port_stats(struct ib_port *port,
 					    data->stats->num_counters);
 	if (ret != data->stats->num_counters) {
 		if (WARN_ON(ret >= 0))
-			return -EINVAL;
-		return ret;
+			ret = -EINVAL;
+		goto err_free_data;
 	}
 
 	data->stats->timestamp = jiffies;
@@ -1086,6 +1086,11 @@ static int setup_hw_port_stats(struct ib_port *port,
 
 	port->hw_stats_data = data;
 	return 0;
+
+err_free_data:
+	rdma_free_hw_stats_struct(data->stats);
+	kfree(data);
+	return ret;
 }
 
 struct rdma_hw_stats *ib_get_hw_stats_port(struct ib_device *ibdev,
-- 
2.53.0



