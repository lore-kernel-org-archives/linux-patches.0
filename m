Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040475;
	b=VXYDAxLT0urBCcAIEF43oLTtQUe+XN0o/BdJnA1tzUk7yU88q2Vl6Fr/u81Vz47tMW7C
	 OdIZM2rt0j8QbLkj7v+3wKzqheYljqMoljKcfUXRPx0DgQtW9rSRpehWrZ6ORnIYt1q5g
	 hgAg6VHD69RhF35YK1ljzWE55oiG+UgeCn4M9HeB9i5KNrrbV57TkFsZj30wpsWDBq9vu
	 M9Tn8YxRL5JG9N2l8jNUNOuvR/3nFYWC7HKsKPdAf/H3sTFjlB/c6zmupJ9nb1MyNgpeq
	 RZeHb84uCYqCmfePhe+NSzuy2L7f0Xbugx9kyTCoPDbci9IgsPa4BcJ3uadN8srq1Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OoU1jlp8G5lLuyw8PfZR5DEoQ2IsPGrD46DIou8CGVU=;
	b=XhKay5pSuFwFGey7BjTClRkjMd2jHIYs13vkzXFfaYUk9vculvH3UKVtsY1jNkTvZxp2
	 28zSH/JQ8gWn3JNxVQutwi8i66wytGtqPCZSta+uNbkMmYN4iDD5N/jmxgK2B8feYteqT
	 EQGHeVeUEORYaUvhQYcWB166vy+am+yfA3EAFB2/RRbDxaRfFa1UrVQX0VCClTw6ewgHd
	 8sNQFF9xHdIhzZNuq55h/+b0h3i5UCd46Jb7r7e7iyWF61pRACatlbOjR5iIN8ZxUMoul
	 ar8Q/k3E7IRNWgr4qVdqlY9UlkSF83I7VGO733MCagvDEjDt4fQobn1N9/XaxbKaQsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wKS8RjE2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011DF606A31C;
	Wed, 18 Nov 2026 22:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wKS8RjE2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B121F000C4;
	Wed, 18 Nov 2026 22:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040474;
	bh=OoU1jlp8G5lLuyw8PfZR5DEoQ2IsPGrD46DIou8CGVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wKS8RjE2jva1S7138y4e0D1T7oygPyiTWOl8aoM0IoUq1MVXI61kjpKxlkdtnWob9
	 Wh/UdraliIFwwqRm0QgzQyGH/B3nLV2mUj+m/P7WUELJpJrRtIZI3t2yy7oX3xleCs
	 FowrrXaQTqTIEml5Lni4++7R2UfUBq1V4JbdU8YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2470/3318] RDMA/hfi1: shut down the trap timer before unregistering
Date: Wed, 18 Nov 2026 15:51:32 +0100
Message-ID: <20261118150435.512263235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit a1c9d476c2316685f85fffb6450ad88d01836357 ]

MAD processing arms a trap timer embedded in each hfi1_ibport. Device
unregistration does not stop the timer, so its callback can run after
the port and its containing hfi1_devdata have been released.

Shut down every port timer before unregistering the IB device. The
shutdown form also prevents a concurrent path from rearming the timer.

Fixes: bf90aadd630c ("IB/hfi1: Send MAD traps until repressed")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260928134151.1213-1-getshell@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/verbs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index fbdcfecb1768c..641a9eca61550 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1890,6 +1890,10 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
 {
 	struct hfi1_ibdev *dev = &dd->verbs_dev;
+	int i;
+
+	for (i = 0; i < dd->num_pports; i++)
+		timer_shutdown_sync(&dd->pport[i].ibport_data.rvp.trap_timer);
 
 	hfi1_verbs_unregister_sysfs(dd);
 
-- 
2.53.0



