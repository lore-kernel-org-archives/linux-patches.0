Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050149;
	b=Zr+qNfR7MpzQ7OAyYNXfNxDfc9nlx+zBH0NZG4r3XQ9+AXdcikuddUQ5MJyjWCHwGK+9
	 CsZPnWwVtJ1gtyTF5lK01u3mM3cNYVJqEFA4SZRUWXqBClVkBdP3YFjzkwKc/obsHYmsD
	 FmE155egGgL7EBc5CJhl2HRuSE8floUPNYO7KwKzkArRTFE77fhnDlq+hpUiGLvIju1CN
	 xL4HIt2eK4DHFWdJYsemzZelO7ZwEipSghEUr11tdbL/2rxGAAHRRsYQ9+C/xQxRmyOnx
	 cWHC8NM2LRRKbILfgsO7mv5NXvG6roo71miEA7ANSB5jqhZp3BUuDC/TQIqazrv7pNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jsbSmqYOpRyMx6UJcpPyxdDxeGFGjraahPUaVZcjsxE=;
	b=1XlQwDzy1gTU4I7DWkdqFHutWrhwWoL4r8s/l9wntBfcaeXftyOwQ1vkN2fxvx/Np33P
	 gEBRzI8ZN3TZZCXCbqcGvHBJgmk1hRav4dQu9RZTOii5YBDibDw/Zcp2kPqXCSLjmFjl6
	 Ql1z4CTzWsalXTCGL77o+lQaf6SFuWamGndc7lvfGGBe5DchYxxkUylHA6pJPD2YGDHzQ
	 p23YtQJLYNdzytC7HVgIXnXJ0Cfhe/W8YXRXPlyfqVrATZpClwwpnkXiGCO7bJW007UC9
	 szhF1ddDF2hOY05z91HRwzUS/xUo3Aa5OzWDnXFr8uno+oNkYsPdw4SFFphEcUnJlzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KdDM5d8r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75205606A325;
	Thu, 19 Nov 2026 01:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KdDM5d8r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCF41F000C7;
	Thu, 19 Nov 2026 01:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050149;
	bh=jsbSmqYOpRyMx6UJcpPyxdDxeGFGjraahPUaVZcjsxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KdDM5d8rZQrkGT+qxF84VXv83Trny/g5jo2FXVmSVGyrO+X977SwR/5d5gB7QjhAI
	 kUCSSY3/fAshxLA7cweNf7MTBhM1v53URCOt+NAwCcwVoealrF6vVMtsNUzXYYYr3i
	 Qm7+vegfcO+vK6ed2WsqJ7MXLTfnvDXswfVJWGd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2605/2857] RDMA/core: Free unpublished port statistics after initial-read failure
Date: Wed, 18 Nov 2026 16:00:39 +0100
Message-ID: <20261118150335.355328346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a9c33a6220ea8..c66a7e56a5278 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -1047,8 +1047,8 @@ static int setup_hw_port_stats(struct ib_port *port,
 					    data->stats->num_counters);
 	if (ret != data->stats->num_counters) {
 		if (WARN_ON(ret >= 0))
-			return -EINVAL;
-		return ret;
+			ret = -EINVAL;
+		goto err_free_data;
 	}
 
 	data->stats->timestamp = jiffies;
@@ -1082,6 +1082,11 @@ static int setup_hw_port_stats(struct ib_port *port,
 
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



