Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774929;
	b=T+nGtiEIrNah8F1/n9v8bPV0tCAYbudc6fsAvbtbaEfPYBRM9zVetjnGbl3jyC3mwS/k
	 ksvXb0xGaeLyf39CNUwyCvLS/IFpgmDpnlloiV1zhq7Mq8mKyLDBNigya6sz/A4H7sIvf
	 hgVgvAPfmplyBRJYkrGx3QKCd1tjunePrxj7JOiXtHWk9SRSQoRJeH2JwnJPJRZK6St20
	 frGrukCjBdoeyvzBvcEHJlvR1h+TLP6I68MKd83RC8LvFVIaQ2JGAypPs1TR09ZSi2cKS
	 1w94CbYwjxejxd1ri8NUzXQ1yjBg3bsb4dNKZ7NJ+CtRcpZuS3xd6zZhOIiDzu1hzwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wrUEPJv6kQ5hW609q2/NYFdyITzr5XU4vOFIQR/ajPw=;
	b=xfYE//0JfMRiVH/zLUZNKvFGhYzzr2VXaFO9hgmnB7ps4atsQiD+kYyYt7TOxfCq4lOb
	 Yz7TX0UA/k37psxTh6bqQxuQmQ0bYMjqhluq7tJc3XHBNgzLRvxTFnRP0cfjqoI0GEGwS
	 bWbYscvCO4ICx8ywkxLFfSMIWaxJcTZZdbl6ua39htXy1/47slhC07c7/h0Y+ZJnc2Ny3
	 EyWszJ3DiO11+5xeXUmlX7f7lIRl1jVmo+29ZuL1P71VaN4YWZKxjnsMdd+5io4n5bDkx
	 3e82mxedxNpcQLsUveDnuPRwfZFYcXoyfpCaQaM2qhJovewli5Pcsx3U1QwGocvKAYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F1k9w4C2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CF9606A31A;
	Fri, 23 Oct 2026 17:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F1k9w4C2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7C61F01825;
	Fri, 23 Oct 2026 17:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774929;
	bh=wrUEPJv6kQ5hW609q2/NYFdyITzr5XU4vOFIQR/ajPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F1k9w4C2KyYb3JO5xRTMYctCawkI4sQtkHfM+6KntQFb6V06yOAn8qguAoo2ArNXD
	 73jyIrtRVtrmnlPaqjBdcMUGTkIrX9K5WIGaUTU6+flEXXVVV1mCY7hRNOxMskoy01
	 aGHueUD5TNpLy2JpnqTjVM10nuBTABUK5vaUce1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.2 204/242] s390/pci: Fix leak of uninitialized kernel data in SCLP report
Date: Fri, 23 Oct 2026 18:40:46 +0200
Message-ID: <20261023163718.619292389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -153,6 +153,9 @@ static ssize_t report_error_write(struct
 	if (off || (count < sizeof(*report)))
 		return -EINVAL;
 
+	if (count < (report->length + sizeof(*report)))
+		return -EINVAL;
+
 	ret = sclp_pci_report(report, zdev->fh, zdev->fid);
 
 	return ret ? ret : count;


