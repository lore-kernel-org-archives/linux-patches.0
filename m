Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4704B515995;
	Wed, 30 Sep 2026 16:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784540; cv=none; b=C9qcA4GkJe4rw/Nk1jm9iOLUWMlT4nQs6Jmw4ZDUp1FYOXWn3H2ZqTxKMftdaGOZmNnmZEeEuCRpeib71z+gGa3tzgNilCwSpQi27oiAxiEQlHvaVM+WBvcjKg6vdGucx4sJvp2TszFuf+1M2o4Vr7LsR2t4r6OoV3V9dsM3ihw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784540; c=relaxed/simple;
	bh=0iAKjbdw+PYYlHvPuJqnd7X8cjeK6PT771ktkKEtYHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOvlHZNmz+tj9eDLO7GV1Pq4KEWOyDfs6VUwi+EGPIb9TYqdRHHpoHiBXHLRX8UsdCmP32NSclJi+Q3as0C0Bo1hZPOlAskwOiRhUojypp0Oo1+N0fqRlidDq5YkQG7f6DwauMSWl2hE/JLwpF47BQ4lz+q1zeuHVkpCE15eIT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1t0K0Of; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1t0K0Of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650DF1F0089B;
	Wed, 30 Sep 2026 16:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784535;
	bh=h9Lrv7QB2ygiH7S8IGoNt4G3WHc5AOSjnk0a/lYqspE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y1t0K0Ofj0WGMSLM3UPxfrrBC0g1LSUFGC+afRJotqpYaRjF54oCD2lNZlkeUcNAK
	 8o0xhMqtezNmMPxH50Cslo9jhRn+QC61SNrYU9zHhblCi64RkEj4qWAiXB/zisR6m0
	 lVlPyrx3UkmfABeaUO8iAZjxB/TytyOYe+Zgx1x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/982] ptp: ocp: add shutdown callback
Date: Wed, 30 Sep 2026 17:15:26 +0200
Message-ID: <20260930152420.897898717@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index c4793bb13e3cb..f2332b954bcf0 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -3794,6 +3794,7 @@ static struct pci_driver ptp_ocp_driver = {
 	.id_table	= ptp_ocp_pcidev_id,
 	.probe		= ptp_ocp_probe,
 	.remove		= ptp_ocp_remove,
+	.shutdown	= ptp_ocp_remove,
 };
 
 static int
-- 
2.53.0



