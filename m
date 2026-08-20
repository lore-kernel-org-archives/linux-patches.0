Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A0037E5CD;
	Thu, 20 Aug 2026 17:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247481; cv=none; b=R1R6MacNwH3lFvH8yIe99uNaj2/SFaPGI80IHN6/eaw7J7pB65ow73kUiHbT2fSir13wbKZwPiHZlZ/vnwQ9xz9l6vo5EJpr6Sm6dXYSknLd3L4tMp2RX/4Iy1DPoRIZiDQgvWp5GQAoKLGiu2bIZXhS9dG/+vSwWZMAnTyptLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247481; c=relaxed/simple;
	bh=0TH1qyWTwLu5pERwqrKACObDaoVh2rPhT3piBt+54rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIn6uU5SsoP+1e8BodUA+84FG+sDQg7xhJgULPAYTXek9SP7TR3zR76Wkle2aZlSSUlWkEA+4thJtWObC3VVQST7yb0AXBme+WxuL7SXEY8WaG70E+SI9+gy1NtEv8y+O/Hn6asQB3SnVUE83xjQj8TL61TJ/BQi5f84pxfgyJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shDTyVGd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shDTyVGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57001F000E9;
	Thu, 20 Aug 2026 17:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247480;
	bh=dihpOESwg9miRBH6FEuk25nhXECxIal+2jY/zY11BYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=shDTyVGdpffnxM0rEiAKITs9YN2QbJCj1IBXUEZ4ot9tB3fJTJvYqxqvtf4QMamqQ
	 NaiApEOF88EAiY8C2l2QN7ygngIQQK7DgNqkG/lElxKAK8z8MJ0XagZJn9jgKQYG+Z
	 7jFi++VwxXF+TlJFb2bWlz04gUhJU8izYvp03cA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 034/166] crypto: qce - fix error path in devm_qce_register_algs
Date: Thu, 20 Aug 2026 16:54:53 +0200
Message-ID: <20260820145212.208682690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -58,7 +58,7 @@ static int qce_register_algs(struct qce_
 		ret = ops->register_algs(qce);
 		if (ret) {
 			for (j = i - 1; j >= 0; j--)
-				ops->unregister_algs(qce);
+				qce_ops[j]->unregister_algs(qce);
 			return ret;
 		}
 	}


