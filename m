Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EDB1AF0AC;
	Tue, 15 Oct 2024 13:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997481; cv=none; b=OtSnrOA9+0A9HVyqJBv+UnfVWdx5ZQft2nctGPgFi4vWITJRtT3IU74FRbefLpu/7/IQBTW5hlBIBJmL1JODyo9r7wLD8Gbc6rKj6JSCpBxCf9S98zUCrhqp9XnR18+PJzz3CSa6bfkzZfSk1eQ+XCLXAWMiBHqxOMJ5BRDhlOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997481; c=relaxed/simple;
	bh=u0MmMAWqB9PpyRiukTtT6BuI5WwTws8x6D/Flrh7uFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sL4EfhTZEvkxVsaUfE2GXBFDDOgtfh0MCBsilUBCm8d8Z1bDXlt9wtcG4e5tfzRyWIA8nBqXgEKsBcfIBDsFN+kvxDS9aRPr4qCSLxIe332Y/kLeIPHAYrAYr8m/M8s+xETfUgASyzqaSrPBPKhXgbGGJ1HU2snykmxkju9d4ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTF9xxki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTF9xxki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AB7C4CEC6;
	Tue, 15 Oct 2024 13:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997481;
	bh=u0MmMAWqB9PpyRiukTtT6BuI5WwTws8x6D/Flrh7uFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTF9xxkiEYmUWNivU7nqaU5MBMjHePrimwTgrfLdpZdxhXUpOp55HnCGrfE8QPXjr
	 rw9g6GsQsFL5N+RUfNApU3FhqP/qCQzVz0DXoXU8F4g1gwE6D7fAjZuKFI9UG/G0Yy
	 JoFw3Rhb38X0d0nDqV+HsbXcbTCbMXd9uYq5eg8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/518] pinctrl: single: fix missing error code in pcs_probe()
Date: Tue, 15 Oct 2024 14:41:12 +0200
Message-ID: <20241015123923.479276615@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit cacd8cf79d7823b07619865e994a7916fcc8ae91 ]

If pinctrl_enable() fails in pcs_probe(), it should return the error code.

Fixes: 8f773bfbdd42 ("pinctrl: single: fix possible memory leak when pinctrl_enable() fails")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/20240819024625.154441-1-yangyingliang@huaweicloud.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 5b76594b535c1..22fd7ebd5cf3f 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1923,7 +1923,8 @@ static int pcs_probe(struct platform_device *pdev)
 
 	dev_info(pcs->dev, "%i pins, size %u\n", pcs->desc.npins, pcs->size);
 
-	if (pinctrl_enable(pcs->pctl))
+	ret = pinctrl_enable(pcs->pctl);
+	if (ret)
 		goto free;
 
 	return 0;
-- 
2.43.0



