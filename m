Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42E41D0E25;
	Wed,  2 Oct 2024 14:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879861; cv=none; b=jI4NiJbmrB205niEFFqlsiqm8aRlUgKYAJZbJxfcT0XWJlfuIAb5PGOEAjrbf089ruiEBDQ5mYs+BBQZSUiQz0T8p0iCIZviEHocvW4iPysGE9NxeD0hH7swsPruAd8KvR+9oVSgexS3zva80/EoSVtch/AJ29qEW3LA49eKUTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879861; c=relaxed/simple;
	bh=kUjyTd0E2bexkUFSrz/NQSQIt4IHBxEeBJhxfC9LH5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZP8/sCRG8Eh5k4g8OA0mhFtSS2GUeANrcu2Qp3bN69+U1ZqNw7AtsL9T9o/JqLXfXZJukPhbUI8EHqghgpU3PorfebAp16kURgVaOvjQMfWkS/mh+/RgdCcNHF3HMmc1ySUYcIn0DINjISGdyu16dBbJjXwfJn06OUlD34Q+Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSkb02zT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSkb02zT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBAEC4CEC2;
	Wed,  2 Oct 2024 14:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879860;
	bh=kUjyTd0E2bexkUFSrz/NQSQIt4IHBxEeBJhxfC9LH5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSkb02zTQFRNAag6DSWEvIaRp+/9WG3JtIWgtPdiUr+Nbs3WFM/E1b4gSL9qI4akI
	 SN0Lehn3UstpBCFLNzy06sTYeIq8SIjiiq65BDluDA5VnulFXWGH1dQZfNU5QCtuIW
	 Dc9qTyZq+6knyPqVraCk7JJ5FYyNdELWLuv5j0kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mel Gorman <mgorman@techsingularity.net>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 232/538] sched/numa: Document vma_numab_state fields
Date: Wed,  2 Oct 2024 14:57:51 +0200
Message-ID: <20241002125801.410016025@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Mel Gorman <mgorman@techsingularity.net>

[ Upstream commit 9ae5c00ea2e600a8b823f9b95606dd244f3096bf ]

Document the intended usage of the fields.

[ mingo: Reformatted to take less vertical space & tidied it up. ]

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20231010083143.19593-2-mgorman@techsingularity.net
Stable-dep-of: f22cde4371f3 ("sched/numa: Fix the vma scan starving issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm_types.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index ba25777ec0a71..b53a13d15bbae 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -551,8 +551,29 @@ struct vma_lock {
 };
 
 struct vma_numab_state {
+	/*
+	 * Initialised as time in 'jiffies' after which VMA
+	 * should be scanned.  Delays first scan of new VMA by at
+	 * least sysctl_numa_balancing_scan_delay:
+	 */
 	unsigned long next_scan;
+
+	/*
+	 * Time in jiffies when access_pids[] is reset to
+	 * detect phase change behaviour:
+	 */
 	unsigned long next_pid_reset;
+
+	/*
+	 * Approximate tracking of PIDs that trapped a NUMA hinting
+	 * fault. May produce false positives due to hash collisions.
+	 *
+	 *   [0] Previous PID tracking
+	 *   [1] Current PID tracking
+	 *
+	 * Window moves after next_pid_reset has expired approximately
+	 * every VMA_PID_RESET_PERIOD jiffies:
+	 */
 	unsigned long access_pids[2];
 };
 
-- 
2.43.0



