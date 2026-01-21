Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B8D363C7F;
	Wed, 21 Jan 2026 18:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020110; cv=none; b=A1cS5PNIwRdWv13EYu9QDq7+hT+jDffcq0Yzui+AO+3AfUm3AQW7iNWpqCNcWrlkCGodgwI+7E6ux+cNPu89OPOdEGkcDDnt/rdnyrhPnuHVAgcsZqzIZf5QB8Fraj+25ArgBCXWyjp8qw+fjasjPPBIhWXHlsxK+g4dJCiJj0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020110; c=relaxed/simple;
	bh=lc7cPI/L3P4tcNCaGLfYoku6VjAx3s84C0RG6u2Ed5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8llpwD8l9i0A7k0pOKrgnCjLpadWtzz3wRmO/1goz0qejDwRZ+GH8Kg09rFfRA7RBrCXOJ+hgRZHBU0oWNdWc3S5hqbyEFwBZckwwh4G5rLMSQwbA96Hdm+HpI1FHMLkbSugpzp13M/8TjYeNb8rHeCev6cLZ6jqLV3ocOpmyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VgrLe83u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgrLe83u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F8EC4CEF1;
	Wed, 21 Jan 2026 18:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020110;
	bh=lc7cPI/L3P4tcNCaGLfYoku6VjAx3s84C0RG6u2Ed5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgrLe83uAzK2o7paD7eYV2WwVtuYE7xElnXnlEahwPs5YmTdKP/JCIMAHWJ82s2VD
	 0Hh5+l1QX/w/Dcx3y24AXQJvsszF5k+KCoLxxEkoH8AKXAAlvQXrp1d8RJHpSkQwo0
	 x6mYQiyWDf0B6ucOLyFpSvXKJpjqm0+Ta/1hvB30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 061/198] drm/amdkfd: No need to suspend whole MES to evict process
Date: Wed, 21 Jan 2026 19:14:49 +0100
Message-ID: <20260121181420.751087341@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

[ Upstream commit 18dbcfb46f692e665c3fe3eee804e56c4eae53d6 ]

Each queue of the process is individually removed and there is not need
to suspend whole mes. Suspending mes stops kernel mode queues also
causing unnecessary timeouts when running mixed work loads

Fixes: 079ae5118e1f ("drm/amdkfd: fix suspend/resume all calls in mes based eviction path")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4765
Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3fd20580b96a6e9da65b94ac3b58ee288239b731)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c    | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 6e7bc983fc0b6..36fb3db16572a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1209,14 +1209,8 @@ static int evict_process_queues_cpsch(struct device_queue_manager *dqm,
 	pr_debug_ratelimited("Evicting process pid %d queues\n",
 			    pdd->process->lead_thread->pid);
 
-	if (dqm->dev->kfd->shared_resources.enable_mes) {
+	if (dqm->dev->kfd->shared_resources.enable_mes)
 		pdd->last_evict_timestamp = get_jiffies_64();
-		retval = suspend_all_queues_mes(dqm);
-		if (retval) {
-			dev_err(dev, "Suspending all queues failed");
-			goto out;
-		}
-	}
 
 	/* Mark all queues as evicted. Deactivate all active queues on
 	 * the qpd.
@@ -1246,10 +1240,6 @@ static int evict_process_queues_cpsch(struct device_queue_manager *dqm,
 					      KFD_UNMAP_QUEUES_FILTER_ALL_QUEUES :
 					      KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0,
 					      USE_DEFAULT_GRACE_PERIOD);
-	} else {
-		retval = resume_all_queues_mes(dqm);
-		if (retval)
-			dev_err(dev, "Resuming all queues failed");
 	}
 
 out:
-- 
2.51.0



