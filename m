Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF7924EF74;
	Mon, 24 Feb 2025 14:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408080; cv=none; b=Sn4jKyCEdIp4gKiXFIAaaXDgkYUBRYZ2BiVlZMfLHKo+sasTnqoi+DQQ+C8ekCRIsyHcChPSDy/zYaLGtqlpVNg6OXGFXmUXxXoKlYOK2HSkALyCDBoKpqUq25hM0n8TJktlEXNssHyxDBlREA6uaclg3o/I+RjBranSHFgkzgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408080; c=relaxed/simple;
	bh=weYpjvuyAHbYVGzfcVx6LDvFAXZO3VytMbSjm0toSLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYirXFOGdz+KGVJepfUrUImPXxuJZp+4isghPDW1awPnbjhPkE/t4UOwOBYxLHIR4BdulPWeO1Qrx3jnI4o49MEB3klk4FE9J8yj7KKHyIaWMxf1+QBzkIsLHpiBbzKQ0MvjZDCHjaQMbYC6jZQhqsuI+WPQzjOvZFIZPLbJalU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zauRuSbO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zauRuSbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4402C4CED6;
	Mon, 24 Feb 2025 14:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408080;
	bh=weYpjvuyAHbYVGzfcVx6LDvFAXZO3VytMbSjm0toSLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zauRuSbOYiGiAICteGghItt8BNEH8/kW55BFlmJYP9p73Jjmljw8suMTnXqtOmrQ9
	 jCn2a23Y8qzMqskT08WyOBDBaMjreIdtiZjPLyYXG3GdoxW9O34lpYf7t22mwhkzIz
	 sv8MH3UHb7zzIPXJL4z78ks6WyACtil+H0GuXAm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/140] drm/msm/gem: prevent integer overflow in msm_ioctl_gem_submit()
Date: Mon, 24 Feb 2025 15:34:52 +0100
Message-ID: <20250224142606.669455071@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 3a47f4b439beb98e955d501c609dfd12b7836d61 ]

The "submit->cmd[i].size" and "submit->cmd[i].offset" variables are u32
values that come from the user via the submit_lookup_cmds() function.
This addition could lead to an integer wrapping bug so use size_add()
to prevent that.

Fixes: 198725337ef1 ("drm/msm: fix cmdstream size check")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/624696/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 207b6ba1565d8..018b39546fc1d 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -885,8 +885,7 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 			goto out;
 
 		if (!submit->cmd[i].size ||
-			((submit->cmd[i].size + submit->cmd[i].offset) >
-				obj->size / 4)) {
+		    (size_add(submit->cmd[i].size, submit->cmd[i].offset) > obj->size / 4)) {
 			SUBMIT_ERROR(submit, "invalid cmdstream size: %u\n", submit->cmd[i].size * 4);
 			ret = -EINVAL;
 			goto out;
-- 
2.39.5



