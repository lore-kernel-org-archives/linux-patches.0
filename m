Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1E82D7393;
	Thu, 30 Jul 2026 14:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423104; cv=none; b=ph0jGFcyX/Oo78PPX9SzqbcaBfABa7kbBoPQAH3NbIYga9VjbEHIpTF9hSkyZp/HgGie5itK2KHRN7lkxKanIfLN6cqZ1LvRepPgsmWkOkeDPmWsRUNXeIT5N8LrwWosM5NDuWgzTx9fX9chOADegCoRfrJa+pNLFPzS90B0vN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423104; c=relaxed/simple;
	bh=h/mROzyZ2Ydgwe3nP2hv1JXRQz39TetwoO39hIpj/Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MS5Akkzu8qZTyzjH9s1Q3a+PNx29uTNFkwqJXN3mq/lDX+2rbuf/0egm+p6lbAQM4Xl4QbBDA28z4063KXMTLpivBfwhGh3LYMHwupjsZW0PPyEWUaX3/xPwaU7REpg1K+CBtN85bJV94tKzdaF8KEO79MOa3rJ6rvvcTJAMB38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfL37GJw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfL37GJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6911F000E9;
	Thu, 30 Jul 2026 14:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423102;
	bh=K4xw5bbiDAFDkXVRxVSs/sD6zstqYEpyCu3hXWRKKsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfL37GJwifVqybNZVWhEia+4xxTn4vko4KIfCHQ9rzPHwT+Lla/scfpCaZPz0tRA5
	 93bQDxoM8MJzlRWKinPhd+w1q0ThngJ5MNIHNaL1OvjmbKU+SRGwErGb0HEdYOFcGC
	 RkrDrV3Jby1LrmgisgS20K/kvtZCSOqcRsP31wVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	stable@kernel.org,
	Heiko Carstens <hca@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 667/744] ptp: ptp_s390: Add missing facility check
Date: Thu, 30 Jul 2026 16:15:40 +0200
Message-ID: <20260730141458.442328931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
 


