Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A6C4E1D8;
	Tue, 23 Jan 2024 00:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970019; cv=none; b=bsH384buXhhffWUkO99AzASnq00gE0iFyTBuVa69VaZyYiUl3y8V+4Js7jIl0H5xe1MEJCxFkH3HsXOfjVS+64aUle1s55ovO+kkEqKHRiE4mscQPl72h+UGYfgn2MKnR3c0b9851rMWvOH2kFHJgVQXiQ3hqQdYjgOK1fT7kUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970019; c=relaxed/simple;
	bh=mqsi2sCtKo6BBY7n64iT+WXHZqxKjqGzuOEeoKYd3fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3iP8GDvlnnJE/qCLGPaKyCTpXadBqzdCt4o+/7gzlbkEgC7nyzPdv3djS/c1GFp36/7/hMXndWXryPEaLPFmhgWrSpNhoAT+QwSzCpR3O5YJK41Uc9SmK58o463rgHCk26CX1zyas2kS3Tl9owwyNVjwqpQt6mtd796JIh77w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OphbFqvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OphbFqvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71010C433F1;
	Tue, 23 Jan 2024 00:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970019;
	bh=mqsi2sCtKo6BBY7n64iT+WXHZqxKjqGzuOEeoKYd3fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OphbFqvgxEAEA74qvrouYV8zb1215+2k1Go7NIoIAoDeQnkx5nDe4JSUIe5YZ6J3Z
	 Cv//NMmIhtVWw1UorX9K+C87aQk1Lq4k7wMg+E0uBbdXX8DrMYpHzAmsNLsA8Ttezm
	 JUKSNGvATLTwGk71VeqcP2O6ZEmYNcXVG+7TzOJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 565/641] cdx: call of_node_put() on error path
Date: Mon, 22 Jan 2024 15:57:49 -0800
Message-ID: <20240122235835.843909426@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 87736ae12e1427bb2e6fd11f37b2ff76ed69aa0f ]

Add a missing call to of_node_put(np) on error.

There was a second error path where "np" was NULL, but that situation is
impossible.  The for_each_compatible_node() loop iterator is always
non-NULL.  Just deleted that error path.

Fixes: 54b406e10f03 ("cdx: Remove cdx controller list from cdx bus system")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
Link: https://lore.kernel.org/r/2e66efc4-a13a-4774-8c9d-763455fe4834@moroto.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cdx/cdx.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/cdx/cdx.c b/drivers/cdx/cdx.c
index d84d153078d7..40035dd2e299 100644
--- a/drivers/cdx/cdx.c
+++ b/drivers/cdx/cdx.c
@@ -572,12 +572,11 @@ static ssize_t rescan_store(const struct bus_type *bus,
 
 	/* Rescan all the devices */
 	for_each_compatible_node(np, NULL, compat_node_name) {
-		if (!np)
-			return -EINVAL;
-
 		pd = of_find_device_by_node(np);
-		if (!pd)
+		if (!pd) {
+			of_node_put(np);
 			return -EINVAL;
+		}
 
 		cdx = platform_get_drvdata(pd);
 		if (cdx && cdx->controller_registered && cdx->ops->scan)
-- 
2.43.0



