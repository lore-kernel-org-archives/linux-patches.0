Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC9E29A9;
	Fri, 15 Nov 2024 06:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653353; cv=none; b=YfG8480sJ75NkHvsNhYSHwZFteOrV9I8pUSjE3EobbIpzoKeAnfTVdblVjLyteZIxjetgvAK6lUU8J8y1tyOVH00XOynnabYcfvbA5IiBGSDIX523RseWhE57u6jl37wu9x8vxwSp1I7E/Fexpvqxsf1MNDwsJz8ETEn+I/GYhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653353; c=relaxed/simple;
	bh=tlmIx9HdBEn5zGB/Gu7zwzk7bQ8k3HqbojNnaPqoHzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBk+tDqlZYikJRXLg3J4J+aheDA0/EkG/TogikPF50xHF8ww+SAqohMeLd+6f2vafuT8CEBHp8bjwXPTXtZYJmKGKptC182yH10SRA2tAFcGwjF13IAscgq/HIqD6rx1GYVKiB/FCMENHD3jrn27Qw6cOqdwfrf60dqKB2Tzi8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15VViXC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15VViXC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DE0C4CECF;
	Fri, 15 Nov 2024 06:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653353;
	bh=tlmIx9HdBEn5zGB/Gu7zwzk7bQ8k3HqbojNnaPqoHzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15VViXC7Ud+pfBpvGg/zyfAi+hCUCrKuinABFW2Oqqkx3aY/ptUdzUCLYKZSi1UQu
	 nUZBtVvT5AV6zuSgGDdMHm6huBbCzseLEUweaMcOBq+iBZjgZ0CfEk2Ga1nwx41IH7
	 QVJxqaKSIJYI9Ji7v+ll4QZNzdQZIpD6Q+2AU9wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francois Dugast <francois.dugast@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 60/63] drm/xe/ufence: Prefetch ufence addr to catch bogus address
Date: Fri, 15 Nov 2024 07:38:23 +0100
Message-ID: <20241115063728.072773059@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit 9c1813b3253480b30604c680026c7dc721ce86d1 ]

access_ok() only checks for addr overflow so also try to read the addr
to catch invalid addr sent from userspace.

Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/1630
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241016082304.66009-2-nirmoy.das@intel.com
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
(cherry picked from commit 9408c4508483ffc60811e910a93d6425b8e63928)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_sync.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_sync.c b/drivers/gpu/drm/xe/xe_sync.c
index de80c8b7c8913..9d77f2d4096f5 100644
--- a/drivers/gpu/drm/xe/xe_sync.c
+++ b/drivers/gpu/drm/xe/xe_sync.c
@@ -54,8 +54,9 @@ static struct xe_user_fence *user_fence_create(struct xe_device *xe, u64 addr,
 {
 	struct xe_user_fence *ufence;
 	u64 __user *ptr = u64_to_user_ptr(addr);
+	u64 __maybe_unused prefetch_val;
 
-	if (!access_ok(ptr, sizeof(*ptr)))
+	if (get_user(prefetch_val, ptr))
 		return ERR_PTR(-EFAULT);
 
 	ufence = kzalloc(sizeof(*ufence), GFP_KERNEL);
-- 
2.43.0



