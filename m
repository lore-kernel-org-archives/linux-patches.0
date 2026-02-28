Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7156E383C6A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302041; cv=none; b=IAkHKL9aXa+6Uazn52HwhqSrEEvVRc0d5apD+C0mpMy/9e+dMGWlfdNSX7PZh56QIKTkdTozrxY0uXtVCMOWlHUAwEHY0+Q0kF4fMWwJy4Imp26agEaFcy/deK4sxoREnYBcxPw4sZfxuve61iTN9NNF00LRH9S6H3rrQSvH2ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302041; c=relaxed/simple;
	bh=U946a4XLDysgOC0GEnBdeTH7DLCHDUaqPMNeztuLOoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sssUOfJqe4nBL8eFygfGHjldV5LB/eKeFByGM4WqJvTKiYwUN0Sy+o7h6BzKr28KCXksXYPfpQSQOEVYUb7pfcopic+kSqHQkwK98u9qEdoPhsU+0zJnFNxDu96Y8Ufx+q4HduqfnnQuc17terOYlf3zb/eh6YbG948ye5K0gcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TTACAUIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TTACAUIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5496C116D0;
	Sat, 28 Feb 2026 18:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302041;
	bh=U946a4XLDysgOC0GEnBdeTH7DLCHDUaqPMNeztuLOoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTACAUIcNi7Y1QzYKS695RPPs0YZGz7uz4lXEXMhsqbhw9O+5QRtxbgUtM/yfJHK4
	 BQdd/MbWASwsM5zofB5lyOdYzXv/shXIjM7+LLiDEQ9kj5BggDe2DRdutujEG9h9Pi
	 aeM2lwtaTDvwa/pzDJCV+054mIALfMHi/WC8vBoiWcakTWMFFMGhWMVI84vPm2+YPK
	 QpyycFcXFSdIFtDOxk3ZM9Xq+++tf4Z2JI6U+9WtVN44n9AYCT5P69iWW/WXtIWAEY
	 vBepK90DJAxE5oeG185zHj/+RW+pCI2wpjU5pDe/MLaAurCxfLvVCiSfKJKzhs/Jj+
	 2A503K8coxCOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/283] i3c: master: Update hot-join flag only on success
Date: Sat, 28 Feb 2026 13:02:35 -0500
Message-ID: <20260228180709.1583486-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit f0775157b9f9a28ae3eabc8d05b0bc52e8056c80 ]

To prevent inconsistent state when an error occurs, ensure the hot-join
flag is updated only when enabling or disabling hot-join succeeds.

Fixes: 317bacf960a48 ("i3c: master: add enable(disable) hot join in sys entry")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260113072702.16268-4-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 0c3434e357e26..f74ef65d257d7 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -586,7 +586,8 @@ static int i3c_set_hotjoin(struct i3c_master_controller *master, bool enable)
 	else
 		ret = master->ops->disable_hotjoin(master);
 
-	master->hotjoin = enable;
+	if (!ret)
+		master->hotjoin = enable;
 
 	i3c_bus_normaluse_unlock(&master->bus);
 
-- 
2.51.0

