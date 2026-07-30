Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FFA448D11;
	Thu, 30 Jul 2026 15:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424875; cv=none; b=YmcWKZ/VWNFo7OuQZKLp60yp2U8o/dACjnWSIMBCaWTJHq26JkT5Q3iO5srJ6Qf/T85b+1Tzr750ZGwN9Mk/diKjlmSDU0xcQOb9ZbsgK9uiH4NY4NS+0UzrP2n7xVW/L4SSpC/qCTrqlEzQvAXa+/3VVTHJMGKP95lcs4bVVXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424875; c=relaxed/simple;
	bh=AbzqBCWdUCSDmhpyIDLUDQ3pZTpsoBMWq0N6ySTDM28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hq1JYk3zxUqbYTngTlnBxCNK+vlbtuMPYMXafDQrlOrqE+tDHXg5lvDmfOj10L6j/+wVaWKvR+jK5FT3+Z+FTHfCz2lNTAGRmv995FyW/g/uhUTEiHTuvaXvnW7/auxfZg/Gmi3CSVK5Gd36vGS0PgHzEJHwOpNRwuStPpQllHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQtsvqjl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQtsvqjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0535F1F00ACA;
	Thu, 30 Jul 2026 15:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424874;
	bh=OK6YCbBbgeezeqBs9IqW9Ts5sI5cRiCEqE3QSleVF/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQtsvqjlBRxfnjSeKWXWgJpyoVn+04NaeAPNTie6M57uiibJz/r1v55dAaHDUNg+F
	 gusZ7i0yM1vxbf4pCulvRPZgCkr3tW0tB3Wu9WQf22pSMX3H0Cm4zPdwdGY9lphACZ
	 5m1g3u9LXtybecQgQFhnm2/B1XKYgFxvIE3Wh4LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	stable@kernel.org,
	Heiko Carstens <hca@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 545/675] ptp: ptp_s390: Add missing facility check
Date: Thu, 30 Jul 2026 16:14:35 +0200
Message-ID: <20260730141456.726667923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Sven Schnelle <svens@linux.ibm.com>

commit e78f1ac37afcb16cb6fef8a2c92591eab6558956 upstream.

Only register the physical clock when facility 28 is installed
and PTFF QAF returns that PTFF QPT is available.

Fixes: 2d7de7a3010d ("s390/time: Add PtP driver")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Cc: stable@kernel.org
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://patch.msgid.link/20260714130342.1971700-3-svens@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ptp/ptp_s390.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/ptp/ptp_s390.c
+++ b/drivers/ptp/ptp_s390.c
@@ -107,6 +107,9 @@ static __init int ptp_s390_init(void)
 	if (IS_ERR(ptp_stcke_clock))
 		return PTR_ERR(ptp_stcke_clock);
 
+	if (!test_facility(28) || !ptff_query(PTFF_QPT))
+		return 0;
+
 	ptp_qpt_clock = ptp_clock_register(&ptp_s390_qpt_info, NULL);
 	if (IS_ERR(ptp_qpt_clock)) {
 		ptp_clock_unregister(ptp_stcke_clock);
@@ -117,7 +120,8 @@ static __init int ptp_s390_init(void)
 
 static __exit void ptp_s390_exit(void)
 {
-	ptp_clock_unregister(ptp_qpt_clock);
+	if (ptp_qpt_clock)
+		ptp_clock_unregister(ptp_qpt_clock);
 	ptp_clock_unregister(ptp_stcke_clock);
 }
 


