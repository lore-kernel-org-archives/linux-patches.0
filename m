Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CE63218C2;
	Mon, 18 Aug 2025 12:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521802; cv=none; b=jzfXKj4xPCQeSFp98nmTBn/vCrZXTPdzlWmNd/cW3FfLWRhr2FEu8a4OME8jX2dz3e/GfpD7b+Ft8W15M3d53iCRm1dfMnhE4NQPQibSWok4qbQ7ORRx6PRdYgrntehHaF3CZzIpyz1d1F8LwEgGfOVXrov21CBvpWjA2kWZ4Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521802; c=relaxed/simple;
	bh=dS8BO6rgb00BffjGHoddYmrWqYBrwak8cjmyX4SGIdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nkprv+FvwNLNpj8ZNheNdBY84lNgD9kGZXoQg3K5/CaoIg2EpK8kjJodgtXAWvrzXw0Kwc5k6mpgVvTT4KB/Noraa5ut32i4bSUHE3hCzwWNWY0DfNIGfZFq++5vSsX64Z+CxXsB4Xh0RuarGP1CDZxoC1Et/ipTz1bFzLJOjAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzD93Z+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzD93Z+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C19C4CEEB;
	Mon, 18 Aug 2025 12:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521802;
	bh=dS8BO6rgb00BffjGHoddYmrWqYBrwak8cjmyX4SGIdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzD93Z+M4uUMfU91l732FtlfrQlD9a3OBCqBasb8I6AiQ4a6+xrJa0Sear+xujBjL
	 1sQeszuXU1LVPgRgo01jAIENHoWb1ufa3WRJqRcEIzWswoaIsQXs0qriAq+e88dMkb
	 2gwXHEX9PiX0g2ysSyIqTOwykhdZusa98VZs4J48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/444] PM: runtime: Clear power.needs_force_resume in pm_runtime_reinit()
Date: Mon, 18 Aug 2025 14:42:33 +0200
Message-ID: <20250818124453.672650808@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 89d9cec3b1e9c49bae9375a2db6dc49bc7468af0 ]

Clear power.needs_force_resume in pm_runtime_reinit() in case it has
been set by pm_runtime_force_suspend() invoked from a driver remove
callback.

Suggested-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://patch.msgid.link/9495163.CDJkKcVGEf@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 99f25d6b2027..317505eab126 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1787,6 +1787,11 @@ void pm_runtime_reinit(struct device *dev)
 				pm_runtime_put(dev->parent);
 		}
 	}
+	/*
+	 * Clear power.needs_force_resume in case it has been set by
+	 * pm_runtime_force_suspend() invoked from a driver remove callback.
+	 */
+	dev->power.needs_force_resume = false;
 }
 
 /**
-- 
2.39.5



