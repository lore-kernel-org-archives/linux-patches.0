Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038C333345D;
	Thu, 27 Nov 2025 14:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255385; cv=none; b=tL+SrRZol/t6D0x2n/R5J1aqSSbsJOdC8DOtpc4s70lhKKMAZddE5VqzrlFWoZNO29s5qmNiwOvVDqNKB5DzybwI17Go9KKQj0gbOFhqsTnehkJujMiM9qamsCtMiAeAHnlLPsiBJpORq6OSrJKCfPm6HJc8bX6uXmKp3jqpmoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255385; c=relaxed/simple;
	bh=g8cYd937uhAA0JKzaHE8i3GHzThD2Rv3IG7TSbpR6hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvDUoWtBiBN1wmzdq6m8njyVhChDt0sI0+qlrkmfrtUglZZJ5C2EQ2Z2oF9cO6/XXD41w0JzBJh1ABPU6AA+XSsbNoa4YAEQOdO3SVx7jX/RPDIN3PFSuJbnydnovYX+DXRF3FntGNGan3+gAkWBWgRtEzFyYtk7JTb3T/i0+KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmiOb88J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmiOb88J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B47C4CEF8;
	Thu, 27 Nov 2025 14:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255384;
	bh=g8cYd937uhAA0JKzaHE8i3GHzThD2Rv3IG7TSbpR6hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmiOb88Jdo6HO3AtcVDGK061KOdg4W/jwIzfqrCvbijnh+Hk9zUS2GmCLGK7uGAsj
	 Ex5ugsWlcvvo8mMWAC3Eu4eK9ssjUQ0XOxGH3J9kqjwW1b6OrPthTavF+CSzj4/SDD
	 0MOMRRokx3tLpDuq6/AVySzTf4BqAwsxuzjKaySE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prateek Agarwal <praagarwal@nvidia.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/112] drm/tegra: Add call to put_pid()
Date: Thu, 27 Nov 2025 15:46:04 +0100
Message-ID: <20251127144035.109861542@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prateek Agarwal <praagarwal@nvidia.com>

[ Upstream commit 6cbab9f0da72b4dc3c3f9161197aa3b9daa1fa3a ]

Add a call to put_pid() corresponding to get_task_pid().
host1x_memory_context_alloc() does not take ownership of the PID so we
need to free it here to avoid leaking.

Signed-off-by: Prateek Agarwal <praagarwal@nvidia.com>
Fixes: e09db97889ec ("drm/tegra: Support context isolation")
[mperttunen@nvidia.com: reword commit message]
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20250919-host1x-put-pid-v1-1-19c2163dfa87@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/uapi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tegra/uapi.c b/drivers/gpu/drm/tegra/uapi.c
index 5adab6b229164..d0b6a1fa6efad 100644
--- a/drivers/gpu/drm/tegra/uapi.c
+++ b/drivers/gpu/drm/tegra/uapi.c
@@ -114,9 +114,12 @@ int tegra_drm_ioctl_channel_open(struct drm_device *drm, void *data, struct drm_
 		if (err)
 			goto put_channel;
 
-		if (supported)
+		if (supported) {
+			struct pid *pid = get_task_pid(current, PIDTYPE_TGID);
 			context->memory_context = host1x_memory_context_alloc(
-				host, client->base.dev, get_task_pid(current, PIDTYPE_TGID));
+				host, client->base.dev, pid);
+			put_pid(pid);
+		}
 
 		if (IS_ERR(context->memory_context)) {
 			if (PTR_ERR(context->memory_context) != -EOPNOTSUPP) {
-- 
2.51.0



