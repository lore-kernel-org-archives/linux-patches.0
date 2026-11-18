Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027333;
	b=UJOyqxu3eH0Au8/ql2StEIX82PgRIHwC8w5+AqOJRKYjzNkrv74IK8ASqLj3efSvgGbo
	 gnCqKh3OWhedQHpEqTaMBKn4tTpQ4aegrDaedoT9H+QtaYwipv2YJqnLYi+juWkkpTcNk
	 fT6V4H70uj93k+NPljO+H4UqILrcyrqPxiGoD1IG95By2pkjh8r1oxDD4+CdxHNJ96s0V
	 m6SHUKTM+vQ0CFWxYwJrJI97vr+mYK36vFg3jb2+dR1mcJYW4vJsElkZKobtBPGn92KKX
	 DE5zvr06P4S19C4mzX0YNMYDn/nYwqz2j7keSr+ESp6FbruJ6y1z+0sFkA21qolzT+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jL1kD3jN5ygzJKn7r4frvieVZzv/42AUT4t5LyGPSao=;
	b=kWJMhYDqE6aqwylwY1B1t3ysJ7QtnQWFIjxeFH7A2rrJdmzVeeaLBbkXDixZWS1mMa2Z
	 /38wrnsEuSnEQ7BdJPIToyKJPYOESOC/8um7QKiOy306aWUZjO29cX4qyAsJG2lJ8Fgq0
	 ohWeaSRKkBAVZigsy0v9MIaMvlV75aDkyhlVGipsPR64ppJDwlxWRQiUK10WPvschHGxJ
	 9BRSydgz4gQ140hAF4OAp18iQe7Sw8FIzx01hptkd7kown6TXv6cEe2Mma0n+e9oN+Ppy
	 3biWAgJlROUfJAHxopcxUUVBwRhzS8PDt1qyxem5XtfmqHlELBkIrdph/NoODxOzSMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cKYURWRZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10032606A331;
	Wed, 18 Nov 2026 18:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cKYURWRZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606411F000C4;
	Wed, 18 Nov 2026 18:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027332;
	bh=jL1kD3jN5ygzJKn7r4frvieVZzv/42AUT4t5LyGPSao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cKYURWRZOBY7OkJlt0bWthDGTW2pTgpt9oqbMPKDQB7RmB3GeQzJu26q+MBhK5Jjq
	 7vk/hHaiS94sn2B4hIX2F7G62wTyrjxvQEVwMhte7Cm/GDI3zTQ0BkQZU4rkZF85Cg
	 b/W82raUdztZj6JU+TfPSNOTBjVZpR6LAJV0lUl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1752/2151] RDMA/core: Free unpublished port statistics after initial-read failure
Date: Wed, 18 Nov 2026 15:58:07 +0100
Message-ID: <20261118150225.674391485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 0ed862b38b443..a08758db0ba09 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -1039,8 +1039,8 @@ static int setup_hw_port_stats(struct ib_port *port,
 					    data->stats->num_counters);
 	if (ret != data->stats->num_counters) {
 		if (WARN_ON(ret >= 0))
-			return -EINVAL;
-		return ret;
+			ret = -EINVAL;
+		goto err_free_data;
 	}
 
 	data->stats->timestamp = jiffies;
@@ -1074,6 +1074,11 @@ static int setup_hw_port_stats(struct ib_port *port,
 
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



