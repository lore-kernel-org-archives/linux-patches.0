Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40001DF73C;
	Tue, 29 Apr 2025 17:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946547; cv=none; b=kl5xCvHyYkU/rfrf00E+Gt7jlziBNevfncB9xkIzwqn0ezpTyafaWi+AiOB7cxK33UT5BQKwgu+cHvbEbzspjfqRPN8EmLwg4fg8iaB6iZ3f4NlOBcEu7vL6saGuZvK2eTMpp9WytxXRvRNhnM1efZqqc5LYBuvrbk1Jul8EQ1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946547; c=relaxed/simple;
	bh=/Uk6irhhN/6yJvQUK0RoYStfczVZkfABxiO0kztV0ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qjO9dJgPbfAcwt18Muh+pSOV1vE2/lBykOTAn3jXqnXVUJQzowV/wqjEz04MpLeUKIrwHvMzcxI4ETykEZ17/ph1zk8u7ZOJpQ/7B3TmQxl5YEir6/0PdCt9hjjxHlYxdNoznc/GY4ei2eBpcqy9J+nhOoRNJuBuJzuxwGH5RI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vhkqgktx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vhkqgktx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D122BC4CEE3;
	Tue, 29 Apr 2025 17:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946547;
	bh=/Uk6irhhN/6yJvQUK0RoYStfczVZkfABxiO0kztV0ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhkqgktxJMS04et12RhzzXV6hYjrxafv9bggtpgCxlHFEYtUQaxVEqxt4cK+yFb5L
	 86cBHjuRl5CYiSsgGkHtD/DPue9c64EwYA7wKgefeij1JUUJTwvX09VMCw3MGjzUHy
	 l0wqiMYHA0CmabOa3BoqJ1PmZJylmPVnRUZX4WPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 302/311] media: i2c: imx214: Fix uninitialized variable in imx214_set_ctrl()
Date: Tue, 29 Apr 2025 18:42:19 +0200
Message-ID: <20250429161133.371587561@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 38985a25682c66d1a7599b0e95ceeb9c7ba89f84 upstream.

You can't pass uninitialized "ret" variables to cci_write().  It has to
start as zero.

Fixes: 4f0aeba4f155 ("media: i2c: imx214: Convert to CCI register access helpers")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: André Apitzsch <git@apitzsch.eu>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx214.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/imx214.c
+++ b/drivers/media/i2c/imx214.c
@@ -840,7 +840,7 @@ static int imx214_s_stream(struct v4l2_s
 {
 	struct imx214 *imx214 = to_imx214(subdev);
 	struct v4l2_subdev_state *state;
-	int ret;
+	int ret = 0;
 
 	if (enable) {
 		ret = pm_runtime_resume_and_get(imx214->dev);


