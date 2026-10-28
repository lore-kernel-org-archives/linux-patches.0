Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210108;
	b=e6/kfgGe/jnOsV3eRvSj6PeonWiC6TeTYR5RCgy5w39C4wt/PfYoFjkSVchPmi2paNjC
	 igo1el3bg5soZHq0vCk8I2F+nz0bgORMGcxK22jEo8+SYe7dg0KLPJwrBm7ew7fxFsEqS
	 NusCCWDpBMjsMydfbO2Vc0TLFxrA9HZPxgYnPFiwq3mp5V95ELuzyhv93HsnpV5cbp19r
	 2wT9S/StVTaksNQzoAgH8nM1ie/yGdkdOeUeuyBprF8LsiROT/J7H68eqVCyXzZWoEd+r
	 6Z75i3KPm7z+sb24c1xQrZhjlygB9wnYUqudMRRAhzD/+OHJ8gr3LDG/SJKhRhUuYWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xjzmNzCvZfXYyCLnuKjcTrM/D5jSV1wQMpBQkFPCZUA=;
	b=FrgGAmt7ggw2Lhytnvu99RRPvZVkPvwJYaLno6a1zwDy5+2wgP7PhHhpvseYB4vyURux
	 9Tw9hjJJ50tuqjW1Uj8+1m+qjxceVNDno0hxPRYZc3vqyVJZRbVGxc7cq+B8gJsmzmF0l
	 duNOuRkRhgGAk7xmaaN9RwfUhsJonzKxOHmfZ310IfoTArliBoRowzL9wVaIegqtU0MeQ
	 t+1gBmA9lDEK/A5BrDyDFsCbVZtPPxsf6HOGg+3hLDI9i1wLcfUlWCMMinBpFt442Ba/O
	 IP7du/aAqybdlKxBEKRHU4jKCcBk8EkTmCxcUxHQwYmWLfenaHYMP27em0vY0FoknSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f7d4Kx0p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094B2606A323;
	Wed, 28 Oct 2026 17:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f7d4Kx0p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5989A1F01825;
	Wed, 28 Oct 2026 17:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210107;
	bh=xjzmNzCvZfXYyCLnuKjcTrM/D5jSV1wQMpBQkFPCZUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7d4Kx0p8YcJ9DyEDZM6GDLEKh+31G3pewRVqbsuxCO9h7J9vKUi5yQOFlbEGPmud
	 jVGhiVHpDZa/iV3k1WqTnbVY/kQuKtkKs5ay2w+5Byd2dvzkw2YpSMtjapVDlz6jk0
	 KPi8qO8LSJFazXq7SasOlftHOeqLQ5Ja3Q4LaTo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.6 078/168] s390/pci: Fix leak of uninitialized kernel data in SCLP report
Date: Wed, 28 Oct 2026 18:00:14 +0100
Message-ID: <20261028165944.930623729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -146,6 +146,9 @@ static ssize_t report_error_write(struct
 	if (off || (count < sizeof(*report)))
 		return -EINVAL;
 
+	if (count < (report->length + sizeof(*report)))
+		return -EINVAL;
+
 	ret = sclp_pci_report(report, zdev->fh, zdev->fid);
 
 	return ret ? ret : count;


