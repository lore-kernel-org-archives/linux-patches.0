Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B16387379;
	Tue, 10 Mar 2026 11:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141069; cv=none; b=QLM6zNBY1RAEo7zTDW0c85LYY2Mv3S/rw8ykmzXEVwGZiWaVBjFuazssDt/P0fL2M9CLYrEnV7oMtrjkOXK4DHzrr65N5IQ9Sl1bFtUEHu3jx8FsZXQ81IexxY98JJDRgC3HIk+2ejGk9INFDErS0HkotkJFaT6AjkbLCQRdXRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141069; c=relaxed/simple;
	bh=75uQKiEqPk0+2/ZkqrB2GSYPQ3tvBpPthpZBU+7h0pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZCWi0U5NtlQU6flDjG8vlikv3oue+849+vsLuYhJk6WQwo7YY7e8U3+pD9aJLUqiVhYq/tbrV3ZP0bB0d5rWgh/ZW3a6BzyKbETtXGFA2qVwDrEdN3plJ0hXu+LaP2a+nsXB4ZgDlNP2WNxLUIfSTyEhbcZpnbXK9YcTU3Bc3uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fHUo1Y8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fHUo1Y8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7745C19423;
	Tue, 10 Mar 2026 11:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141068;
	bh=75uQKiEqPk0+2/ZkqrB2GSYPQ3tvBpPthpZBU+7h0pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHUo1Y8f7Yz0RV790PAo4vvOobOVzsLqocn8B94SzEnZFbe7JxhcvlED7qrpg7wwD
	 2QlYUmzQtKBM5ef/faM38igemKTTI0Do3s8xae0xNSh7tT4y2F8hpLJQnmC1j4bdD1
	 uv93OtYi1SvNZuUQBUYU72tI5lua+56UGUV8oVZkb7X5Qy0BUPRLfH/v2ZtupYQ72j
	 BDbbY/5loxdHSVFKmRkukCvvpVKCMSXmFkLlCjzNrl8u1FJqWnLQChZZEZS+oj/HhM
	 WRicK+fRe6zSOqw0NS5qAMEcXypUq6V0BRk/cOB39atZM6OcE7r4ypRyiRmMdhAEY3
	 S2lS56nQS0ISQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 068/311] drm/amdgpu: Unlock a mutex before destroying it
Date: Tue, 10 Mar 2026 07:01:55 -0400
Message-ID: <b65146ca288a317d07c91fb04371bce2cdc9aeac.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 5e0bcc7b88bcd081aaae6f481b10d9ab294fcb69 ]

Mutexes must be unlocked before these are destroyed. This has been detected
by the Clang thread-safety analyzer.

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Yang Wang <kevinyang.wang@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: amd-gfx@lists.freedesktop.org
Fixes: f5e4cc8461c4 ("drm/amdgpu: implement RAS ACA driver framework")
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 270258ba320beb99648dceffb67e86ac76786e55)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
index 9b31804491500..3f9b094e93a29 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
@@ -641,6 +641,7 @@ static void aca_error_fini(struct aca_error *aerr)
 		aca_bank_error_remove(aerr, bank_error);
 
 out_unlock:
+	mutex_unlock(&aerr->lock);
 	mutex_destroy(&aerr->lock);
 }
 
-- 
2.51.0

