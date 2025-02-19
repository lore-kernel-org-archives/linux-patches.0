Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC721BEF71;
	Wed, 19 Feb 2025 08:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955347; cv=none; b=NWtY1sklULtleEKBabKeDEBh493VyXy2/6nkYlEsReFv9AWb9hvx6eUmbgW7bmek9aacQox1vI7wplDNgTVcR1374jw7dwaPR5MZnST496heDmhclYOn5cuKiky05c8MqOUlP45JBGnVuDflzvbawUbGJ4Bxh23iYKV6xDh3zio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955347; c=relaxed/simple;
	bh=qh8kiksmJcxK8BzaTMLT5WEARyIUzA75TYRotJhDA5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzmvEL7EuLWxqop7mLpMD9S3mtNZOHdfrL+3/iRbcVj2KfTlZgroR5Iqqkk8yciAKFfd6roEmzRp6060U6eBXG8KLnJp31z9bcH1fY6Yyx4AkWlFJh0KRcup4CFIwgTaaPIduJGOAdUT4bXd87mYHq8jA4RbKJUmd2B+6Ik+igM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I06HNcI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I06HNcI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEA4C4CEE7;
	Wed, 19 Feb 2025 08:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955347;
	bh=qh8kiksmJcxK8BzaTMLT5WEARyIUzA75TYRotJhDA5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I06HNcI8owk6TRcMJfZYDCK3tmpzbQ2LsP8284lzHL0c8a6WDmFVyCpR6Bgn81Z6/
	 h6eLauT1cS/6uDktlwkCZRpDlGpNDiBaNvgQTcEuCHktzx8k8cmWyHwg3eVAzcYgq3
	 AIUVpM3eHTaeVhNWPt7Pu2JY6xNllPSUiyiH/ATQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rob Clark <robdclark@chromium.org>
Subject: [PATCH 6.12 208/230] drm/msm/gem: prevent integer overflow in msm_ioctl_gem_submit()
Date: Wed, 19 Feb 2025 09:28:45 +0100
Message-ID: <20250219082609.830190894@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 3a47f4b439beb98e955d501c609dfd12b7836d61 upstream.

The "submit->cmd[i].size" and "submit->cmd[i].offset" variables are u32
values that come from the user via the submit_lookup_cmds() function.
This addition could lead to an integer wrapping bug so use size_add()
to prevent that.

Fixes: 198725337ef1 ("drm/msm: fix cmdstream size check")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/624696/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -787,8 +787,7 @@ int msm_ioctl_gem_submit(struct drm_devi
 			goto out;
 
 		if (!submit->cmd[i].size ||
-			((submit->cmd[i].size + submit->cmd[i].offset) >
-				obj->size / 4)) {
+		    (size_add(submit->cmd[i].size, submit->cmd[i].offset) > obj->size / 4)) {
 			SUBMIT_ERROR(submit, "invalid cmdstream size: %u\n", submit->cmd[i].size * 4);
 			ret = -EINVAL;
 			goto out;


