Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEDA327BEC;
	Wed, 30 Sep 2026 18:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794468; cv=none; b=HUcikc2XgZIORRVEx8LT7SncHng00zAdouBnzfe5n/lXoR2rLTFYBLjvM2erIbrBUYNSXXBODc5qLcfrMGEH56uFo6dwjInSLz1pNjJe2WIQtn09OAdsFgGNWfCY9/Ulcb0bbkg8ZKb7ukA3ux1phv2pyPlK8hNaR6//hevdp+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794468; c=relaxed/simple;
	bh=fhPKWt62FdYRtblGgzKVnPXOtHzfucqe/gjHK/wYLcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMy7HOweUqIbt7Ya2zomMPu0b8zIar09cd5y2p2NAk486A+f+E3cLinl9gQGYrV2CZqHkwdwudKdnij5RkEt+wO9/rFxneTroil5sLBHKJFxx/3895xL7wkZAF+xLAaDSbv5Q5g6kCVtdAojtscwJj1Dtx4L9tZD5EpQd+X3X8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVA52/QC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVA52/QC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD401F000FF;
	Wed, 30 Sep 2026 18:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794466;
	bh=i8gbbpjtNjWCPqd7Qg28QGz4T3HKHh96b4OdCf4uC80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVA52/QCzboeAMhjU7K0H3ZpHwCT3sFlgfvvhvHT+Cku7N7YGPjbdfvMeuuowQSvP
	 xS2zV8lOZfAJYXbTznIBPXenBUVvljcwsyg86woGwFzC0MJ+QvkYZOM8S7KjFIKEez
	 pD+aFEpFRVXfzfSvORbFUHK3/fpAiccGhul2AfTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0220/1193] ptp: ocp: add shutdown callback
Date: Wed, 30 Sep 2026 17:15:04 +0200
Message-ID: <20260930152439.085952169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[ Upstream commit f6f955cbf9d4e02deebe54ca91c118b53be9ffe6 ]

The shutdown callback was never implemented for this driver, but it's
needed because .remove() callback is never called during kexec/reboot
process. That leaves HW with some interrupts enabled and may cause
spurious interrupt while booting into a new kernel during with kexec.
If it happens that I2C interrupt fires during kexec, the whole I2C bus
is disabled leaving TimeCard with no devlink communication. The same
happens if timestampers were enabled, leaving the card without
timestamper interrupts until full reboot cycle.

Implement .shutdown() callback with the same function as remove
callback.

Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260611190333.787132-1-vadim.fedorenko@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 2d21699586ce7..aa233a3010123 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -4264,6 +4264,7 @@ static struct pci_driver ptp_ocp_driver = {
 	.id_table	= ptp_ocp_pcidev_id,
 	.probe		= ptp_ocp_probe,
 	.remove		= ptp_ocp_remove,
+	.shutdown	= ptp_ocp_remove,
 };
 
 static int
-- 
2.53.0



