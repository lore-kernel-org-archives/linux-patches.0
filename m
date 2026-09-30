Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6458C538D68;
	Wed, 30 Sep 2026 18:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793592; cv=none; b=R0L9t7Ovlp+02encTfYSoQG2wM+qO+NpMkf2NmbAFEnAQDjwNtxzA1Dh2p2h9rVtjvxazvXZM1pRwQUSoFihqWhwaiKHUcZMXnVE1ThGYLZ5g8rbtEf+4uUwQ37t8e8Tak8kpbVELMazpl2aHoOu+Go+Ja8FVt7Eoz5618lgZLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793592; c=relaxed/simple;
	bh=x28gD3Fkwc0rHlACLvIlvFXix6LNb62wMIswT5WfZ3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0cVhgTFmg5GsCCMV/Q6egFM8mV8GGqrB4OcemuLtfhj1ihsy7P3GMibNsTwgcQXY04LqoPz0//ugdKCktmH+Dj/jBJYsvkddVb0FcMv3Z/sCxHfaNa5QfFoccIiqWnKeb6QUvVvjXEq7RhqlhhAcHCmgkcCcCSfwU8AE+Wmh9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPWDD/WW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPWDD/WW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C101A1F000FF;
	Wed, 30 Sep 2026 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793591;
	bh=VwVc0fBsAgn3WNtjirNzuNX7Yt7ExoGKLK2s5aqvPXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SPWDD/WWM/uxr32u56BFc4JINr3o6bRv6pwe8ExpZRaS4swvgQhpMrvNJXaexRhBA
	 H5ozTq7k22Q8hjWAOUxDzqyM4RZWnLsqMHj1vPEX0sU3V5y21eUdSoN13OapVC8q4J
	 6o8eVmhkjyt/+J4LTaRj3itS6P4nDdZdlCC48scM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.18 307/395] s390/pci: Report SCLP status on error events when no pdev is associated
Date: Wed, 30 Sep 2026 17:29:29 +0200
Message-ID: <20260930152347.313631834@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit a1120bea9bc8ea9d9ab2f9904a63b9a228bf2ffc upstream.

With commit 4ec6054e7321 ("s390/pci: Report PCI error recovery results
via SCLP") SCLP reports are generated when recovery is performed in
response to an error event. If such an error event arrives but no pdev
is currently associated with the zdev, e.g. because it was removed or
not yet probed, no report is generated. Fix this by generating a report
specific to an error event for a zdev without an associated pdev.

Cc: stable@vger.kernel.org
Fixes: 4ec6054e7321 ("s390/pci: Report PCI error recovery results via SCLP")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_event.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -321,8 +321,10 @@ static void __zpci_event_error(struct zp
 	pr_err("%s: Event 0x%x reports an error for PCI function 0x%x\n",
 	       pdev ? pci_name(pdev) : "n/a", ccdf->pec, ccdf->fid);
 
-	if (!pdev)
+	if (!pdev) {
+		zpci_report_status(zdev, NULL, "error event", "no pdev bound");
 		goto no_pdev;
+	}
 
 	switch (ccdf->pec) {
 	case 0x002a: /* Error event concerns FMB */


