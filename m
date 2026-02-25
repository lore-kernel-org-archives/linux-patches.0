Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63D921D596;
	Wed, 25 Feb 2026 01:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982948; cv=none; b=ZW+BEHicY42PjnQl68WIAbyUI9o7XQHiOJWMe/1CHZcMsBERnjCDuZJsqN73MQmr7q/ph/mSdHi2luzTKXNAf6bKE4/83jbREDppGcGl/3bw3OJx3GGoHiZNltkLzwkFMlT0IQWT/6SUN0pA+WvDKVXN/fQpKJjsBZdmUHZ2aHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982948; c=relaxed/simple;
	bh=Xr97VkdIHuuXjisPFGeO/8Gjjia4KS1+qEro/TRpdZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osP4EYqtaHUy+AY1oiQx49zAeRcHDbc36to1Q73GRoRTSiK8o6QveY/DDvgZZEZVEqhNl3IPHMGTVMN9DZmR5lUZjRJoF+fZkCl/8zWLvCT/Oleel/wSAM3o5XjKYQzcKSFRhq5Qo/oDYrcLpWF7INrMCwtRXCruVdO0n/ebbXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XoqdqSFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XoqdqSFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD9EC116D0;
	Wed, 25 Feb 2026 01:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982948;
	bh=Xr97VkdIHuuXjisPFGeO/8Gjjia4KS1+qEro/TRpdZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XoqdqSFGRSfci//J1GOq+4dS0pqxd2ZxWRKcR0lNnc7GLWDxHbwzzh4Gh4PWLlC1g
	 DrfDIAL2IhKQFa1O7mVqUJK9kv63hyncSpF/MOfoXVTR2WnBz5R0TfiE49KvsnVDdi
	 BPUJ2lbdR3oK+iESxPWDNRqBghgTLvzmBKPV4TFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Fernandes <joelagnelf@nvidia.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Andrea Righi <arighi@nvidia.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 127/781] sched/deadline: Clear the defer params
Date: Tue, 24 Feb 2026 17:13:56 -0800
Message-ID: <20260225012402.783939737@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Fernandes <joelagnelf@nvidia.com>

[ Upstream commit 3cb3b27693bf30defb16aa096158a3b24583b8d2 ]

The defer params were not cleared in __dl_clear_params. Clear them.

Without this is some of my test cases are flaking and the DL timer is
not starting correctly AFAICS.

Fixes: a110a81c52a9 ("sched/deadline: Deferrable dl server")
Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260126100050.3854740-2-arighi@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 7bcde7114f1b6..e3a6b8ed1d6db 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3656,6 +3656,9 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_non_contending	= 0;
 	dl_se->dl_overrun		= 0;
 	dl_se->dl_server		= 0;
+	dl_se->dl_defer			= 0;
+	dl_se->dl_defer_running		= 0;
+	dl_se->dl_defer_armed		= 0;
 
 #ifdef CONFIG_RT_MUTEXES
 	dl_se->pi_se			= dl_se;
-- 
2.51.0



