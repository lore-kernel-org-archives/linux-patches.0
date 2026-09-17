Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF15C3845AC;
	Thu, 17 Sep 2026 15:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660527; cv=none; b=qRL8Vc0NbwlS3Q+Uh6RF3aG10fxijcyRY5HZ+oi8Qq2ZS6fy2RZukphLx1kjGG+DEs5/22VwC/T9parVEA++jZs6PjEsVzDQu4n79yqTgdiapnPBoOmFcp9hYNUVDk5EXbJMzBTpFnTZLiG7VXNKPEpqwGPni9R++ExUcaJOu4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660527; c=relaxed/simple;
	bh=OTfK4bGfToizMhjRkzGUvsLk+d9hS+Ewl+GrM75LMJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDnwQTXQeJELmIUX/oH4J6PgBP0Q8g7heWbMTvAwSgBXtYqPqaPvNfdF5cltXiSC9GVpW4hjdX/FwDR4KdCtw17RCxs9mjw0/+gampkh2ZlCGZuqmxVoV2d0P7FtxNzGkltL8qAWiE74Z9uZ7KacrKRv70UW51XoIpJMMvIYOaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKLyiqNG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKLyiqNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3321A1F0089A;
	Thu, 17 Sep 2026 15:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660525;
	bh=ahyR9ySvXkNiYZwYZ3dtR/Rr4wPaHRbEA4lNme4c7VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKLyiqNG0AX+g7/k/aWH5I1qYTyxyF5ST8YNUbGcDV5Yo84tLSRxmrszyWE0RMemV
	 UllosPuXzDw15XxkZScxVAPqnFaUmIhf1jqEltzd7HzfulBuHDUu7fHCayaPnVW4iX
	 GUaMA2K0h4S9mfsTtGsaKA/5RbiMp4BDgMi1Lv8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 7.2 582/733] s390/crypto: Map EBUSY to EIO when key conversion fails repeatedly
Date: Thu, 17 Sep 2026 16:14:50 +0100
Message-ID: <20260917151406.902056554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

commit 7a08507ea5b4d06ad8d269287913573f34467565 upstream.

When hardware persistently returns -EBUSY after exhausting retries,
the error propagates to crypto_finalize_*_request(). The crypto API's
completion wrapper treats -EBUSY as a queueing status and swallows it,
preventing the completion callback from firing. This causes callers
using crypto_wait_req() to block indefinitely.

Translate persistent -EBUSY to -EIO after retry exhaustion to ensure
proper error propagation and callback invocation.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/crypto/paes_s390.c  |    4 ++++
 arch/s390/crypto/phmac_s390.c |    4 ++++
 2 files changed, 8 insertions(+)

--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -220,6 +220,10 @@ static inline int convert_key(const u8 *
 				      xflags);
 	}
 
+	/* But finally map -EBUSY to -EIO to indicate an IO failure */
+	if (rc == -EBUSY)
+		rc = -EIO;
+
 out:
 	pr_debug("rc=%d\n", rc);
 	return rc;
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -341,6 +341,10 @@ static inline int convert_key(const u8 *
 				      xflags);
 	}
 
+	/* But finally map -EBUSY to -EIO to indicate an IO failure */
+	if (rc == -EBUSY)
+		rc = -EIO;
+
 out:
 	pr_debug("rc=%d\n", rc);
 	return rc;


