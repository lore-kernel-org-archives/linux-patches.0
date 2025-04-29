Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D0682C60;
	Tue, 29 Apr 2025 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946362; cv=none; b=V5G5NYEiPalcI7erS7GYKXLzJQyx9vDHOZxIb/Jsnan49L9UHV8lX44Pt358hYA94ajtL8fDiPBPiUJxgBDL1/EdxDIuDfUgGBqrFrJIDJ4YKA0tOmoUoHlBGcjM/R7buGIvFfPdTIf+TQ1I00HQxZ+CdPYmCRc2Mzi/4AZbyQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946362; c=relaxed/simple;
	bh=d2HVIdVvnBEbd3smz3n+UPhcZ/2x3uBk0TQcvUA7yZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s02D1RA8M2dDsAkf22CFbbuCTZlZwKaEKUVuH33TtMTctVHPBZM812Xl6d1bqKlEySYZQDjuurU3NpXdzvxMLO9M/rKFLmmDH5TAu8OebTvBNInW/va0xPVLdBcu6O6o6dotf+Dn8ioWdS4AJ7qgEo3ATP8XKj0B/9HJ1h7Rde4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VydjAQc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VydjAQc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187DCC4CEE3;
	Tue, 29 Apr 2025 17:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946361;
	bh=d2HVIdVvnBEbd3smz3n+UPhcZ/2x3uBk0TQcvUA7yZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VydjAQc7WWJZj0oCBUl+OSzyUDVPdntFUttW/IND9ex+CQcZLGlzBVOYha+FaFz30
	 JQwK6PK2W7kypqp7uxOgXJ/FyBTBDLpF/5HEdy/9f/g9ysU9649SpfBb7SXoaj710S
	 +UhOeHhUq/1Mxz6kqFPZ6c/tJmYKMHv86MiIPQho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 241/311] cgroup/cpuset: Dont allow creation of local partition over a remote one
Date: Tue, 29 Apr 2025 18:41:18 +0200
Message-ID: <20250429161130.893666119@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 6da580ec656a5ed135db2cdf574b47635611a4d7 ]

Currently, we don't allow the creation of a remote partition underneath
another local or remote partition. However, it is currently possible to
create a new local partition with an existing remote partition underneath
it if top_cpuset is the parent. However, the current cpuset code does
not set the effective exclusive CPUs correctly to account for those
that are taken by the remote partition.

Changing the code to properly account for those remote partition CPUs
under all possible circumstances can be complex. It is much easier to
not allow such a configuration which is not that useful. So forbid
that by making sure that exclusive_cpus mask doesn't overlap with
subpartitions_cpus and invalidate the partition if that happens.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset-internal.h |  1 +
 kernel/cgroup/cpuset.c          | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 976a8bc3ff603..383963e28ac69 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -33,6 +33,7 @@ enum prs_errcode {
 	PERR_CPUSEMPTY,
 	PERR_HKEEPING,
 	PERR_ACCESS,
+	PERR_REMOTE,
 };
 
 /* bits in struct cpuset flags field */
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index d72f843d9feeb..1287274ae1ce9 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -62,6 +62,7 @@ static const char * const perr_strings[] = {
 	[PERR_CPUSEMPTY] = "cpuset.cpus and cpuset.cpus.exclusive are empty",
 	[PERR_HKEEPING]  = "partition config conflicts with housekeeping setup",
 	[PERR_ACCESS]    = "Enable partition not permitted",
+	[PERR_REMOTE]    = "Have remote partition underneath",
 };
 
 /*
@@ -2840,6 +2841,19 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 			goto out;
 		}
 
+		/*
+		 * We don't support the creation of a new local partition with
+		 * a remote partition underneath it. This unsupported
+		 * setting can happen only if parent is the top_cpuset because
+		 * a remote partition cannot be created underneath an existing
+		 * local or remote partition.
+		 */
+		if ((parent == &top_cpuset) &&
+		    cpumask_intersects(cs->exclusive_cpus, subpartitions_cpus)) {
+			err = PERR_REMOTE;
+			goto out;
+		}
+
 		/*
 		 * If parent is valid partition, enable local partiion.
 		 * Otherwise, enable a remote partition.
-- 
2.39.5



