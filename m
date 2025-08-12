Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AF36BB5B;
	Tue, 12 Aug 2025 18:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023463; cv=none; b=qRuQwalzME7lZzXJr052FcpXyxt6vuGtKrmThQP532IeI1Av+4BhCcHdQ18zqr90nD83d9jrSisqxCXBVoG+okOH3WV8sB1GJsc/d2LNsDyb/MESQlPDfF+UiCid/F00TN5X+YISMI96EPv/rqanDHu90QRKsNf1khBX2799VdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023463; c=relaxed/simple;
	bh=aa8oLVOwX0Ltp1bGBMY/8XVyRfsrG1juhfgviDYijG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBxCIf8NDkhj64xMPt/hKoh1RlNsXySpR2v6B98Ei57mlrO0yxCzApc9QCYpbtjDjsC/Nvo8cv9WCgBcmHJv/zUtcJztYPj+aYOZKzvxV2MkD0aH6fQs2uXUWFkTZi+RxBRccCTV4BYwyLQmHJUsrrhOFMqW2NzVNvvue9bHuvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPkeqHOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPkeqHOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09E5C4CEF0;
	Tue, 12 Aug 2025 18:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023463;
	bh=aa8oLVOwX0Ltp1bGBMY/8XVyRfsrG1juhfgviDYijG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPkeqHOd0UkaquecofIBlu8iheXSUu0le4Jy6UkWPTAOvCHrFv8C9Ec4pMzgAn2qH
	 s9DmXctubCf58Veh+K2F+TUjWLAIt7hhKyl8eNQEw1o4n/VpDT3iC962voaH3S43j9
	 Vh0u2BclUrb+vHP1IDBDYtauS0UEd6NrrjwC/zPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sivan Zohar-Kotzer <sivany32@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 087/627] powercap: dtpm_cpu: Fix NULL pointer dereference in get_pd_power_uw()
Date: Tue, 12 Aug 2025 19:26:22 +0200
Message-ID: <20250812173422.613375555@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



