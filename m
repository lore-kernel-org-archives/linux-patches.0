Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D020A2F7461;
	Tue, 12 Aug 2025 17:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020438; cv=none; b=TA3VYVIc+cxUdLlKlY9RoVZZEGj/10b/9xDrwzmF5KKh4pzd1+Eg555C9Y1LOMrQCi4WEulN8vBi7u0Os2keDPcBNOBNIhnlmJ/Mq+NwrwmJV8iS5FqXIxPvDatrJlTKUBsd5UZyqj2l8PSiQlO9Rlpg6jpKxe7/EaRo/rghduA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020438; c=relaxed/simple;
	bh=xiZ8kL56t/TNTES9rvGNeCDp0MMLfsn8MJOztGrXY6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqgafrwoTmLb1g+B64P3QOXYr+0okq2WhfAg8cyqYC+RU5PItVnjvhKhEW6HznRNdX7XSd6Eng00RQV09Y9gCWjbUa+q95vo+HMTOhe281uomzQnwu2dKj7vkIEJNwoynKELEa/vlzAbCg5+eHg6xD2gPfng7iy/FgHShv8AvcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVdW+X+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVdW+X+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDCDC4CEF1;
	Tue, 12 Aug 2025 17:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020438;
	bh=xiZ8kL56t/TNTES9rvGNeCDp0MMLfsn8MJOztGrXY6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVdW+X+yj4H2wa2s0O9gLH50Cu68BSo0Qjanutezsq05oSWEmEO4UhwMEGpFCsAWH
	 g517g2A/TbZ6YkIUrguG152ClswajSZkuerq7NE5oE1GMxN9KrZt1M+xaSVaYFRftv
	 1gPYcBiyEvPu5DUa1jD9EuBX/8PPTpEqcHOzWkJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sivan Zohar-Kotzer <sivany32@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/253] powercap: dtpm_cpu: Fix NULL pointer dereference in get_pd_power_uw()
Date: Tue, 12 Aug 2025 19:27:49 +0200
Message-ID: <20250812172952.183040912@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sivan Zohar-Kotzer <sivany32@gmail.com>

[ Upstream commit 46dc57406887dd02565cb264224194a6776d882b ]

The get_pd_power_uw() function can crash with a NULL pointer dereference
when em_cpu_get() returns NULL. This occurs when a CPU becomes impossible
during runtime, causing get_cpu_device() to return NULL, which propagates
through em_cpu_get() and leads to a crash when em_span_cpus() dereferences
the NULL pointer.

Add a NULL check after em_cpu_get() and return 0 if unavailable,
matching the existing fallback behavior in __dtpm_cpu_setup().

Fixes: eb82bace8931 ("powercap/drivers/dtpm: Scale the power with the load")
Signed-off-by: Sivan Zohar-Kotzer <sivany32@gmail.com>
Link: https://patch.msgid.link/20250701221355.96916-1-sivany32@gmail.com
[ rjw: Drop an excess empty code line ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/dtpm_cpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/powercap/dtpm_cpu.c b/drivers/powercap/dtpm_cpu.c
index ae7ee611978b..99a82060ead9 100644
--- a/drivers/powercap/dtpm_cpu.c
+++ b/drivers/powercap/dtpm_cpu.c
@@ -93,6 +93,8 @@ static u64 get_pd_power_uw(struct dtpm *dtpm)
 	int i;
 
 	pd = em_cpu_get(dtpm_cpu->cpu);
+	if (!pd)
+		return 0;
 
 	pd_mask = em_span_cpus(pd);
 
-- 
2.39.5



