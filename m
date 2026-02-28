Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC120175A77;
	Sat, 28 Feb 2026 17:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301380; cv=none; b=ebJW5YAs4FWXCOCO7Hcaloa55IyW9pXZV4cf6Jhw/bu9lF+CT/nrTF7u9eQCIlTsFViYjfiKnoGhMZWxPLAQkAZ5yp3iqxyTUAcAiMGZJz3xLSS6TQp4Xi1dDDOEMH8CNtiAFuoj1nbOzAakjV8aiC+P0ffFSaI1nUQcwk/BQnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301380; c=relaxed/simple;
	bh=cSuVU974g3l3QQC7Di7ijzpXO4HFzpaAUkFh7Dv08QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrGS7N69XTCWaqrnCnIOgSuzBBZh2gsPCX+kDgxqhbmT5ylcVnZ7wH1oIFiQ8XIbNvcb4tNpzFIX7FdELIeeKe+OM1ODREdYiYF1NPAaVhlOXJHo1uR/CgpTo1N5T9BE+bnMh5qf6Hr9zXDzn4huWmduZlwythnXIXvWcD+3fOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZTYuUlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZTYuUlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA52C116D0;
	Sat, 28 Feb 2026 17:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301380;
	bh=cSuVU974g3l3QQC7Di7ijzpXO4HFzpaAUkFh7Dv08QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZTYuUlYhYU0I9vls+wsCah0qwn9Dy+F557zdTA7yVb/220MOFp9hm2q4D9LLI+PK
	 TGZ/G2Ll/tJHRJiqTaa8F/GfMgS4qRWW/YFyPEehGv3z1v5VC4tz8SLRn7LKpx58U9
	 GDf6twhUknrs82bvyxwRgAQ6b5kguUvqeZS0G4F8hionQwe7NtySR1x/M+Pj1WMzcN
	 mdNStV9PtAUk3rWOkqyGc2KyA3n4LnFrdS3spIkTlKIELd/Uuz0O8szzULHsrN2fTN
	 xwI33us2FoGp6ocrjfjtClL2AfGSiM8I+4cJC7S1lPLxcaiQ2cC6CzFEGFH7W8WG9G
	 11hkvkoTZRXvg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Val Packett <val@packett.cool>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	stable@vger.kernel.org,
	Bryan O'Donoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 569/752] media: iris: use fallback size when S_FMT is called without width/height
Date: Sat, 28 Feb 2026 12:44:40 -0500
Message-ID: <20260228174750.1542406-569-sashal@kernel.org>
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

From: Val Packett <val@packett.cool>

[ Upstream commit 4980721cb97d6c47700ab61a048ac8819cfeec87 ]

According to 4.5.1.5 of the M2M stateful decoder UAPI documentation,
providing the width and the height to S_FMT is "required only if it
cannot be parsed from the stream", otherwise they can be left as 0
and the S_FMT implementation is expected to return a valid placeholder
resolution that would let REQBUFS succeed.

iris was missing the fallback, so clients like rpi-ffmpeg wouldn't work.
Fix by adding an explicit fallback to defaults.

Fixes: b530b95de22c ("media: iris: implement s_fmt, g_fmt and try_fmt ioctls")
Link: https://github.com/jc-kynesim/rpi-ffmpeg/issues/103
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Signed-off-by: Val Packett <val@packett.cool>
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_vdec.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/qcom/iris/iris_vdec.c b/drivers/media/platform/qcom/iris/iris_vdec.c
index ae13c3e1b426b..c9f9c16cf0846 100644
--- a/drivers/media/platform/qcom/iris/iris_vdec.c
+++ b/drivers/media/platform/qcom/iris/iris_vdec.c
@@ -196,6 +196,14 @@ int iris_vdec_s_fmt(struct iris_inst *inst, struct v4l2_format *f)
 	if (vb2_is_busy(q))
 		return -EBUSY;
 
+	/* Width and height are optional, so fall back to a valid placeholder
+	 * resolution until the real one is decoded from the bitstream.
+	 */
+	if (f->fmt.pix_mp.width == 0 && f->fmt.pix_mp.height == 0) {
+		f->fmt.pix_mp.width = DEFAULT_WIDTH;
+		f->fmt.pix_mp.height = DEFAULT_HEIGHT;
+	}
+
 	iris_vdec_try_fmt(inst, f);
 
 	switch (f->type) {
-- 
2.51.0

