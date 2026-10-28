Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211969;
	b=2naiUzVwUFYUMmnMqxsIHxkdCDXWXwgaBRKW8qxXhTgPP8+557NBr4vhgbWiSS+nusZA
	 lBpcqkwS6RxTMTqTQD7JtmT/PsWlKkgk5rMx3lRSd37AgADa5bQagwELByNDvIcFjcZ0J
	 F43x8DVn0aK63aMCM3Ie6Nfr5I/TO60n2J09m95lisdwRn9wGHSf8NRoYqgqFHBe/dWTt
	 cxDlyPrHFdctUm6rkwj+4lXQiTuYTuyMPq0wMxGh1COLB5kOleuaAxvyuEpATbo2z0Pvz
	 oEgUH2W5ghaisr61i3iWaqlWAaXI6w8Z2KaAqN2Lpx5BJYMarrjxtUOim3jDtqVMdaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=28m2re04hBbSbgTk8/eNrOetSy3x0AjXwEoS5tFEcfs=;
	b=zXBA99+TZcPMnp63QzO6D0PTIa/lisYc/qnhxzAWNAttjLnz9X+0lVU2YqUj7XXYKcjU
	 bS4N6XhoxRYpoUiVlpJjtNRBHjn+NOyyGxIBQqon56P+Y1W1tCOnR6CbWtagwSBl8UXz6
	 gZABsIQhpWMVNLHJWmwtQF6jPTk2Si796r4mcyR976eVfVU+a8byb7arjo+TMejm+KXfH
	 4y7Ydyn/dAp/e1BZfzG2NovS/Rdhjuw3Hy6/j/j7gBTYUSIoXqQElw0lFmQZuWdm/k2n9
	 AfUvUOPVPd+gjmriqM+zZjevJB1oM+qhdS8Lucgy3eejAStunxBmh+a7KISbS4Y+eaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g2WMJsBx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3153606A31A;
	Wed, 28 Oct 2026 18:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g2WMJsBx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCA71F01825;
	Wed, 28 Oct 2026 18:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211968;
	bh=28m2re04hBbSbgTk8/eNrOetSy3x0AjXwEoS5tFEcfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2WMJsBx25GSiLazyzuFnY2QCx6Uw3we0GKZeSFsJXcWGXjJTQSUse89tNPtqBhif
	 +bYDXx7TK/xuYgWUTvcCf6nWl54V+pWa4uu2HAwe1bRRlFo38K1PSYkBqtJYq4O935
	 kg+/R5zQnSMCwCE3dVUKVDmh5TmWgMuHJ/8OMuks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 519/571] s390/pci: Fix leak of uninitialized kernel data in SCLP report
Date: Wed, 28 Oct 2026 18:01:06 +0100
Message-ID: <20261028170020.344716756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -138,6 +138,9 @@ static ssize_t report_error_write(struct
 	if (off || (count < sizeof(*report)))
 		return -EINVAL;
 
+	if (count < (report->length + sizeof(*report)))
+		return -EINVAL;
+
 	ret = sclp_pci_report(report, zdev->fh, zdev->fid);
 
 	return ret ? ret : count;


