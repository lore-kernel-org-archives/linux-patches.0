Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5531E1D0492;
	Tue, 15 Oct 2024 11:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993209; cv=none; b=P9o56bEZzNPXHXFBE3Is+EPeBiBxKphIH0Kru+xATmRTd9ECF0i3lGBvW0f4VUBSHg7Rkx/SlSreZdVsz1iBrXLI2QwswZwbvOm9t30qtG8+UWJKAr291nYOs0eKoQa88MX88DPjmOtjCMJqAxgmueR1X71kidT+Tw76Dq+fZDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993209; c=relaxed/simple;
	bh=Dezv4ay4MVxjEt+9/1K+iUHZjlKKuG0SGsul2z+ElA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVGDSOEy0uTRapibFeof5mUETzFobTDta0UgKllrLMpEjZrPTYVO725yFLCMKWrY6UCgra6jHKNF6IN2LgytDEt+hd7LetVyHys7mMDSfILwhdxfg1K15C/E0aBsiEmU4TWfiRm7O9dYoeldoztUSmhBmRewfzFdogOhlhENwV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVFzF/rm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVFzF/rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E05EC4CEC6;
	Tue, 15 Oct 2024 11:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993208;
	bh=Dezv4ay4MVxjEt+9/1K+iUHZjlKKuG0SGsul2z+ElA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVFzF/rmkB+0RmhTD380d5Y16aNrdUpA4rsfCINXSeTQU1tG/VeHPRZeBqHlJUZnG
	 O9sjxdOv69b9odgtXcpBb1d3C+Gcr6ltVCLePiskPKgy80gawkvuVRmQKTjVEsrj7R
	 cB14/+EY1AdT7qX5mvsnsShs4cUzqgHgZaSVDJ48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 342/691] hwrng: cctrng - Add missing clk_disable_unprepare in cctrng_resume
Date: Tue, 15 Oct 2024 13:24:50 +0200
Message-ID: <20241015112453.914578238@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -665,6 +665,7 @@ static int __maybe_unused cctrng_resume(
 	/* wait for Cryptocell reset completion */
 	if (!cctrng_wait_for_reset_completion(drvdata)) {
 		dev_err(dev, "Cryptocell reset not completed");
+		clk_disable_unprepare(drvdata->clk);
 		return -EBUSY;
 	}
 


