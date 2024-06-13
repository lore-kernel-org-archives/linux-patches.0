Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD276AFAE;
	Thu, 13 Jun 2024 11:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278958; cv=none; b=RMSBEJlgcdHbXnVi/AvAl3qWeoK024O3FccEOz2C8OdaMQE86nllvUQP+k/E7mpxoQFRZpCIV3+jZeyYFXwVVPXH6YUyycLrOd+W6obxYA42OoVTuU4XHu6d9k85qjZwA6stmXzbzs8KW2cdDUEqFdU4FmzPgpk+85d7Gh9Q+Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278958; c=relaxed/simple;
	bh=SbCuhSMWMdF/Ell35oR3yE+8nihUfDp6U9gR43H+hc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toanR4jiS0RYwoM4Uj8oNKo7f9NsHZQdyamupMazrq7vPXpFHv+d0aVNf7mE+hwY9an+EX9hcyOTCqZxIxEnzIu4alyNdpL6Z624lq8VQD/E4sQjCxV9/gU/qhmxu2HaKcb9FnhW4zNthWghhX3marL7Twkk8LWxi9OFnKZeWdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRMd2x2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRMd2x2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207CAC2BBFC;
	Thu, 13 Jun 2024 11:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278958;
	bh=SbCuhSMWMdF/Ell35oR3yE+8nihUfDp6U9gR43H+hc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRMd2x2vQ8lDUEW1BmndS224BJm4kM6HFZNIF2iyCqWYnIbeh05YDYZ+V8IEUgZzL
	 uPsmBl9k/yaDH8S06lq0AnMR+oDKTbSZh61+OIg7jWV03sDHEcBtfTKqvAtO1zu9U+
	 UI97ZHw6TIT4pVFADTEzraaIhSAxKcOl/DW1n9Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 128/213] net: fec: avoid lock evasion when reading pps_enable
Date: Thu, 13 Jun 2024 13:32:56 +0200
Message-ID: <20240613113232.935749175@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 3b1c92f8e5371700fada307cc8fd2c51fa7bc8c1 ]

The assignment of pps_enable is protected by tmreg_lock, but the read
operation of pps_enable is not. So the Coverity tool reports a lock
evasion warning which may cause data race to occur when running in a
multithread environment. Although this issue is almost impossible to
occur, we'd better fix it, at least it seems more logically reasonable,
and it also prevents Coverity from continuing to issue warnings.

Fixes: 278d24047891 ("net: fec: ptp: Enable PPS output based on ptp clock")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://lore.kernel.org/r/20240521023800.17102-1-wei.fang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index eb11a8e7fcb7f..abf0b6cddf204 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -108,14 +108,13 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
 		return -EINVAL;
 	}
 
-	if (fep->pps_enable == enable)
-		return 0;
-
-	fep->pps_channel = DEFAULT_PPS_CHANNEL;
-	fep->reload_period = PPS_OUPUT_RELOAD_PERIOD;
-
 	spin_lock_irqsave(&fep->tmreg_lock, flags);
 
+	if (fep->pps_enable == enable) {
+		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+		return 0;
+	}
+
 	if (enable) {
 		/* clear capture or output compare interrupt status if have.
 		 */
@@ -446,6 +445,9 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
 	int ret = 0;
 
 	if (rq->type == PTP_CLK_REQ_PPS) {
+		fep->pps_channel = DEFAULT_PPS_CHANNEL;
+		fep->reload_period = PPS_OUPUT_RELOAD_PERIOD;
+
 		ret = fec_ptp_enable_pps(fep, on);
 
 		return ret;
-- 
2.43.0



