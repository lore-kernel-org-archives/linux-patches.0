Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09773A5E84;
	Thu, 17 Sep 2026 17:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664544; cv=none; b=FpSlRCkh5HpkfpTmkKNNRjHc6O0+2p6ktdaWnVB+HT+OnBVqEuGAU0l/lqfIYYcZbalKmyACf36tGVGp/6rLDdO/e8DYM5fxyG8dC3CvhUbs4UAX6TaBhdld19H9hXKIbum+qZ/tFP/oB4IUoWJ7rTX2BTESnnntRqhg0J+YeVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664544; c=relaxed/simple;
	bh=wUNEGjnu2blU2W2KENf6W90F2lTfTFKLS4AOSZqER88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHyXMVMEt/lN+9aqw3RS+Qr0hjCy51N355iwtnm8In44wPOABw1QFQpW2RuM+FroOssYofOb0REpIrpUC0OTH7I+nSK0KEFX9EhlaSo1GBxfSHPTcjVAklGRIcGJnqAmOs5pQLrAbEYFtFiZm6HAjVT8egqlVrs48aNrzLOepZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hx8FUEsN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hx8FUEsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E70A1F000FF;
	Thu, 17 Sep 2026 17:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664543;
	bh=KedRpR0Axt438o5LDleAAL7D8J03bDRNX6aCRPsCKy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hx8FUEsNpQpeZPdRi8J40U0lgysCHCk5QyS/+7r4uE86Cz4/22jdIcSPQ0HElwg4O
	 +1D+blbnT01MSHiLIRNoGnh9+nmdOvv8bXXP01zvFwla8Go1FicMhbG5rCyWPXuoDY
	 dEpGLXjVoNb0LCrNF/zKdD/mXaS8u6KICDBXwAQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0407/1250] ptp: ocp: add shutdown callback
Date: Thu, 17 Sep 2026 16:03:22 +0100
Message-ID: <20260917151603.057231452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7d89c997d1060..249bb3877f673 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -4868,6 +4868,7 @@ static struct pci_driver ptp_ocp_driver = {
 	.id_table	= ptp_ocp_pcidev_id,
 	.probe		= ptp_ocp_probe,
 	.remove		= ptp_ocp_remove,
+	.shutdown	= ptp_ocp_remove,
 };
 
 static int
-- 
2.53.0



