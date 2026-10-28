Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209563;
	b=UPdR8jWMzdNbGyZ5cH+I8DQXDwNw/jq3qArIz6WV5wmE1/Yrovwbr3+7tcKHAOmlWdXF
	 4S9xQjBxQIJMkYb1ZJWbJ7aupD247C4jO3WWJg7AWEfsOks8tHJVOHojhGDCrKau2choN
	 VPLeZBwRhMn73dfLq4O22hjNGWYW08sRo1sf7aBnOBGsg4wu4TwVo61T4zqE13WT5YA2T
	 qU557JcEhmMpOiRVKtGzV8pckS+AnZrtu1s2YRQVR9AQuN1TuBtagYVwvjQYHxOqofuqd
	 m5HQqm5sFiBCcJUAI/k8j4gei22g9aFLuRi3OQVlGOYi4jHnL/4xL47OkY5EAvFBH9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lIp2zfwOtZJihu/f6hrATG+UOsRMIE2naD6NHYOY/k8=;
	b=Wz2f+7ZPVKPvhOYuT5hYtY/RX3PTuEt00T3/1eHg2O9H8orb++Qvu8NCuQ6FxaXSrlte
	 xMhZQvFYrEJdMO0Ogs7qlHZK/nUz967T52gkP3id3mucqZ4INatRb2znppA8QIFF1ZqVj
	 W/59RKL3EbNKmDJ+Jy8gxJhpUXKkm+uW96bMfaOqogOSXqIZBrIhua0c9eKVm1sU+I8LK
	 SecvulW6EComksbAfr4AbseTJc0mLLywwlaGPxcykeKibzZ5K12aV5qtiHps/XcjbHML5
	 5PIqi+RJSxcRViio4Qbw4+f9iAO66xql5POvLS1c+8heuvv+MSrN6lmGIV4PfYjPifg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jBdd7uuu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF52606A31D;
	Wed, 28 Oct 2026 17:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jBdd7uuu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465BE1F01825;
	Wed, 28 Oct 2026 17:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209562;
	bh=lIp2zfwOtZJihu/f6hrATG+UOsRMIE2naD6NHYOY/k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jBdd7uuuuUMo53v48dNYHXed/j2RJGqkYRMtDA+iZg3SEGOxwhub/o8jwgE+w9CaE
	 pYGMNdhO+92X2qnlrH3HscKn1N6vmEsHFiUPeNwO8GDb8wtiyqPEyeu9TDMkiQ66fx
	 yI3brYQYRZGzoJ8lvFQCYXs/WGstq0iQeGGU3L9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.10 472/516] s390/pci: Fix leak of uninitialized kernel data in SCLP report
Date: Wed, 28 Oct 2026 18:00:24 +0100
Message-ID: <20261028170014.662814108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 8ac60ae2a307a50b599bf5d300b448d638f3ba29 upstream.

While report_error_write() checks that the provided buffer is at least
as large as the header struct, but not that it is large enough to
contain the report with the length claimed by report->length. If
user-space provides a short buffer, meaning a larger report->length than
the actually written payload, up to around 4K of kernel data from past
the kmalloc(len + 1) sized buffer allocated in kernfs_fop_write_iter()
will leak into the SCLP report.

However, as the entity processing the SCLP is privileged and able to
access at least the page including the report, this does not leak data
that entity could not access but it is still an out of bounds read and
a malformed error report that should be rejected.

Fixes: 368704a65be8 ("s390/pci: add report_error attribute")
Cc: stable@vger.kernel.org
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_sysfs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/pci/pci_sysfs.c
+++ b/arch/s390/pci/pci_sysfs.c
@@ -125,6 +125,9 @@ static ssize_t report_error_write(struct
 	if (off || (count < sizeof(*report)))
 		return -EINVAL;
 
+	if (count < (report->length + sizeof(*report)))
+		return -EINVAL;
+
 	ret = sclp_pci_report(report, zdev->fh, zdev->fid);
 
 	return ret ? ret : count;


