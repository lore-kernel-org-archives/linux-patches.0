Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC7C379EDA;
	Thu, 20 Aug 2026 15:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239446; cv=none; b=HalpGLBppbqgIPtHi+S/EbyxRZvKR+iiGH0WCiAN6ou+SxRfsUZmUN1mfazxDKclff/iDgjo2halwJ/FH8o/467YXok11kNDOyTlhLUSaTgVYOWb8O/jIHSrsdBBWj95MJGi28rn6J62/fR6i43WFhGRoyF0boT759dY2YL7Ixk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239446; c=relaxed/simple;
	bh=7eWxy+S1hPx/Ymte4EZP75qZZmJKuCB2YNTeaWzKHco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gF88T7EzcaUCgqvceEnpxN96JBttcNlPUICwx9n8u2MlCnLbHc9qF5zDZIUFz/c4mqlS0UkBEh5VUj5P4m0ld43ro3A1ye2+kSW8S77g0nmcMc+M3jYfyd+8QfYG0wBDOx5Abdplsjxqw+++c+D1DW9bjO8W/WSp4gNVeb9YKus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rzs45kP2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rzs45kP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2580B1F000E9;
	Thu, 20 Aug 2026 15:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239445;
	bh=XKuYH0dxosM5hqv+ijliNCzxvK8kGooUZMvB68C+nkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rzs45kP2+KUIH5Z9ySCW0Q6xlqUsW4VHgp435rV1Kt0haqprCokWs82rvTI8bUQPq
	 u2XO+FquRgyPjZ41CzwZYTQDKzmS3Xv+gL/QpvpyAmFbnbepn2nI+dtItFakFdXRoh
	 THBhi2W1LoVCLUV0wo9UuEuTzMcbZuHOxczkdkfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 051/220] crypto: qce - fix error path in devm_qce_register_algs
Date: Thu, 20 Aug 2026 16:54:01 +0200
Message-ID: <20260820145225.031576202@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


