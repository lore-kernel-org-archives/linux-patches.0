Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4994347CC7E;
	Sat, 28 Feb 2026 17:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301327; cv=none; b=tdpl5FPL1MG+og/qTL+axwmPsXe4LTlLiR/TPj463Xg2l9QxelbLEhmoY3icygbPLzKE8NGeNmjfclJ8XydlWn85fdFrWY0K67QUHswKXMAe9nAb+WJSxxudDvkJdMFm4mTRzDmBKls7F3LquRLGCmBSTjVAsaGXsenGAI+dUL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301327; c=relaxed/simple;
	bh=7ZjK1K5DPPtbZAf9IBn6TSSixWGIqv2i6ZRB9f1FDns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THtj1Zkyejgv4/lUAkpcJzuO5mQH2E4nJvn4r/bVvijDrqLxvLi1F/RXFL1B8dDBVSqBeGWbnglaw0HLeZUwgwElk1bwktxonGuMMr9YCvSmzjX2hISok+a5W3C7rZKYaI/Wrv7j2+bDJuOhAr2rfxSgBXQOIH00lXJ1n/c6Ik8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H0jNTLk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H0jNTLk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954A7C116D0;
	Sat, 28 Feb 2026 17:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301327;
	bh=7ZjK1K5DPPtbZAf9IBn6TSSixWGIqv2i6ZRB9f1FDns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0jNTLk2bG1NqXbibh1gS6qIFpMJdlUjqYghoedPChFoS8rxjLBvAXfD4DI116qyX
	 Ml9qhK3dD8d78hJFHzGXx7VbNE/Fc/BQO0jzJSSW5Hx98r6tE6mY+//AVxB19YLIBy
	 xXbGL9X+6xFmNiAii3lJiV22J+1nyawfjh54tM6kc2vx0G5IOx2B4BAtgvp4BSDQAO
	 DbLb713xyxt7ppalkB+G63TLn+n7QOTa3HKTtJGe3r2OYbfYorzVnrHbe+/oGOG7ID
	 88kcyHU8y6OQaG6vUqScCioo9FBxNqX3ppp6quJl7EPzNC5uQ3XSLZ55Jcsp4yRtt4
	 BSny4SiURJSYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	stable@vger.kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 514/752] media: i2c/tw9903: Fix potential memory leak in tw9903_probe()
Date: Sat, 28 Feb 2026 12:43:45 -0500
Message-ID: <20260228174750.1542406-514-sashal@kernel.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 9cea16fea47e5553f51d10957677ff735b1eff03 ]

In one of the error paths in tw9903_probe(), the memory allocated in
v4l2_ctrl_handler_init() and v4l2_ctrl_new_std() is not freed. Fix that
by calling v4l2_ctrl_handler_free() on the handler in that error path.

Cc: stable@vger.kernel.org
Fixes: 0890ec19c65d ("[media] tw9903: add new tw9903 video decoder")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tw9903.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/tw9903.c b/drivers/media/i2c/tw9903.c
index b996a05e56f28..c3eafd5d5dc82 100644
--- a/drivers/media/i2c/tw9903.c
+++ b/drivers/media/i2c/tw9903.c
@@ -228,6 +228,7 @@ static int tw9903_probe(struct i2c_client *client)
 
 	if (write_regs(sd, initial_registers) < 0) {
 		v4l2_err(client, "error initializing TW9903\n");
+		v4l2_ctrl_handler_free(hdl);
 		return -EINVAL;
 	}
 
-- 
2.51.0

