Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDFB4F85A0;
	Thu, 17 Sep 2026 17:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666469; cv=none; b=uNM6+W80J1mGQLUVDrDXFGr9SqWO64W3wSaLT/nYIncrV31a1VIF1U8xWeGhC/hbB1M6Z/4tu/FoFhORwb9JsMJ1k1csXMZ2QBKffkhaSEegcvwOiZ5FqsrPHBDNkoZQ8JUOk1ytg8Y2ATEqYdQ0Yr/IvvPtLEzaDFES5/ZqkWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666469; c=relaxed/simple;
	bh=euUbrKz4ezXZGTTWWd0oaJDchvKDOsKWjGrIHWv27Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvvGn5yIpSarNWueyzzCOcK3SYAVLt49D6afZOmwzcq9QGj4rFNeKik0mIln19ym36Z7Erct/D7hqSw3NP6eQ1ZOj/gpXDqi9rysTTvsJ16FPFl1WnRW/OgaK0Ooh6JUgbULqjYm5K/Nlbq5pq1OtnAolJTdAFZxDT5c2LCcjsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sb0Ua5Qv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sb0Ua5Qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC9C1F000FF;
	Thu, 17 Sep 2026 17:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666467;
	bh=H97gFutYhEiiV6sd6OaPp1QA6IubC1lo8V83ZL559pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sb0Ua5QvDs9wwW9kWeukK57ORUdsZEMiwXuHZ2NW1/J6kXD0DJdmKnKwFVjzhJ7gm
	 TkekMxa3dtpkDQUARCuPxYZi1XzQpdbN2+yIvlR9i9R8GXCya8n5qv1sRcY6+euMmv
	 8HZFauXa4adZcI+fZLNX25wtHbLGveChU5A5cepM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 1047/1250] s390/crypto: Fix missing scrub of temp buffers with PAES algorithm
Date: Thu, 17 Sep 2026 16:14:02 +0100
Message-ID: <20260917151620.468001599@linuxfoundation.org>
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

commit 19a218b46b2471d370c11fb52040f36ac8d05d23 upstream.

In function ctr_paes_do_crypt() there is a buffer used to process
remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
thus could lead to expose of unwanted data. Rework the code to
explicitly scrub the buffer at the end of the function to avoid
exposure of maybe sensitive data.

In function __xts_2keys_prep_param() change the existing scrub to
clean the whole param block instead of just the key field.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/crypto/paes_s390.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -1022,6 +1022,7 @@ static int ctr_paes_do_crypt(struct s390
 	}
 
 out:
+	memzero_explicit(buf, sizeof(buf));
 	pr_debug("rc=%d\n", rc);
 	return rc;
 }
@@ -1349,7 +1350,7 @@ static inline int __xts_2keys_prep_param
 		memcpy(param->init, pcc_param.xts, 16);
 	}
 
-	memzero_explicit(pcc_param.key, sizeof(pcc_param.key));
+	memzero_explicit(&pcc_param, sizeof(pcc_param));
 	return rc;
 }
 


