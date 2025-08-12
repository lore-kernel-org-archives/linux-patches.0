Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDFA2FE59D;
	Tue, 12 Aug 2025 18:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022066; cv=none; b=F8zuZLk+bx9u2+vjx7FmYd4QFcRoRKWBlIe4bQKuCJ9qpu5LPacdz9iZSihvFKCt9LpPCVPjVvOP5rV7wwG5DE8jttmIBZTYxjJmczE6SGad+a9fxbpIYQVvX7/OavVgYRoYFyO3vCiiJGp1ZADNaWKrsDeR+slfgrdkPnV3WbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022066; c=relaxed/simple;
	bh=gxxnXWf12Dq1Fr7xqZGsdQXjSLPQOvXyleLzdexluXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibd9Y1GifahftoktD7bxwc0M+VB6Dtx3VIhDDkYgJZqp+mqkAvlUVw32bFEabJn7sLTaAuPo/4ei8X1qpHJyk1OmAstph8TqGAa03r/cCf+zI0MgGtE/xNFKmxLrmQUixfgmkUw2xURvpTHBWwzZxb2Il7cv+HezWkTfajjco+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+n26OG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+n26OG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06DFC4CEF0;
	Tue, 12 Aug 2025 18:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022066;
	bh=gxxnXWf12Dq1Fr7xqZGsdQXjSLPQOvXyleLzdexluXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+n26OG5gkMhgSzz8VpYqPV33gUsh5rz4ZQCuBVt7mdQi4LzHraD/YIkOiaHj0uO7
	 SA2dmdlSC88pX59UPkeVrXHG7+kQcu+ylAarNfYPVMSne/JyuKWTNReNxRgoA1j1qc
	 ID1HNoeA8PKi7zgHKUahV09bWSnJVOgdti6lSn6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sivan Zohar-Kotzer <sivany32@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/369] powercap: dtpm_cpu: Fix NULL pointer dereference in get_pd_power_uw()
Date: Tue, 12 Aug 2025 19:25:43 +0200
Message-ID: <20250812173016.493727291@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index 6b6f51b21550..99390ec1481f 100644
--- a/drivers/powercap/dtpm_cpu.c
+++ b/drivers/powercap/dtpm_cpu.c
@@ -96,6 +96,8 @@ static u64 get_pd_power_uw(struct dtpm *dtpm)
 	int i;
 
 	pd = em_cpu_get(dtpm_cpu->cpu);
+	if (!pd)
+		return 0;
 
 	pd_mask = em_span_cpus(pd);
 
-- 
2.39.5



