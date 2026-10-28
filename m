Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207716;
	b=GimkyR0tcZt6rDuViSDd+T6LqAZ/ysfmSbOwtcfCNcgaYYjSvfS8XApXYDU2gJ74PU8Q
	 m3e8MYewXRwvKrPp6QvOHqYMyj4fGQ4TVlYjpJ5WZh3Pg8Fh+cqBfQDIe5E1I4K+vrJfJ
	 mBb9c+8843/Hq42Nh+tumUTN9yZyU++2cmkHsAkuERlO49p/HVlChiMlLNnl6a4dMHgew
	 DgeG2XoDuiE8LS3Or19VnxAQnNkdeRLlGAR/8NFYigsaFxT/3RKOp8uY5ajusEtrwIufZ
	 igYFNR9wCam87Gx2uMClV2icLbzV7IV5TWKUtHSn8ZM8hgx+XckUSthstwpkY/NwpFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xUUKOffxg7JTJTIWr4tdJMpCntPy4VTSaMTULXjMK54=;
	b=Lyxm2p9dS/Eppue2PZM1+P8v5EvD8ffrn8uMMtIaCc+w/K8HNCkPPxJ6dbGitiJA2NM9
	 cWYQth80PRGXoW0JECjkmpeti9E9Q6ebu6oJUxet7qlqyNkNch0MMGnEGRxvRF9IOSym8
	 PHhgHLdpUljSKmNa97pavFvxj665ADLwgchgQ8eFwDpr3TBSaYu230wXa8DXXcSi29mee
	 a7phPa12ibhKVmMM8LDagW9KTe/VxqJ7Hx7WrT1ilzZHJ/0njNgQMI+Xkoy3p7CBUb8xw
	 d7csdOnIuR2MzLBJd7ckF9buyhXD1P0VkSYvd7EhXZRR1xgV8Vg0bUZUWHboLqeTL9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QufsXM2p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F1A606A31E;
	Wed, 28 Oct 2026 17:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QufsXM2p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8174D1F031E0;
	Wed, 28 Oct 2026 17:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207716;
	bh=xUUKOffxg7JTJTIWr4tdJMpCntPy4VTSaMTULXjMK54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QufsXM2pQ4MB7o33rrIwYXvIsXp6NpWMcogHYoO43zycS3s6XdYGHB61EMl1lKS3E
	 FKB2bgKBIfpeCvBu/yuIdV7r1cLeRE/R6oxzpflbQ3KkIeHIYjlzQt9qJDZSVVQLxh
	 eyIrtg1vsgj8Jj/VXpG0gv6cuEepM/UP7UbnGehM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 113/247] s390/pci: Fix leak of uninitialized kernel data in SCLP report
Date: Wed, 28 Oct 2026 17:58:36 +0100
Message-ID: <20261028165950.074737852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -150,6 +150,9 @@ static ssize_t report_error_write(struct
 	if (off || (count < sizeof(*report)))
 		return -EINVAL;
 
+	if (count < (report->length + sizeof(*report)))
+		return -EINVAL;
+
 	ret = sclp_pci_report(report, zdev->fh, zdev->fid);
 
 	return ret ? ret : count;


