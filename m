Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC96156237;
	Mon,  6 Jan 2025 15:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178960; cv=none; b=ZQb/4hOdJtVqVKaG1gtn+vTtG0LxIDELYtGo7VDn/Hi2Otj2BjNyKXZrZ6F/Lguv5oIF4V+aBLVPHuyBNWhoO+pi3uCHU4RBjDuFlYeYPiVOn/hQY9Sc51YavNAn/9ero+cjdw1W12atHQ1sPu9vicXhmW3tem44Vm5+6183X2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178960; c=relaxed/simple;
	bh=isyEJo/qEc4AfIDAOu0iWZEUagSOxINONfTs3FB8NB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOpTVQk8FoZ1+9qnTKd+9LwjXOZ6qDwajCa7Q392WkCJRy0wSHQMBL1lsVAgHJcadETZiRy/sp8JlQTU+5ydqqMPmYZHbnWPqXKBepiG8lAtR9wDLiEgb2XE8i4qCcKAbRORHwTsN0r4Ju1tWrc6RjLbjqVccchJ3k2TJgcnoyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMUfQLkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMUfQLkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14027C4CED2;
	Mon,  6 Jan 2025 15:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178960;
	bh=isyEJo/qEc4AfIDAOu0iWZEUagSOxINONfTs3FB8NB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMUfQLkVHpYGhR1yUfKPd8pZqetOCjRrNoMXrAtDtgGO1jSK2syCdzTiiMXvqXdyL
	 PnEmK2dzzDao425ymj6ZrFEcUgvQG/+yPgSKi9+xU6xme7wKafkAaOk24HKuMRKMWb
	 1j7MH/KX7pxzLiFV5pQvejGymCwvih6AwQAjFlXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/168] wifi: mac80211: wake the queues in case of failure in resume
Date: Mon,  6 Jan 2025 16:17:37 +0100
Message-ID: <20250106151144.062806079@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 85d3d2034d43..cc78d3cba45e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2374,6 +2374,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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



