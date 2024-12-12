Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9862253EB;
	Thu, 12 Dec 2024 16:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020421; cv=none; b=ur8I26mUQFlavoflWDbkVf87R+Q4QgkMBm0mlS9Cwa43AW4YaqRGON6Tk0uu3FJ1X9L8HobVd86iB+YZcQHWFiWYzvSPk+y5xKpvIktjh8khNKGvlKLCJb94Mo67EJPf6rbcjSM60wyYDlPIZVQX5RQz04Jr81wX2GZuf8/4UwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020421; c=relaxed/simple;
	bh=LUb+3qtXbBmw/8523krhXWAcZ6n9iZA+0AHa4cyp+7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=av7mQnX8cUKHXy0tzZvg8ZTfrom+WPy2KE/GqWXY6I1VGyBi6GEOloyq1zlKjFxIZOYxt7Dv+m1dNQe8HopgrHsDpLh3ajTt0i6PFeIQO5RHLxmmRtCd7ahv8iUnan+5SEtvZcynOhoYmKF2VEBhnfjGXZRPM/dZXqhyPfrYtLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVNqz3IM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVNqz3IM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4272C4CECE;
	Thu, 12 Dec 2024 16:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020421;
	bh=LUb+3qtXbBmw/8523krhXWAcZ6n9iZA+0AHa4cyp+7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVNqz3IMW2VAjSIAJN01gPlZusUDzJbLkbfOcxZ6mY0mFJ896KYr5oZB89FkhLv+i
	 MoKPMfRpWdZSSVBfLTHTl6IVq1dii5H6YqcSDGO7on5zLYY1UqzizE6+9B4m2LmnVu
	 0yzCsRBJGP8SHh7vX2e30E5Gbqywn+kAQiXgOOwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 464/772] media: platform: exynos4-is: Fix an OF node reference leak in fimc_md_is_isp_available
Date: Thu, 12 Dec 2024 15:56:49 +0100
Message-ID: <20241212144409.107129854@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit 8964eb23408243ae0016d1f8473c76f64ff25d20 upstream.

In fimc_md_is_isp_available(), of_get_child_by_name() is called to check
if FIMC-IS is available. Current code does not decrement the refcount of
the returned device node, which causes an OF node reference leak. Fix it
by calling of_node_put() at the end of the variable scope.

Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Fixes: e781bbe3fecf ("[media] exynos4-is: Add fimc-is subdevs registration")
Cc: stable@vger.kernel.org
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[hverkuil: added CC to stable]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/samsung/exynos4-is/media-dev.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/samsung/exynos4-is/media-dev.h
+++ b/drivers/media/platform/samsung/exynos4-is/media-dev.h
@@ -179,8 +179,9 @@ int fimc_md_set_camclk(struct v4l2_subde
 #ifdef CONFIG_OF
 static inline bool fimc_md_is_isp_available(struct device_node *node)
 {
-	node = of_get_child_by_name(node, FIMC_IS_OF_NODE_NAME);
-	return node ? of_device_is_available(node) : false;
+	struct device_node *child __free(device_node) =
+		of_get_child_by_name(node, FIMC_IS_OF_NODE_NAME);
+	return child ? of_device_is_available(child) : false;
 }
 #else
 #define fimc_md_is_isp_available(node) (false)


