Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217032;
	b=BksIQvpuZGtkpYTq96s5PAVke2dF4jwYnGFxrMdbsCU89ny+4fyeOJdJkZR6mZQVerpf
	 N427HQRBCuLPhcQTPBof8qsMHIhRwvUH4nZsXUoIouf47rFhylVbgxTbfT2Ksk8LPXsPQ
	 Ylu+MK4xaTHWBIF+hhH2hRkKvMnQv6uJsazVCy/F5SOc7QQGPxgmmuZl7ujsNM29Prsos
	 KUqSopCU023CU7Gf6uRktNEf0HZuzIPtSYOCGwKzk6G35aZ5z1lOxxxltFXcvv2THoOT2
	 HefwJ9aaD3nc6ux4iDHMB2HMCjSzkMJdXoJyrEx4A5tS9iDPL5K2ESJRKo7edIE1Now==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ou/YDim44IZVsQUH7rMWL6DoCZSZJYZ6enrmLRzscQ4=;
	b=sawaqa8MMoPi7oZGiZXjv1dwf4u/CEnaZnXx8uC6c4MDzTPqrBRGozZOrCB6Ev8iNe57
	 kJajqQjaH5l9Ou86ncjKvRuiHaJtYm2EXbVQ2dUT84VrS3tifC3i9Y5dLRs8jxN7z7OGu
	 jE7LtHQkVbJLsK1yabQewbYSl/7KIozR4Sdqdh7VXNjOdb2o/3eWB0wWFhzsPbh283GwB
	 FFfquyjp26y1yEtVIPfYIbQEOPFj0LajzG4QAovQOjBpiYKnqxMXg0wjrq8oyJE0dXejV
	 R+JMIx5B6fQqnNWmW8RmrIvuZ4Hw4LQA/8KRrW+TkyNj/GI5tNXzfngx2pgTQDjFJww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UFHBGbzj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89AD606A326;
	Wed, 28 Oct 2026 19:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UFHBGbzj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F841F01825;
	Wed, 28 Oct 2026 19:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217031;
	bh=ou/YDim44IZVsQUH7rMWL6DoCZSZJYZ6enrmLRzscQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFHBGbzjf2eoFi7xYkLqQs9Ok9bHoBzCsFRojWBmDw7mKPfN+yEN3YFWvFq95wBxE
	 +1c8Xzy1hYSRAshJczeGpN344zaslKinw9hCUl6FoYXXVjfWn41lW8pUXdNl7iLrYp
	 O0GYRSk+YDxTMy0KJldAncC0wvqOi0tW+9ywpUlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.1 1764/1887] s390/pci: Fix leak of uninitialized kernel data in SCLP report
Date: Wed, 28 Oct 2026 18:04:20 +0100
Message-ID: <20261028170539.597371911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


