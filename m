Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CAA152160;
	Fri,  6 Dec 2024 15:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498556; cv=none; b=uKzoLUWbGbx2VlMTK111Gv/d1u7Gl4RSCZLLYGq90qfpVnXUjM3I3bjmg9wcOiGZi8l7IyfSbhRTba3/i4P3VGEQX03BCA0lsnl3+xWCWeMgSZH6GkIMTH5T4jf3vj9j6GbO2NTXVJ8inOtNzvCJutHI4Q0gJnFkveBQIUde6v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498556; c=relaxed/simple;
	bh=M/lem3HKmbSwAaj8JA6ChMU30VOooEiw/idzKp8qAnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKj3K/RbZbfSVngmkafBq8HcbdaideUq3wdkF26GamVzC9b/Ou9UVKUlLq0vsevmZgAuuygS7GLYylBZov8lGGGMl8pjRZTU6J5O1QPRUWCC2J14Pl3I7BHoA4tPoo6Yn+rEq4a5uoZhwvqter8OEeQwTMgK0AQbzF/4nJfWqS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzvWw3Yw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzvWw3Yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CFDC4CED1;
	Fri,  6 Dec 2024 15:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498556;
	bh=M/lem3HKmbSwAaj8JA6ChMU30VOooEiw/idzKp8qAnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzvWw3Yw5Boex8c1gIPgwJy3ZpxDin+xWUX9lupjNFQrxahYfM/oBmQXnQnIUkxaL
	 Ea25q5x9YWgfGF2KehCcSZcrYti5QzQRjumh2ZQ5SvEQXBAn7OKceHlz7I4RVfEDEa
	 9UaB2tDtTG7we3NTwfzbomrUus/2lLJ2SoVZaNxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 618/676] media: platform: exynos4-is: Fix an OF node reference leak in fimc_md_is_isp_available
Date: Fri,  6 Dec 2024 15:37:17 +0100
Message-ID: <20241206143717.509959501@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
@@ -178,8 +178,9 @@ int fimc_md_set_camclk(struct v4l2_subde
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


