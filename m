Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828909;
	b=mDmmTz1avFyqk6eGja8H2gd6ZIeuyp9ZWbLsgjtGP/3YimhbJMsZ6ojc6/uukoclSbJL
	 cCnkkY2GJi8g6XrDW0qNWOkvMMwX5vm2ugyCMBB4c+5nfeVW90rCtALE5tzq4sHbiM13j
	 YM6Mtrwho+AJ3cKKDyjHdxNqQVk9qJE3/95TcH8tMOzd2iYH8+opXuO2OBWoeqRN9xOCP
	 BDghTQdEdyETRwtHJi4GyzM4q5M4fDl9qnxKdVHoh9Dk2cHmubVFnNcamlxOperWsbFwW
	 FVmbKex7og9wwKqit6axvcW96tnGa7UKfycs7Joxe/oCWkLeCzW7nEIP8wA58vY09yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SYbg6+mgdu6eu2kQlTJiVrfh051mtbCPaP/A1GzojJg=;
	b=l4BRCa4TgCTRrWNwebCvUeLWEHDBxNC5uIu4MU4YZQ3LAm7GYeZBkYAQXqATrIrKkXbJ
	 T+aGniWf+gwOyihFiVbLqssaTbLMX6nWCclNS7MvsH3IleActme2VuTd7b5lv3ApO5dDX
	 o5WO7xxXiLOWqAlcCsLX1TRBe69qAprwYGwa3pya2CAdeP0UmDjpuZXgDNEjf+TJ0y9gj
	 yP0lc0PZU5YKEkC5k/bnivMVrS9DqgT+Une4pXRL7ih85uTT+b8/wiN2TIaoSyJXXuaxK
	 0KZ+2XHw7e1+1IyCB7qljXjXDz6gbquu5IPllm4XUSq8LfGB3Lcpp0UX6IO9E/ULb5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3WK4d1F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5D26070303;
	Wed,  4 Nov 2026 21:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3WK4d1F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06DC1F0093A;
	Wed,  4 Nov 2026 21:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828909;
	bh=SYbg6+mgdu6eu2kQlTJiVrfh051mtbCPaP/A1GzojJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3WK4d1FYqVAzJVLgGu28bV9qnrQs37bUqxhfI/1wOICvtzOwdOLJgIIfuyylub7S
	 E4zWcHqCXYiHb4jIDF1CiHf4VYSKvzZa+Pij6uYpQlb9fpMB49Kvu2afRGQUdKbf5J
	 LtTIuwZvG6oS3/TuMvEkzJRHS0JCTPHNRtjllovM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 320/547] xfs: dont repair fs summary counters with garbage
Date: Wed,  4 Nov 2026 16:08:24 -0500
Message-ID: <20261104211047.312460496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 22a8a7501c0146dba4ce99b8256975ffe945125d upstream.

LOLLM noticed that if we scan the filesystem and come up with totally
garbage numbers for the summary counters, we don't actually mark the
scan incomplete.  Because we don't do this, repair can install the
garbage values into the filesystem, making things worse.  Don't do that.

Cc: stable@vger.kernel.org # v6.9
Fixes: 4ed080cd7cb077 ("xfs: repair summary counters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/fscounters.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -368,8 +368,10 @@ retry:
 	/* Bail out if the values we compute are totally nonsense. */
 	if (fsc->icount < fsc->icount_min || fsc->icount > fsc->icount_max ||
 	    fsc->fdblocks > mp->m_sb.sb_dblocks ||
-	    fsc->ifree > fsc->icount_max)
+	    fsc->ifree > fsc->icount_max) {
+		xchk_set_incomplete(sc);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * If ifree > icount then we probably had some perturbation in the


