Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9F81DE3D6;
	Mon,  6 Jan 2025 15:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177490; cv=none; b=tBp/CiqUwkwmJqXHt+pmaaah500/6mkKMXStkQMIeDKo4dDSukNrzIzttxHWW4sb29EIcQmel5xJd4a3js9tlHdDsmR/mmlobZLgUL5icpXijB3tpFoiu2jcbBzj6io9FQ/Hq5pHiF4u4xNfTFAhflj87CNOCYCQKtuaFyway+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177490; c=relaxed/simple;
	bh=natD1cTvlP0duKYsYcHB36aGjA/HrqaXWfMZzAabW+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTfg0uwyNy8Uk0HJW2voA2EWCGY7kAseAPTomRCZxFMNBu+rr5yvBYiTCpYYF/AKMGgmgCy+91WMjTPbeAw5u/saIo0CCiNckxjU6NKGETYETaZmOOJeMdCKmfOROFv8uuZ76JAD22N9vW8Zu8VaNSUuv2o+DLw2aTGeQom4EgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkVDAYHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkVDAYHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DB6C4CED2;
	Mon,  6 Jan 2025 15:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177489;
	bh=natD1cTvlP0duKYsYcHB36aGjA/HrqaXWfMZzAabW+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkVDAYHsSqWB7mYfANWES1r+IXa6e0PRSAegV0+6Y25go4MYvYVCGA3VtTvkWPyxh
	 uC5JPGVvRyLvztNZoy27VTVvn7cB28knQQZXyRKz9qKIM/WBddjkigxGwq6sLVlqI8
	 W4FruVxH5Jx5qSmbFdLZ/O8Mlx8rTPt0HygG5PO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/222] wifi: mac80211: wake the queues in case of failure in resume
Date: Mon,  6 Jan 2025 16:16:23 +0100
Message-ID: <20250106151157.543384355@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 220bf000530f9b1114fa2a1022a871c7ce8a0b38 ]

In case we fail to resume, we'll WARN with
"Hardware became unavailable during restart." and we'll wait until user
space does something. It'll typically bring the interface down and up to
recover. This won't work though because the queues are still stopped on
IEEE80211_QUEUE_STOP_REASON_SUSPEND reason.
Make sure we clear that reason so that we give a chance to the recovery
to succeed.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219447
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241119173108.cd628f560f97.I76a15fdb92de450e5329940125f3c58916be3942@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index cc3c46a82077..154b41af4157 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2586,6 +2586,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			WARN(1, "Hardware became unavailable upon resume. This could be a software issue prior to suspend or a hardware issue.\n");
 		else
 			WARN(1, "Hardware became unavailable during restart.\n");
+		ieee80211_wake_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,
+						IEEE80211_QUEUE_STOP_REASON_SUSPEND,
+						false);
 		ieee80211_handle_reconfig_failure(local);
 		return res;
 	}
-- 
2.39.5



