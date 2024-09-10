Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA00317C220;
	Tue, 10 Sep 2024 10:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964729; cv=none; b=BO4JMKO8/Z/X7C35YUWKWT6rJbu+USlkGS4ETanqqpV/wD6l5aVqOhdxVZDKF30PgM120eaA/SG61NVdHzeMxbraRSgWuS+StTsObnBJ2UBYq2IhEUIUq00bRufCI6pyil+9qe1ExXulvfZ26HiVzEBY4Fu96MNRflwjH9vHvp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964729; c=relaxed/simple;
	bh=llK0AIrJ+0Udu8TzPYc3q+5MZbiLnQpL9NHwinwWNZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tQQmmCRQmghl93LI/jVzIHD8LVbdQrrgYBEBJHCSvW7MHWI8V0gDZ6BirX9JsgxcHIgxuqQgHGaQEzdQ13S9BIJi/Gd2OKiTSEYl/BugCHIoliEnVZlOe1BAMF7NSq2A7iK7LmZ0fC7qddOheW+D0D+5wf+etGfVvSlPXH7yKoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/BvJKLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/BvJKLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F51C4CEC3;
	Tue, 10 Sep 2024 10:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964729;
	bh=llK0AIrJ+0Udu8TzPYc3q+5MZbiLnQpL9NHwinwWNZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/BvJKLHeWdgdKgLNZPNnyRIUhmBfp+Lq6zTl6DquAPwUQ/2R6mExhXp4xHT8p/7l
	 3U3pu2OJ1KKsd2ywlM2C5yAgf30JnzpFV+iywjmdhgo+ugjngZJGaMTtuShSDtCjZf
	 Mgw+3BUkNqzEoN2Sk95rehzIXHyFw5FgxMhIug74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/186] drm/amdgpu: fix uninitialized scalar variable warning
Date: Tue, 10 Sep 2024 11:31:47 +0200
Message-ID: <20240910092555.156905260@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 9a5f15d2a29d06ce5bd50919da7221cda92afb69 ]

Clear warning that uses uninitialized value fw_size.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index d6f295103595..bd53844a8ba4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -404,6 +404,8 @@ static void amdgpu_virt_add_bad_page(struct amdgpu_device *adev,
 	uint64_t retired_page;
 	uint32_t bp_idx, bp_cnt;
 
+	memset(&bp, 0, sizeof(bp));
+
 	if (bp_block_size) {
 		bp_cnt = bp_block_size / sizeof(uint64_t);
 		for (bp_idx = 0; bp_idx < bp_cnt; bp_idx++) {
-- 
2.43.0



