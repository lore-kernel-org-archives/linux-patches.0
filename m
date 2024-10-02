Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5013E1D0412;
	Wed,  2 Oct 2024 14:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878961; cv=none; b=VCxVVA3P3tct+S++moK+LeFNBQhK/U7hTsYUIbr/d7YatsEuqzcNVCg8ApwQnPrgkva/VmKKmh6g+T4ewJ8DtVBD5KXFtBnpUPeCQ3trHBxOCf9uSauxWqBpfByGmwQeLqT7KjcLdOOTUZio1JGDchXayUVzEfgemIFgCGoGrlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878961; c=relaxed/simple;
	bh=JPM1hEGeMX1h755RDKT9UxlsXrKsQKMGFgG6G04++0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pi0WxWvykfK3Vmi6CR+SgsHKhk4L+PRltsEPC/peRAQSkaspo2jHtidVz3UGulqzaXshZPjfRe++bPSIoB3j5VX6v1EVJ6/XP8gni0pXo+dwsqbCLAcyHFaZsTEbCUGyjGMkmB8lU6Rn3bjZhtJ/g0xx0c5IliIUJJURIQUsnZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNYbq9yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNYbq9yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB9CC4CEC2;
	Wed,  2 Oct 2024 14:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878961;
	bh=JPM1hEGeMX1h755RDKT9UxlsXrKsQKMGFgG6G04++0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNYbq9yymZiq7TXol2N5xmtrrbl1iFEi3vp70dmw8AkEQUxCpz0JIQk5ZK8ddgucR
	 xcldPTYR5+ONAITpX8YSi2Zs6pJ8MiRJInfQvp9yo03+du6dnwinebB6gGwqNy+6SQ
	 4GqNL3RqyqbxdM1XY8LIjnSpm7KYBZhpXyh32Mh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 591/634] soc: versatile: realview: fix memory leak during device remove
Date: Wed,  2 Oct 2024 15:01:31 +0200
Message-ID: <20241002125834.442295747@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 1c4f26a41f9d052f334f6ae629e01f598ed93508 ]

If device is unbound, the memory allocated for soc_dev_attr should be
freed to prevent leaks.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/20240825-soc-dev-fixes-v1-2-ff4b35abed83@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: c774f2564c00 ("soc: versatile: realview: fix soc_dev leak during device remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/versatile/soc-realview.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/versatile/soc-realview.c b/drivers/soc/versatile/soc-realview.c
index c6876d232d8fd..d304ee69287af 100644
--- a/drivers/soc/versatile/soc-realview.c
+++ b/drivers/soc/versatile/soc-realview.c
@@ -93,7 +93,7 @@ static int realview_soc_probe(struct platform_device *pdev)
 	if (IS_ERR(syscon_regmap))
 		return PTR_ERR(syscon_regmap);
 
-	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
+	soc_dev_attr = devm_kzalloc(&pdev->dev, sizeof(*soc_dev_attr), GFP_KERNEL);
 	if (!soc_dev_attr)
 		return -ENOMEM;
 
@@ -106,10 +106,9 @@ static int realview_soc_probe(struct platform_device *pdev)
 	soc_dev_attr->family = "Versatile";
 	soc_dev_attr->custom_attr_group = realview_groups[0];
 	soc_dev = soc_device_register(soc_dev_attr);
-	if (IS_ERR(soc_dev)) {
-		kfree(soc_dev_attr);
+	if (IS_ERR(soc_dev))
 		return -ENODEV;
-	}
+
 	ret = regmap_read(syscon_regmap, REALVIEW_SYS_ID_OFFSET,
 			  &realview_coreid);
 	if (ret)
-- 
2.43.0



