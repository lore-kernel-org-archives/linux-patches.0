Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22E963CB;
	Wed,  2 Oct 2024 14:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880515; cv=none; b=KTrrNKBGft9WRwzoSRDw5pvfabIzGceq/J+fXWYLX6tEYAGtbrUCgEW2kiFVDdxrLpDjfF6lbOG9v6wj62fD0RWcF4KyFd17SGMlyI3rqvo2tqJyjKPdP1yQUbK1L1RciNoRlt6bM/r3HzXqybWvY/ud6+gpX1RW9qp74mj2DTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880515; c=relaxed/simple;
	bh=dXc0VHpEUrLOsomfsQlkEHd/dnCxRRe3ET/+Em+uw08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2hwXqnJcAMKMr3vu2JRfVM2SQxpuvCAubT6++5RJbiUYb+EQUrPNeV+EhL1l+GkvFwNI9M/uuAHtiMdocIlLGELQuR3LDWHMUuTE4z4GrEcdq8sJbxpQmhH5Sh8mIspwtrEy4WQFeaDvv6Dk66a8Su3t59EYQbk9EHHG04qA08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vTregNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vTregNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29821C4CECE;
	Wed,  2 Oct 2024 14:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880515;
	bh=dXc0VHpEUrLOsomfsQlkEHd/dnCxRRe3ET/+Em+uw08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vTregNWXwmBXqEn2KG+iECfStlimNSegSq5YpTu1Ioghzdch9X6q99BTfhvpL75+
	 JEp98Qu8d3FzenxjGs+O+R3BOdPN1+/CbtFP2Mx4FhqoKDa1dl1o7tqgc6oBjLlIhs
	 ypj4+djgpZD5WOXqxAp9ju7T2Gu5Ex5TAWBjLrUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 468/538] hwrng: cctrng - Add missing clk_disable_unprepare in cctrng_resume
Date: Wed,  2 Oct 2024 15:01:47 +0200
Message-ID: <20241002125810.916707439@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit 4b7acc85de14ee8a2236f54445dc635d47eceac0 upstream.

Add the missing clk_disable_unprepare() before return in
cctrng_resume().

Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/cctrng.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -624,6 +624,7 @@ static int __maybe_unused cctrng_resume(
 	/* wait for Cryptocell reset completion */
 	if (!cctrng_wait_for_reset_completion(drvdata)) {
 		dev_err(dev, "Cryptocell reset not completed");
+		clk_disable_unprepare(drvdata->clk);
 		return -EBUSY;
 	}
 


