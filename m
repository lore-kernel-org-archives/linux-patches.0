Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054102;
	b=Iiceenk1MgrltZj5NV3d7eh+C7gPF6nI+bjyPlDCsVgBI3imi1yErOlqEWvfMrpIZKfM
	 V8YXhQTCKv/zP68NjyqsHLoZ4+vjuvJMVYToOQsD3olnBq8SJiZZnfXMnvyEp7MuSmZS1
	 h3808Rxsc3VRmItdU4AdlTI7JOegVjVd/nLrcNwZStIgn5/7g2HWcd2ZANFz8ewFYIGOK
	 HzMGpsFksx92iqA5v/L5CYCEdfuDkkJpj1XJOaubfHoYeXCo5Bqq60z0N2nF6ho3QcQn7
	 sXwnV/Sb3IH/QAL5YJuBzR1bjb7WTdnkkMp1P4IVGynfd8zriLkRmx53f4qxqPQeYeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xE8Z0zijwMRZqx1rFcoSebbG3lOje1Ts6bPjxMAw7Hs=;
	b=HGbE01XyERmOR4JdCZmjuE/4ooKt2UeLkvFNd65X2uH+a+OdaZPYb72W+0qclWRPtqtC
	 65E3YSXqnXhpbkLGvQYZRuej+HCj1VIbN2UnQ8xXkZcpGzj/7LpQz1N9sZexPuYzgwvZH
	 BLWnfqm8FOpYoFPnqeiRCsUy4PlBHsCSze2ybW++/k6pMLCL9dtXrLvz2RPEbc7hyCZqg
	 VTZmBJH1fym5Lq8nxadbbvuUwE16egeZ2IleAnuNuiiGiNDs4CXJnZltRYRRQ32D7JGN+
	 A6DytTGITPnGz78eDBoOP3Q6GsQAMVJTF6k3U4R8h8EysIYkpCTnlABOU2oZI1Yuxag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+71Q24p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C546606A325;
	Thu, 19 Nov 2026 02:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+71Q24p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15C31F000C4;
	Thu, 19 Nov 2026 02:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054102;
	bh=xE8Z0zijwMRZqx1rFcoSebbG3lOje1Ts6bPjxMAw7Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+71Q24paK5wEMsf1z7HqxfKc93lpzLCS4588MtuZ1LI7k6KT2G40zq45+rACFqG5
	 kvudQrLQBxvrNJg2mckH4FzdTCYJ8XYTQdQoGcXY9HOclT2Rj0BVsyMg+y/UNJrU48
	 LNGD9f8nhw70rHa4zgQpBLAiks2cKw7RVSaN5Z7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1153/2214] media: serial_ir: Fix race condition where timer can be re-armed
Date: Wed, 18 Nov 2026 15:47:09 +0100
Message-ID: <20261118150058.108513746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit d74ac4016ba64cb3b20f395511d0b18025ca0ba9 ]

Ensure the timer cannot be re-armed.

Fixes: 2940c7e49775 ("[media] serial_ir: generate timeout")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: adjusted context to replace del_timer_sync() instead of timer_delete_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/serial_ir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 96ae0294ac102..dac341c68b2bb 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -797,7 +797,7 @@ static int __init serial_ir_init_module(void)
 
 static void __exit serial_ir_exit_module(void)
 {
-	del_timer_sync(&serial_ir.timeout_timer);
+	timer_shutdown_sync(&serial_ir.timeout_timer);
 	serial_ir_exit();
 }
 
-- 
2.53.0



