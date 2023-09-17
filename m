Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225F46FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892FEC433C7;
	Sun, 17 Sep 2023 19:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978791;
	bh=rjj9M66l4mGAPc86oFGNHu36YK6r5lccf2Yf8Lo36k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vyvrUl5QG0GbSfswGW+0mc3UwCjIO3d0mRss+EXRYl28BsawnLNAf8eWderQ/+CVZ
	 +mABQHONh6AsrZlhohfMukAcEKFXY4pahD+5EH3jlArXGqdXWgQhse0Tprb3ROgyfg
	 gjvXynwUxhoF2czCEQ+32AJA4kvhP+GKy9GqpHTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 161/406] drm/amd/pm: fix variable dereferenced issue in amdgpu_device_attr_create()
Date: Sun, 17 Sep 2023 21:10:15 +0200
Message-ID: <20230917191105.430220822@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 25e6373a5b8efc623443f2699d2b929bf3067d76 ]

- fix variable ('attr') dereferenced issue.
- using condition check instead of BUG_ON().

Fixes: 4e01847c38f7 ("drm/amdgpu: optimize amdgpu device attribute code")
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 5abb68017f6ed..d58a59cf4f853 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2115,15 +2115,19 @@ static int amdgpu_device_attr_create(struct amdgpu_device *adev,
 				     uint32_t mask, struct list_head *attr_list)
 {
 	int ret = 0;
-	struct device_attribute *dev_attr = &attr->dev_attr;
-	const char *name = dev_attr->attr.name;
 	enum amdgpu_device_attr_states attr_states = ATTR_STATE_SUPPORTED;
 	struct amdgpu_device_attr_entry *attr_entry;
+	struct device_attribute *dev_attr;
+	const char *name;
 
 	int (*attr_update)(struct amdgpu_device *adev, struct amdgpu_device_attr *attr,
 			   uint32_t mask, enum amdgpu_device_attr_states *states) = default_attr_update;
 
-	BUG_ON(!attr);
+	if (!attr)
+		return -EINVAL;
+
+	dev_attr = &attr->dev_attr;
+	name = dev_attr->attr.name;
 
 	attr_update = attr->attr_update ? attr_update : default_attr_update;
 
-- 
2.40.1



