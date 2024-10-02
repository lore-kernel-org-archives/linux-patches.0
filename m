Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89A51D0487;
	Wed,  2 Oct 2024 14:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878897; cv=none; b=XEfmA6LeRfgyUZ1nfRNJl0Ofo105VOxLA6LKC5f7JaV4UMHGsNySnUhsQBJC6GsoXvMPzLh9eIdFYN+hKSYBVU2PMnDAb/svkXhYGIIJKz9Hra1FPm3QPkmnsjgmRjKma04CzXOH7wtKfUzRivHPGbauwtMh9xjlgc+/u7ngJ+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878897; c=relaxed/simple;
	bh=d5SiMG2agmkIvGSBmNC/TkBp6l8IG7/cNpPEjBao2Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JE8Olg1RsKaj4fwqxvkJKZTg/IjjPyYhhONYT3a7eQ65bB8TNtBY/DBx+7DsZ/Z5SA/gXJjyTS8aKGXPEBQRiZjuPMc1nEnJJ8weMpC1x7H2aSIG0ZK0N4y+0XEouyRYepWBGvN9Np5PwIMGj1Q2VWMKqWnbXNJg/23iOcMfS8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iK+W8QoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iK+W8QoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB41C4CEC5;
	Wed,  2 Oct 2024 14:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878896;
	bh=d5SiMG2agmkIvGSBmNC/TkBp6l8IG7/cNpPEjBao2Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iK+W8QoFVK1j0WkjYplNnZO7Z3a+ZcO+JnOiMqkmIrO7lv9/94qdwBIhxbRAAGrYi
	 Fw1cun/VoNGJ1vrTRSfjgzQO8Qk5mIzHKh1w75uO9bbmpPJIv/SfuWj0izQOPRjGca
	 CLgQKbLgRlVymuELzBwVBThW4sPgZMFs2Q1xzCH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.10 568/634] hwrng: cctrng - Add missing clk_disable_unprepare in cctrng_resume
Date: Wed,  2 Oct 2024 15:01:08 +0200
Message-ID: <20241002125833.536786366@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -622,6 +622,7 @@ static int __maybe_unused cctrng_resume(
 	/* wait for Cryptocell reset completion */
 	if (!cctrng_wait_for_reset_completion(drvdata)) {
 		dev_err(dev, "Cryptocell reset not completed");
+		clk_disable_unprepare(drvdata->clk);
 		return -EBUSY;
 	}
 


