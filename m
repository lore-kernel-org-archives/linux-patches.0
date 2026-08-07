Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488C3306754;
	Fri,  7 Aug 2026 15:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117613; cv=none; b=OPTJibRWRYWq9GcUXegY6BiHzB+KvXqsxvWDCbQCBctfIvNx+gxOYaVionpjFzL3Gk1IVB0bwVadT4SbXszmHEUWeBEONF2im8mRlBOAovCE0erROsID+306k5Gu4RN/fi30/yrpFDwpvf2cwtG6z93TfXVCDHjnaSt7cVowkhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117613; c=relaxed/simple;
	bh=vPkV03lRmgcv3mLoPV/KOfQxdQ83/+JC2mMIBi9l2GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhUWpp5YX1OfBGAkcGD/jKi0z+picADK8d6+9IkyCEDeNBlIfq94En4W8AFk2tfHDHveo/OmiDjEVsiSpg28bzUo0ogh4UlpzipdCu8MW+XYxKFxsRqgux9+VH/xJmKbLFu9enLtQdNFbwJHpeRs6g0AY+pwFupg2OpI+sK4jXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7tpA4p0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7tpA4p0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43DF1F000E9;
	Fri,  7 Aug 2026 15:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117612;
	bh=uQETA4PKnWgkRogrdJdqLkaMufeN6N/eGGa29rOnJCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7tpA4p0aOrMYvjwUDiCCHpgzXTFuVl5iQPWKw7XVvh2qxi+fUZjTKO4nM6mFmyHU
	 qMqFpmHcpSbLutk+q5TNuXw4Rppc1O4f6noaH24gjqEN8YOmJrtRP0HDCPgRReHoaA
	 GCk2SAy6XC6rUl0gwxlbu2Nz6npEg7DjN09aLEnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 7.1 380/438] can: ctucanfd: handle bus error interrupts
Date: Fri,  7 Aug 2026 16:39:36 +0200
Message-ID: <20260807143436.068320738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

commit e74bae899529f49c0f375307983d12e8ecad7d4b upstream.

Include REG_INT_STAT_BEI in the top-level error interrupt condition.

BEI is enabled when CAN_CTRLMODE_BERR_REPORTING is requested and
ctucan_err_interrupt() already handles it. Without checking and
clearing BEI in the top-level handler, bus error interrupts are not
handled or acknowledged.

Fixes: 2dcb8e8782d8 ("can: ctucanfd: add support for CTU CAN FD open-source IP core - bus independent part.")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Acked-by: Pavel Pisa <pisa@fel.cvut.cz>
Link: https://patch.msgid.link/20260723074403.131575-1-thnkslprpt@gmail.com
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -1136,8 +1136,12 @@ static irqreturn_t ctucan_interrupt(int
 		/* Error interrupts */
 		if (FIELD_GET(REG_INT_STAT_EWLI, isr) ||
 		    FIELD_GET(REG_INT_STAT_FCSI, isr) ||
-		    FIELD_GET(REG_INT_STAT_ALI, isr)) {
-			icr = isr & (REG_INT_STAT_EWLI | REG_INT_STAT_FCSI | REG_INT_STAT_ALI);
+		    FIELD_GET(REG_INT_STAT_ALI, isr) ||
+		    FIELD_GET(REG_INT_STAT_BEI, isr)) {
+			icr = isr & (REG_INT_STAT_EWLI |
+				     REG_INT_STAT_FCSI |
+				     REG_INT_STAT_ALI |
+				     REG_INT_STAT_BEI);
 
 			ctucan_netdev_dbg(ndev, "some ERR interrupt: clearing 0x%08x\n", icr);
 			ctucan_write32(priv, CTUCANFD_INT_STAT, icr);


