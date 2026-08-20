Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C2F377A82;
	Thu, 20 Aug 2026 16:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244050; cv=none; b=JHTG6GqDm4z74UOzeReTjoLcJjK0Y/EoGSgQuMgclrddr+m1f3aVrGPaKFEPuL8OWBnFen4CNXPuhz+3tm1ieS1fMsyhSbxp75gVpSSpX3wAwEsd8idDpsJ7lYhDOIdtVmhrU5Ne0vYlPAQsPrRflRQeANVms4uZdefv5bFYT2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244050; c=relaxed/simple;
	bh=IQtlbaIxXXnwH9NoDO+YkvS8JiJOfzbc6VjSrYQZSow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLitqas3cuV5k8V8pvh0rrAwtUfI6HgpitUeeZCFqZa8lKs769bvmOziLANqYQbPS1o+pc8DHnZkKn8T2a52IMbUT4ywApakWhzNoXTIPnUs3DE3EeKAEGvgYyg5cMAUsqTu/WpDq1jepLtlRXE1Szfz83F/U++13CV44N1fOdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWeS7Nvw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWeS7Nvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFF91F000E9;
	Thu, 20 Aug 2026 16:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244049;
	bh=9+HXdsoOLYSrQEnMxTcmfOil1GxQ++B0NyunkQFMJZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWeS7NvwWZ+EOKGXa+FvYnPrHYC0EGtiNoQkQw31M9mQLR+Gvr2XxEOeRCd2KYN96
	 nlsoFwFU307wDsVIweFL5T9Dh7BhYz5/s9B6mDWdClRmEal0NMdPJGv1b5MzcsqwCs
	 4OWP1fFMi3nycstUTWSSvjGGbxxTWs2QzG0Fys7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 5.10 034/235] s390/vfio_ccw: Fix out of bounds check on CCW array
Date: Thu, 20 Aug 2026 16:54:30 +0200
Message-ID: <20260820145217.467037359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

commit a005b7f1a491ffda61bff0fd0f6548f8986fb977 upstream.

The routine ccwchain_calc_length() counts the number of channel
command words (CCWs) that are chained together in a single channel
program, and rejects anything larger than CCWCHAIN_LEN_MAX (256) CCWs.

The loop itself is "do..while (count < 257)", and while the logic in
is_cpa_within_range() correctly adjusts between the 0-index array of
CCWs and the count of CCWs starting at 1, this means it would look
at a possible 257th CCW before ending the loop and (correctly)
returning an error.

Fix this by restructuring the loop to break as soon as 256 CCWs
(thus indexes 0-255) are examined, without looking at memory
outside the range.

Fixes: 0a19e61e6d4c ("vfio: ccw: introduce channel program interfaces")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_cp.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -371,11 +371,9 @@ static void ccwchain_cda_free(struct ccw
 static int ccwchain_calc_length(u64 iova, struct channel_program *cp)
 {
 	struct ccw1 *ccw = cp->guest_cp;
-	int cnt = 0;
-
-	do {
-		cnt++;
+	int cnt;
 
+	for (cnt = 1; cnt <= CCWCHAIN_LEN_MAX; cnt++, ccw++) {
 		/*
 		 * As we don't want to fail direct addressing even if the
 		 * orb specified one of the unsupported formats, we defer
@@ -393,15 +391,10 @@ static int ccwchain_calc_length(u64 iova
 		 * after the TIC, depending on the results of its operation.
 		 */
 		if (!ccw_is_chain(ccw) && !is_tic_within_range(ccw, iova, cnt))
-			break;
-
-		ccw++;
-	} while (cnt < CCWCHAIN_LEN_MAX + 1);
-
-	if (cnt == CCWCHAIN_LEN_MAX + 1)
-		cnt = -EINVAL;
+			return cnt;
+	}
 
-	return cnt;
+	return -EINVAL;
 }
 
 static int tic_target_chain_exists(struct ccw1 *tic, struct channel_program *cp)


