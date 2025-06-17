Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E782E9738;
	Tue, 17 Jun 2025 16:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177051; cv=none; b=Lz+UMkCZcstdCd+8b6f8VgfXEBRzI8+B6nW/bSbLliCQ1I/EKXw8qwgrmsfhFpptcLcGm4D6MXCmNWIQdgPDxlSStcj0kZ/n8naiggenvTW29TeX6v+YV3KQSi4v1zxy9DBNc+VKVhyqYvs0O+zKQhV8zHk3PpXEbL6lgBHwUSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177051; c=relaxed/simple;
	bh=uVhy6bfhD6sM9nIvBeLCdyVKh7N9d+v8WVSyx3332PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNRobz/StaDqW3GwtN9hU2f7FusoHbAGZyYwhFkRXutfAtDouNZX0rqks5q828hjxlH7arj2WG9rLW1bn5rvRvGdJbGBSfeS3Nl0I+VEGjRGN03bDyOkwa/B9AuCKWf5hF+BvDm0+9/7OyRSYw3ND1EWe4e/eLK9CXhh2NKdUBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9XaTF4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9XaTF4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18050C4CEE3;
	Tue, 17 Jun 2025 16:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177051;
	bh=uVhy6bfhD6sM9nIvBeLCdyVKh7N9d+v8WVSyx3332PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9XaTF4PIRlRS2ws/zcHUbx4V8SFo6ttFQL+fprBUCqX3JxrILP1bGCz+t8hbTsI3
	 yvVjqbU5wfcT9OPTo/jU0UcSWXgYoJe+Aurw8seI1RmsRQSaGZPBafiKXGkvk7ag7P
	 40Cb5vs86ThVP9pBCqEBxJeKYg0NrbCVVWCAf9+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 292/512] mfd: exynos-lpass: Avoid calling exynos_lpass_disable() twice in exynos_lpass_remove()
Date: Tue, 17 Jun 2025 17:24:18 +0200
Message-ID: <20250617152431.433692997@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b70b84556eeca5262d290e8619fe0af5b7664a52 ]

exynos_lpass_disable() is called twice in the remove function. Remove
one of these calls.

Fixes: 90f447170c6f ("mfd: exynos-lpass: Add runtime PM support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/74d69e8de10308c9855db6d54155a3de4b11abfd.1745247209.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/exynos-lpass.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mfd/exynos-lpass.c b/drivers/mfd/exynos-lpass.c
index eedcfc22c3325..e36805f07282e 100644
--- a/drivers/mfd/exynos-lpass.c
+++ b/drivers/mfd/exynos-lpass.c
@@ -141,7 +141,6 @@ static void exynos_lpass_remove(struct platform_device *pdev)
 {
 	struct exynos_lpass *lpass = platform_get_drvdata(pdev);
 
-	exynos_lpass_disable(lpass);
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		exynos_lpass_disable(lpass);
-- 
2.39.5



