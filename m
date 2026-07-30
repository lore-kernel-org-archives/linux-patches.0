Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59E744607A;
	Thu, 30 Jul 2026 15:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425262; cv=none; b=nAwQUxnixqO9qVAG+wTIr/yhBNh3AemMFtBwB5PtyYITyWuoyAyKh3zy4d51kd7Q6vWBWPAlMMxpdHjbgmY2gejPx2eePb+LKOOU/tlmTPJGxhV8I+/IUI6dpHjVAzgGd130jcUfPrgqutHJfiycgO4RoKJOPBXRqjY0Ofu3KpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425262; c=relaxed/simple;
	bh=ZJ1B1SqDihOaHAOAA3rlD7hgtHY/mfx9IXMm7fZEmrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmX9LzJZutS2qGk5I6w3wSNPu7bcjxxg4YyAG6wErL6lhjyroOob/6DBQqx/q7hMMlADXk43/mvUrHqT+E6mNsyZU1sHS5Hdhk0Mf90kT4yz/ssMz2kyjlFsWwYqQA2JpH88/Ibyagds4DL+ST7CZA9WTt+xA3RHeg3iZP2bsW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRyxaNWn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRyxaNWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FC61F000E9;
	Thu, 30 Jul 2026 15:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425261;
	bh=bKFbDE+9ySRFcIMIMTkzHmyS3CpCsoWUPGBipBVVUNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KRyxaNWndO5m6+EuVPQuaL3ZsVrTy/y/WWRWpLswZO9Rj8emekmD+K7rJ/5ZOloxR
	 QGuYXx1rtue77qiPBDvJ7DybPy8wwIPwxrpNZB1X/t9GjJ8WwxmzUvpR4C1TsLFMtN
	 DsSSt7NEwcx/xqZknKXqTjb4kM6Z4/pR0bkZVnAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 649/675] fs/resctrl: Split L3 dependent parts out of __mon_event_count()
Date: Thu, 30 Jul 2026 16:16:19 +0200
Message-ID: <20260730141458.931109779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit ad5c2ff75e0c53d2588dfc10eb87458e759b6bbe ]

Carve out the L3 resource specific event reading code into a separate helper
to support reading event data from a new monitoring resource.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lore.kernel.org/20251217172121.12030-1-tony.luck@intel.com
Stable-dep-of: 52fce648607e ("fs/resctrl: Fix use-after-free during unmount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/resctrl/monitor.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -418,7 +418,7 @@ static void mbm_cntr_free(struct rdt_mon
 	memset(&d->cntr_cfg[cntr_id], 0, sizeof(*d->cntr_cfg));
 }
 
-static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
+static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 {
 	int cpu = smp_processor_id();
 	u32 closid = rdtgrp->closid;
@@ -499,6 +499,17 @@ static int __mon_event_count(struct rdtg
 	return ret;
 }
 
+static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
+{
+	switch (rr->r->rid) {
+	case RDT_RESOURCE_L3:
+		return __l3_mon_event_count(rdtgrp, rr);
+	default:
+		rr->err = -EINVAL;
+		return -EINVAL;
+	}
+}
+
 /*
  * mbm_bw_count() - Update bw count from values previously read by
  *		    __mon_event_count().


