Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70B8657A2;
	Tue, 23 Jan 2024 00:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971525; cv=none; b=mFoPwpuQvEXKhwW7yjiDH55EZCmaBiUXjus+1AuNPErx38NOSMmQQRgYYF6UFF+xWxMrIChc/kDuV58vHLeA/iQV4zMrCL9hAiRmDfd0UsHiF+6bu86k+WvvuOOYPtG0nR7ebkLhKW+lT2t6kb8L6HmcGwH6UGHqNwu6bCvMDmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971525; c=relaxed/simple;
	bh=Oi3ey0wLX0QMs7AkVjVtbPkzRY+O8KWrwbh95ziD8mM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgACzJOhaI8iEzczDuLkLoUcusnLUH52xUSQSqeMjoTDoT5XKu09sYne9Ghd4oFHq8cnO6UrmdDoZSKKpbepJjdJPimtq7GNgqk0JYKN2pf12oxcYRSF6f+bG3tPAY9YSjPk+yPRjjG9ZE2Ah3p0jLkL9GyAEIgA9fsXVzeBczw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HK7VfH37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HK7VfH37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F1BC433C7;
	Tue, 23 Jan 2024 00:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971525;
	bh=Oi3ey0wLX0QMs7AkVjVtbPkzRY+O8KWrwbh95ziD8mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HK7VfH37idZxbdECZCIGwOpLMBNGj5IfGpXj5vBs7PH5C1ZYLzhqWOXsk3wquiCjL
	 +MYbPWhYP6CDRr8DJflzN4whJY5Gn9oB4E+TIFJSwV6DyY1ZzQsxp4PupJ5X+wV1N6
	 fEBRLkkAGtN5aK9lPDoplIpgJwp+SbYd2zeU4VvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Dafna Hirschfeld <dafna@fastmail.com>,
	Paul Elder <paul.elder@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/286] media: rkisp1: Disable runtime PM in probe error path
Date: Mon, 22 Jan 2024 15:57:52 -0800
Message-ID: <20240122235738.570450085@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 13c9810281f8b24af9b7712cd84a1fce61843e93 ]

If the v4l2_device_register() call fails, runtime PM is left enabled.
Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Dafna Hirschfeld <dafna@fastmail.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: 452f604a4683 ("media: rkisp1: Fix media device memory leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkisp1/rkisp1-dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/rkisp1/rkisp1-dev.c b/drivers/staging/media/rkisp1/rkisp1-dev.c
index 06de5540c8af..663b2efec9b0 100644
--- a/drivers/staging/media/rkisp1/rkisp1-dev.c
+++ b/drivers/staging/media/rkisp1/rkisp1-dev.c
@@ -518,7 +518,7 @@ static int rkisp1_probe(struct platform_device *pdev)
 
 	ret = v4l2_device_register(rkisp1->dev, &rkisp1->v4l2_dev);
 	if (ret)
-		return ret;
+		goto err_pm_runtime_disable;
 
 	ret = media_device_register(&rkisp1->media_dev);
 	if (ret) {
@@ -538,6 +538,7 @@ static int rkisp1_probe(struct platform_device *pdev)
 	media_device_unregister(&rkisp1->media_dev);
 err_unreg_v4l2_dev:
 	v4l2_device_unregister(&rkisp1->v4l2_dev);
+err_pm_runtime_disable:
 	pm_runtime_disable(&pdev->dev);
 	return ret;
 }
-- 
2.43.0



