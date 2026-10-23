Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774271;
	b=qOJeqc0lqbQnLY8tAD2JFv60Wbq1bxcLZSJoMA2knDKRD1POMD7DL3XBciv0xIRbI676
	 cYnl4XocEXoic/HweBGcHEZ3lez8dOTpbSL3F/DHelULNz0A4lNVqSRPRkPfQJ7ihPm9U
	 oKi22fKgxpQfAhEp17A14rm5bdN4lUFGeihDoAr0UXYeuXog6GZtZ6IUM3ZSvcHbcymOW
	 pHJ1LTLs6nFEZLite5jQ5DeOjqsSoOYOdX5SN9Pc7EV0eau9XHiFTDLi3qas6fyQv5PLD
	 5f+CBm17lF0xZXzbpdUUXB7kyEyrOAzKC0ki/eWLhw9XnHbFDEDwO6XSBE3Atm1fzDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xegsbpzVjbALF+Nk80qzZ6iKxJyepKIosgqgeKso6ug=;
	b=dlP+P1QY7WvSxu0U1fpemQwNTai25d/gFnZX7VLIIU2kcR3IA4I/AS+S5qOIplrD4HdN
	 P8tpQbf/+aZkmwn00iR9iljtJUtHxbIAQiNryvyBDtmP8TqToOn6qYKkBuOfRNH0RWtYZ
	 C/1AcGPLy5c5MLBFSzmq8SW/0lp3Z7mLWwLBOVTWGHKqgJ2gHNuL4Odz2rlWYe9s5MFr7
	 p9ji1Iy4qnp4gMIRn7T7jDeCeZgA2f7THLPhs1I/ByKqyAPcWW51EySAKCZr2mXP2XmEn
	 ZmbwAnr2uKUWwwQoL7CijkZNVGM2Dg8UUp7ad7SSTCbMj0qmQHDdaJaEPwHneskMP+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wM56hK2x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DFD606A31A;
	Fri, 23 Oct 2026 16:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wM56hK2x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BFF1F01825;
	Fri, 23 Oct 2026 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774270;
	bh=xegsbpzVjbALF+Nk80qzZ6iKxJyepKIosgqgeKso6ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wM56hK2xJDC25ApBGU7KJr0bbogS1VgbLixK1Us/Ou4pA+DeQ1vKu4cswl9RCC0ZJ
	 ExS9ylXmlxQeShTpQ394Wq2nn133u59nwOb6xaNadTyCezoyrot/lMygBH0boyK4lJ
	 CYJPjBBFiBCxApOwAl9rCHTpb7e85U9Qnrk6HhaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.18 140/193] s390/pci: Fix leak of uninitialized kernel data in SCLP report
Date: Fri, 23 Oct 2026 18:36:57 +0200
Message-ID: <20261023163717.518380267@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -154,6 +154,9 @@ static ssize_t report_error_write(struct
 	if (off || (count < sizeof(*report)))
 		return -EINVAL;
 
+	if (count < (report->length + sizeof(*report)))
+		return -EINVAL;
+
 	ret = sclp_pci_report(report, zdev->fh, zdev->fid);
 
 	return ret ? ret : count;


