Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B54A1078F;
	Tue, 30 Jul 2024 16:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356809; cv=none; b=I5cLdOvmHDlsnfN1F9mwaKM3avpSDYNwuvICqLHgy6Ss3fyaIU+C9BQqaxhVBhBdicJlMst55aqlqXl1pkuPhSGe42hqfus4SkG4OXKgY3i+E5vq2fPHTcQWhAtjs+fxnCyH/Ap8lkYXezNi2SIHa5AtYDlJK812/WpQ/0NG7yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356809; c=relaxed/simple;
	bh=hqAccKhctMg1Sp4HjDiEExcxBaLSG7DDYUhIMvMp5bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NO83VWCW1YGcToHbtmXvMo4xrbzxibtvm6Vky8ugyFKN5mRCn9EkdreOyYkrjxC5kleUtJN2efk/fhduB3iPW3ATtbgOlfEaBDb5XU2/40CB/17F8eWMSkrP8RrF21RPlqJLQP1XQzCtAY5pYgjBaU08ln+Pg9gG4OZI3bqMq6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8TRNv8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8TRNv8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CE0C32782;
	Tue, 30 Jul 2024 16:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356809;
	bh=hqAccKhctMg1Sp4HjDiEExcxBaLSG7DDYUhIMvMp5bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8TRNv8TYq5bKOxwS3C9m0ewb39PfEk+ime6fOqBPkgbWT4NquQ4uwETgYlIvOTm9
	 6/1nYubkSvYFfxWm3hOCufM3VbyzLCIgpYN3y1yx5+UvNW7zGRPB+soqoP10TUkNjn
	 pYRG0Wn6lHh16akyBW6zpGpumntskKh0fM0ItQYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/568] drm/amdkfd: Fix CU Masking for GFX 9.4.3
Date: Tue, 30 Jul 2024 17:44:44 +0200
Message-ID: <20240730151646.798385788@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Mukul Joshi <mukul.joshi@amd.com>

[ Upstream commit 85cf43c554e438e2e12b0fe109688c9533e4d93f ]

We are incorrectly passing the first XCC's MQD when
updating CU masks for other XCCs in the partition. Fix
this by passing the MQD for the XCC currently being
updated with CU mask to update_cu_mask function.

Fixes: fc6efed2c728 ("drm/amdkfd: Update CU masking for GFX 9.4.3")
Signed-off-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index 42d881809dc70..1ac66c5337df4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -686,7 +686,7 @@ static void update_mqd_v9_4_3(struct mqd_manager *mm, void *mqd,
 		m = get_mqd(mqd + size * xcc);
 		update_mqd(mm, m, q, minfo);
 
-		update_cu_mask(mm, mqd, minfo, xcc);
+		update_cu_mask(mm, m, minfo, xcc);
 
 		if (q->format == KFD_QUEUE_FORMAT_AQL) {
 			switch (xcc) {
-- 
2.43.0



