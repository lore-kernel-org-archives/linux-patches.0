Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A54AD58;
	Wed, 19 Jun 2024 13:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802969; cv=none; b=oIMT5qPGKH8RCCaf1jH6ciOBWoXOBjhKYw/W72OpZwqfZvOhmhSZQtLZyLi4VwUPaPEMcHSkcHVxRDYbz9CT/YIS7+1o5aezxuNkFt97lvl2zwteysA4Hkgxc5a+JqiBXpgNWU9I0xclQy524akhe5qmlEUNwhqK8gNtibCmf+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802969; c=relaxed/simple;
	bh=QlgEM2QYYNIMDvOo3mSSJV9TMgWkx8baDzCdCnEDaP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/BbQAx1dzI+Qf9kmSnF9cdyqhB2HirT+Jzh1Rz8YdvEo38zhJjLsHWLLIN+JqywoEWNYVDlC4rpfeju8fLM9qvey/kCJMpwgS9731jsL2P19MG1wzeqLW4BanJcx4gQHK9uGZu2IbgH7aisl8yMDM9VwjNI3QiS3rZZv/iRZL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLh0fzGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLh0fzGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF25C2BBFC;
	Wed, 19 Jun 2024 13:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802969;
	bh=QlgEM2QYYNIMDvOo3mSSJV9TMgWkx8baDzCdCnEDaP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLh0fzGhoRbKFh1MQSlZZDmd+gVRHMcTNoK6EHIaG+HNOBZwtPCp6yGtFxIW8wH9S
	 rFkgPUPxd1WhTaifWY865HeujTanUOjxkaZZvIyq3XxOn8OAwNaien8F8VL+H6hfwz
	 JnHlH/2d1MHHUrahFNx1Rnig1aWSnKzsr3GaUAto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 107/281] HID: nvidia-shield: Add missing check for input_ff_create_memless
Date: Wed, 19 Jun 2024 14:54:26 +0200
Message-ID: <20240619125613.966414638@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 0a3f9f7fc59feb8a91a2793b8b60977895c72365 ]

Add check for the return value of input_ff_create_memless() and return
the error if it fails in order to catch the error.

Fixes: 09308562d4af ("HID: nvidia-shield: Initial driver implementation with Thunderstrike support")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nvidia-shield.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-nvidia-shield.c b/drivers/hid/hid-nvidia-shield.c
index 58b15750dbb0a..ff9078ad19611 100644
--- a/drivers/hid/hid-nvidia-shield.c
+++ b/drivers/hid/hid-nvidia-shield.c
@@ -283,7 +283,9 @@ static struct input_dev *shield_haptics_create(
 		return haptics;
 
 	input_set_capability(haptics, EV_FF, FF_RUMBLE);
-	input_ff_create_memless(haptics, NULL, play_effect);
+	ret = input_ff_create_memless(haptics, NULL, play_effect);
+	if (ret)
+		goto err;
 
 	ret = input_register_device(haptics);
 	if (ret)
-- 
2.43.0



