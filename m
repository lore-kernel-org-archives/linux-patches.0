Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD54442FDA;
	Thu, 20 Aug 2026 17:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247867; cv=none; b=WKF0V5qiwyK7PX0wSSJPbG2KP+OLcun7+OFeXkSyyc8VCAEavnKbF6n30P0En9KVlVkDHSxos+Qycwhle4kWUOzxyi7/XBTXTqVPn1iQDJRJL5oWKwgxobTRlCg4O9knx4dzYhY78vS9Xj5itgH15DfpYreuTq6Z8SzusA+5cNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247867; c=relaxed/simple;
	bh=r5J1SCvqqLr9Nu1WCNRGquD0LROY5l6XY7L1aVNXOus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZJKDKqBmF+SFRnvM4nMuOYAPvezHMY8c3LdLwTwvNzjuIwOu2Fb++KhY1d3hmNdTmPHJ+WvGTZ7/YgYYuNsQTx3ddCpfyw574+aYAw5kF2pbN41/R7gF9GvSYR6lMLug8yOfXjQDdG4Qm5UjK//FD835NMePnHqcuOVJMnUWVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyzJQ7C8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyzJQ7C8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DA61F000E9;
	Thu, 20 Aug 2026 17:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247866;
	bh=NX9ycR1Hsn9fYKEjhf62M2L80wq5TmjAaDdl+9+pV+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GyzJQ7C89uSFKeFB+GGhuUMDXOuResiw4N2pKv6cC09gIfaeagULiXJiPHxvfvPB8
	 sYcCg8KpQKn4F93SeOy4Fjeo48GvRGy8a4MWVQFPAugahdgEoh7w+PmgybQIealgew
	 TjAz+odOLL03hrmfqYj6CXCWE8Fw+Q+JCnkDTnh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 030/303] crypto: qce - fix error path in devm_qce_register_algs
Date: Thu, 20 Aug 2026 16:52:46 +0200
Message-ID: <20260820145254.092866043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 9c75402286409f5e1a75e4a445555c84066f89db upstream.

If ops->register_algs() fails, the error path repeatedly calls the same
ops->unregister_algs() from the failed registration. Use the loop index
to unregister the previously registered algorithms instead.

Fixes: e80cf84b6087 ("crypto: qce - unregister previously registered algos in error path")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qce/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -55,7 +55,7 @@ static int qce_register_algs(struct qce_
 		ret = ops->register_algs(qce);
 		if (ret) {
 			for (j = i - 1; j >= 0; j--)
-				ops->unregister_algs(qce);
+				qce_ops[j]->unregister_algs(qce);
 			return ret;
 		}
 	}


