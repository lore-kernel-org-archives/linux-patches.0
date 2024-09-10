Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45B014F12C;
	Tue, 10 Sep 2024 09:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961039; cv=none; b=f70MU8o+r+ZQ6h1Ve85uO4ZjHpp7mJROxf+HDdlULqhT6Cb6tpIqzNegYeHvKOy/IXpDHAbaAZ3nNeVyvxJztUZFT03CGXh9i5bvWTCaBCkTwGVRTe/8MlCCpz9klNYqTMcL8hwRR7xFDfWf4wzo5QCCf8mSMzQpxjzK0iFES1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961039; c=relaxed/simple;
	bh=6O98lpNwImYTZ1PySULLJVbr8Xj5h77Z/Nuo2GoNXok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lRzP/IIht/GCIZ6t/ooknckCnLyujsK0fIndIku7vn4Rp3BUopFrDEZ90vnhZqMyCS2SqjZ99cWmPVVoq3mthsvSH23rjVDTf8FeKBiwKTsXV74vKmmP8QDbrXn/WZh7S34RrL9UPh2xONwwTufj92HaqGhMQR574qebF6qb2YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHs8Qem7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHs8Qem7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27986C4CEC3;
	Tue, 10 Sep 2024 09:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961039;
	bh=6O98lpNwImYTZ1PySULLJVbr8Xj5h77Z/Nuo2GoNXok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHs8Qem7NXmvLV7ebUc8569s0pTP1S7Tl4eGA9T+9+WHfRZfedWpQkL2WORFfKhA9
	 sQ9/3e992KRA2ilG0JYGB8ybh06iez8XGGADdNtIvPV9xkXNTnGhGXXL2xdp+IXmAS
	 q0OMxxlPXuDd60br4B+aWbnxy5BAzhFWUD1pYod0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/96] drm/amdgpu: fix overflowed array index read warning
Date: Tue, 10 Sep 2024 11:31:07 +0200
Message-ID: <20240910092541.622841666@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
User-Agent: quilt/0.67
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit ebbc2ada5c636a6a63d8316a3408753768f5aa9f ]

Clear overflowed array index read warning by cast operation.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
index 93794a85f83d..d1efab227034 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -497,8 +497,9 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
 					size_t size, loff_t *pos)
 {
 	struct amdgpu_ring *ring = file_inode(f)->i_private;
-	int r, i;
 	uint32_t value, result, early[3];
+	loff_t i;
+	int r;
 
 	if (*pos & 3 || size & 3)
 		return -EINVAL;
-- 
2.43.0



