Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757F9334C1C;
	Sat, 28 Feb 2026 17:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301336; cv=none; b=pHQJ20Hm1opEmPp3Sj9F7+IQXsambP2SBOKYZchZAxlsfl+Djxpe/Al8fwPUfHNPELegyqmzVxi74mDqaA7YsqMJGYc0bGaESrW6KX/hec7z4mtprHOmhdxjRf2MiqTjPWKGJ6v+1x44y/KW2BTTNxKdsTh9XxLnBJiY9kwbdtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301336; c=relaxed/simple;
	bh=3FwCpGhJHgA+yIG6ayoWS3s9ZGgabVkpEg264r22EiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhysFk2UlnjqjnjNyG4dj7Aah+TGOAk4yxUDtLf7CP5TE4QdAcPICn54qXCTcTfAgd1yhavM2Jtw+wK5jd8PJJTK2tHxn8z0FcZkLMeqMzNZPbmQ8qNsqnGwFqnupaEQDuq3itj3WqMzyvSpTsQHceunmZ6QaX8x4d3Fitr3/OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MaVJMcW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MaVJMcW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94654C116D0;
	Sat, 28 Feb 2026 17:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301336;
	bh=3FwCpGhJHgA+yIG6ayoWS3s9ZGgabVkpEg264r22EiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MaVJMcW34qOnASjPmccBFrb7iv3O+TYoc6JgUxBwwG/LoiViUEmqkZJarUZwXOKAd
	 zeWZhBS1EjkoiaQ0FbBYPmnSUrr7ihL/hkHuxYhqfalQzOKOoJwcJuweR6MJcRDPkY
	 tmFILRGOWPleGMpfLtLXP/HUV2j2+keWlH3kX9BPeHJQet6u3KGIxIqA0YDtznJomt
	 dymdtoM+cCC3UsPkCcF+6sjneO/rl6E17aZM3qciQJPtsteiea4RnAOczOp+QFglVA
	 fDkYSZjJEj3AW7RUWkwDvnMjmH2tG5A2jwtafN/OdesEzg9AzqR4vf1sk3/Pp7aKv8
	 ElroOrwGa3Z0w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	stable@vger.kernel.org,
	Nathan Chancellor <nathan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 523/752] media: ccs: Avoid possible division by zero
Date: Sat, 28 Feb 2026 12:43:54 -0500
Message-ID: <20260228174750.1542406-523-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 679f0b7b6a409750a25754c8833e268e5fdde742 ]

Calculating maximum M for scaler configuration involves dividing by
MIN_X_OUTPUT_SIZE limit register's value. Albeit the value is presumably
non-zero, the driver was missing the check it in fact was. Fix this.

Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
Closes: https://lore.kernel.org/all/ahukd6b3wonye3zgtptvwzvrxldcruazs2exfvll6etjhmcxyj@vq3eh6pd375b/
Fixes: ccfc97bdb5ae ("[media] smiapp: Add driver")
Cc: stable@vger.kernel.org # for 5.15 and later
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org> # build
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ccs/ccs-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ccs/ccs-core.c b/drivers/media/i2c/ccs/ccs-core.c
index 08e78f0bf2528..01ddfa332c700 100644
--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -2346,7 +2346,7 @@ static void ccs_set_compose_scaler(struct v4l2_subdev *subdev,
 		* CCS_LIM(sensor, SCALER_N_MIN) / sel->r.height;
 	max_m = crops[CCS_PAD_SINK]->width
 		* CCS_LIM(sensor, SCALER_N_MIN)
-		/ CCS_LIM(sensor, MIN_X_OUTPUT_SIZE);
+		/ (CCS_LIM(sensor, MIN_X_OUTPUT_SIZE) ?: 1);
 
 	a = clamp(a, CCS_LIM(sensor, SCALER_M_MIN),
 		  CCS_LIM(sensor, SCALER_M_MAX));
-- 
2.51.0

