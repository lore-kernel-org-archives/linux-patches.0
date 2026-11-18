Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048848;
	b=ZzsK+cNdwWdvGeyxhTQSZQcRzN/mn0AB6umDVRIzwbYTWXpMWhgO+Qq4VrmOOWQHNbDQ
	 pXmo/q7T8p6KsAMaqWzsoqwoqqjw93ohPa9TOgl82Ws0Xj2ZqGlVRb+tNwmFyAiuTHlgm
	 HXnQSqkoHJxQOCsj6w1vf9hVosTe8GnPg6wLm6OVdwcdPr4kTvIrMEhnNnJxkuTsSTAuU
	 eLGz9H7DBL4wlcmEL0wNYuAeh0iJzF7zK63jdeAkhj8VE3pT9oXZxSWcyoQdoz5z/T0Nb
	 p+mJBbSNQzg2lUc1X9K3Ye4WSGl+XIWqFBzkj/qJfb6cjG+i7dVEmhyC+v+d2YmeYuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qn/uE2Hh10hvqhUjUUb6X+SZlewg2g18eb45D8o4lDI=;
	b=MjTotCNLH4DcmOi90SrdLGbgoA0zewyPJe0z5x4LKZzAdqFsQrqb1q8jfF/n/Q0AjuB4
	 OsQi6RaDAO0bp72dFy25sXmpsrAsrPmLs9LsTNVHR+05jOTBwoycIKHud8q4363lwnwhS
	 9DoqcelsIzDwoi/IflEnqdzWfFCfJh3SOlFWcwbOUiwY9Q+YHuarwVU/lnT+XFAqnn2/a
	 7Sq54cj1kNIuHsIL26KAjRvrbuLfCljoZ16xNiucfx504NX4oowGEhDR2iCsEqT4iMuNk
	 GuZZA7fXIvrHqx4WsPxPtnfulNh7lTuxgPmbEN4ZrwSC3XGkdHSnFYOh6YPp3znEoBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=suvwtTcw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83B6606A330;
	Thu, 19 Nov 2026 00:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=suvwtTcw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2461F000C4;
	Thu, 19 Nov 2026 00:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048848;
	bh=qn/uE2Hh10hvqhUjUUb6X+SZlewg2g18eb45D8o4lDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=suvwtTcwsijXv6mivKNCmTDSXCfp8/uEGhd83pP6iC1ozTp6fbESIyW3x7dPNpJuO
	 QPUcI78gK42dzRYcCdFJzV/lDS10qcTIgcMm0Ff5XNqglq+6L3rcJlUMZ6i5bZLGQd
	 yks8RmVS6cuNwx8kgVuzkaR6vA5J2yuSYtxAsnu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2141/2857] RDMA/hfi1: shut down the trap timer before unregistering
Date: Wed, 18 Nov 2026 15:52:55 +0100
Message-ID: <20261118150318.490377057@linuxfoundation.org>
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
index 39ca32d9ae6a5..1591a02b0a832 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1904,6 +1904,10 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
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



