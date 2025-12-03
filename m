Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081B435BDB8;
	Wed,  3 Dec 2025 16:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780101; cv=none; b=pzPj9R7Ry5O2wEpHbU8zFOUHHfV3/2Iz6dZMLEXVqF93YK632VhHMEqcbRNCxVVIU6/wj40cV8oCekJw57g4yrdow1rUZwlJE5GdaBiF2j+6HthJiboKH2v2gCyxrLL9iqytRRixgHPWAar9XbXUy1EMfmhP88jPsYTc+TmmZMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780101; c=relaxed/simple;
	bh=6cT6Duxw3+NpTt1w+Oj+oRRdATN3SkwURJGcb1LKJMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i82VaZtQUltrtpsQYHM5cpxvbigzn/rQ5EvSJm9rHnNx5Jhu6XQenoGOlY9cqgRUmqAhYIsCebDoLBi2M060mEFh4bN17tK33qegxrMO4r8QDlASg8XyTxf2tqmsk8QEibhhniB48C9bL2ZKgGEO9FjxvF1q3cqT9ayH/Hj6KFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRfctEPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRfctEPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623DDC4CEF5;
	Wed,  3 Dec 2025 16:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780100;
	bh=6cT6Duxw3+NpTt1w+Oj+oRRdATN3SkwURJGcb1LKJMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRfctEPEO85EnKdTbQoUkeMg4iMzuOctWtoLCS3lVOkvKwPLo97IVx8tG03dEPnwG
	 32qZqmwTr9jmUvWgpN9gWACF5NFHfJgv/PplV+2sDwNJLEs2Lalz3xqGMTNf3c+aLC
	 vbvPGpMg5nb3yiO5B9e6V4DN+pJAUiWUlCf0f7Rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prateek Agarwal <praagarwal@nvidia.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 454/568] drm/tegra: Add call to put_pid()
Date: Wed,  3 Dec 2025 16:27:36 +0100
Message-ID: <20251203152457.333274646@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



