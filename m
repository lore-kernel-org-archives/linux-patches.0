Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4804FC339;
	Thu, 17 Sep 2026 18:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668067; cv=none; b=rR7VzNC4GSPrl+kYk55LcM7zeEQyuG+G+aFUgWLM708NcNuASlqbGTSMgeWg9q4yCpivfKLEmbfvyies/ZgjDXbigPtlJT9/3LKQn3VLANtNtqUSQZuj1Ap+QgbLGCw4NKsOqsxIopDUHoCnrz2pzRsV3ue3zx/DqNlCKRDp5Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668067; c=relaxed/simple;
	bh=EoGlteGslfWLIsjrNy7H3cQPrUbwj5ahOZTEJLyrSgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvTI8Fcmvzt7zD/38otmKYYraDGG5jqXahdUh+Rir7SjAK+WOSKP3lngPrPrt0ZVPAiT9bLlOBxnP7nl6g7umtTBzoaEnm58N4gzk+It0h4D4+FkbXVVhQMPiL5Wxj/Xhw/Ly0EAAngR9i2WTjWlA/SefQSPJ3rj9LVcS+1lWA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tnbg4+m8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tnbg4+m8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7328B1F000FF;
	Thu, 17 Sep 2026 18:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668066;
	bh=udfGCs9GThtI+yNngeahBbTwTfjFvFpqYz/7OYznFsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tnbg4+m8d3OQ84yXZ8eTxj6XRbWHNE7TyyP+0ysQ10xb2ConYWYeAWvePsDZ2ew/W
	 PqN2xQo8/dTxulnRyuD0PK+9GpxWKmGEH+EGFYH4zhr/IPw3ihb8b4RzNVmVz4QqwR
	 368wQ0ymji00LPlMQV4UqXjnNTH2xWsNtKIxuIyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0302/1102] ptp: ocp: add shutdown callback
Date: Thu, 17 Sep 2026 16:04:05 +0100
Message-ID: <20260917151547.201215277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index fce46b88458fa..27d2f009a51b9 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -4870,6 +4870,7 @@ static struct pci_driver ptp_ocp_driver = {
 	.id_table	= ptp_ocp_pcidev_id,
 	.probe		= ptp_ocp_probe,
 	.remove		= ptp_ocp_remove,
+	.shutdown	= ptp_ocp_remove,
 };
 
 static int
-- 
2.53.0



