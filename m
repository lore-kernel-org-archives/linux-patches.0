Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165DF502788;
	Thu, 17 Sep 2026 17:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666475; cv=none; b=hL29MPxMjR1faVDdzt2OSRZiHuqYdWjTYyh3dL2yCjxLKvivolMAmfXIkeZ3nBAHfQsbCFHKZlaRsJEIhmr7KmWFQxFcb52olPvLQ1mcCd/szqS81R7V9Dmh5JdpARP+NS26/7RtVK+GlALp6P9ANVgB/upHiAwgDb+8zPwFPNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666475; c=relaxed/simple;
	bh=KXMRMKsPBUAWC1GvxJJhfoSD9SQJGCAdDdNKtCxwGwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+tdtIaDS7aJy35nIpwJIOvTL+HcjIOOLagjE+4ikbElw20EwXZg4NY72bkgQviOweXkwiLkCKXoaniBLDEMzheB3ffUS75yLnEVWntoQIFxcT7IEwm4TTD65gpYc4RBpKS5JgZGXun9GPsUI7jJCbVxdAXPcU0FokYl2JFinME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Up18wDc6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Up18wDc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ED21F00893;
	Thu, 17 Sep 2026 17:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666473;
	bh=O9aGwEOwU9EWutuVXLRcMRRZcmOSnBjayzj4sm9qbKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Up18wDc6fJSWK/0MfS99F8W/o9rDN1xo/KBBBxLzowOyN6pTGKKi6WcbW0C5Vk2MD
	 zs7CG4TmTf10drJXaKUfDKJqOtnkibrepwigo7205ULxyaAlhd7bfmgEsR3qwfCh2+
	 pTCo38bH4iISQfASKcdNctiIeknfQALHMzK2mk5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 1049/1250] s390/crypto: Map EBUSY to EIO when key conversion fails repeatedly
Date: Thu, 17 Sep 2026 16:14:04 +0100
Message-ID: <20260917151620.543432073@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
@@ -213,6 +213,10 @@ static inline int convert_key(const u8 *
 				      PKEY_XFLAG_NOMEMALLOC);
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
@@ -334,6 +334,10 @@ static inline int convert_key(const u8 *
 				      PKEY_XFLAG_NOMEMALLOC);
 	}
 
+	/* But finally map -EBUSY to -EIO to indicate an IO failure */
+	if (rc == -EBUSY)
+		rc = -EIO;
+
 out:
 	pr_debug("rc=%d\n", rc);
 	return rc;


