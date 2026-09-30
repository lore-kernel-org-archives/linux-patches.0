Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9AE3DA7DD;
	Wed, 30 Sep 2026 19:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795920; cv=none; b=S4BnX4ytP9O/YbfoTH+U7hW7Ec5BicaPHabQDI7+1eSc/EjGQJtK8CA0JQqBVQIYXBctSg1hljgHzRfOdKIcvW0TBMgpNu2LJKKRjPPp5aRf3z4gY+Kd2zx925CucgoLp6Kx8ZnXOsrHMEAJq7Knf/Jqq5JIsrOe1Y1KacU2wRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795920; c=relaxed/simple;
	bh=O/ai8p7bU5O3uuf8gOzTVp6yNJYFGKa9u12I31gETvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TddAyMYsWY0Ybx8I5XzmSjMPlDM2CJbqo4OEpOSvPAgayGtruygrWAjGUSdcRvDQBFNc1mziQYDC4aPgf2bfr+hL6YZkQH6tvAQkQn+IkvoHk2JJI4uF3lmvVFVggVsLg0EkfzmbvzhYoIEAk+6dJe07rLO0R6wetZ9dc0ZI8mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qk7szrlZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qk7szrlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280EE1F000FF;
	Wed, 30 Sep 2026 19:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795918;
	bh=MwkyKtWgRGuUpjdU6NZY5t8d6261nDY2oI0a2PBwSTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qk7szrlZRT9Q26EM+Fs+5FpBRay3fUiASr9lNRCxr30I3COW+pfO16+Mc3gcrjcfi
	 GBGxhoX9OjqD5ZxtZNWm/PKnuhBMutODg9F7L8VYX0H1nmWKQ03wCqzTasH0XMt7is
	 ebgIkiF4xXvX6R1X3Gog4FdGgdcYQWjXuTTkp70E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0730/1193] firmware: arm_scpi: reject DVFS OPP count above MAX_DVFS_OPPS
Date: Wed, 30 Sep 2026 17:23:34 +0200
Message-ID: <20260930152450.470843821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit 32471d84a487c7fd74532bc96be56f8028cf4a3f ]

scpi_dvfs_get_info() already rejected a zero opp_count, but still trusted
any larger value from the SCP firmware. The shared-memory reply only holds
MAX_DVFS_OPPS entries in buf.opps[]; a bigger count over-reads that array
and then sizes the allocated OPP table incorrectly (garbage OPPs / OOB).
The missing upper bound dates back to the original SCPI DVFS support.

Reject zero and out-of-range counts in one check and return -EINVAL.

Fixes: 8cb7cf56c9fe ("firmware: add support for ARM System Control and Power Interface(SCPI) protocol")
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Link: https://patch.msgid.link/022802f0b38f.v2.1785200642.git.liuxixin@kylinos.cn
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scpi.c b/drivers/firmware/arm_scpi.c
index 2d85e783ae267..aa27eb5278520 100644
--- a/drivers/firmware/arm_scpi.c
+++ b/drivers/firmware/arm_scpi.c
@@ -628,8 +628,8 @@ static struct scpi_dvfs_info *scpi_dvfs_get_info(u8 domain)
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (!buf.opp_count)
-		return ERR_PTR(-ENOENT);
+	if (!buf.opp_count || buf.opp_count > MAX_DVFS_OPPS)
+		return ERR_PTR(-EINVAL);
 
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
-- 
2.53.0



