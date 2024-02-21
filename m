Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4987BAFB;
	Wed, 21 Feb 2024 14:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524187; cv=none; b=gb2nsi1jhJLgs/zVSz2cbZolxG/C1/rLYPxgvgBK0+ZvB3aBXAqzjG0TMK+tBE4IIxoL333G9hIXX8jRjmcY7CYBIax6BHIeV9xxVuXpp7I09ofHmCzaMIt3Kvx3pRoej/azMEx5L3jnLHqSvRHsL5t9xtTlFPmTq2zE9zj+raY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524187; c=relaxed/simple;
	bh=pCvgjux99IcLhSE3awe2HE1+qE4l/FqOYq63UneHHk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUE9YblGdvqLWdpMZNsmbADn5RKXvnseWbkjwFs4qrgmj4c7BRzF3X6Krnum6oZJLo6I5ew/XnLrrrRlehklrzDgOVgefXRxnHLRzWXxT5ZNKsxEjYJ520ZDC6HsUoq5HyVj7rF3pobxmYbH9RjSKa9UA/eqDSuw2UqBnatHzsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1DocpBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1DocpBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4520DC433F1;
	Wed, 21 Feb 2024 14:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524187;
	bh=pCvgjux99IcLhSE3awe2HE1+qE4l/FqOYq63UneHHk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1DocpBdiL/7pGLGLK8H1VvbgzE0fmgXXnmp/5FrfWyuUUvFMhFEwAS+A3HPbdPjN
	 Eo/kr1YXzeL3FsIhA/zPyzXy4c18Q2j8B3gHe3A7PjGdSs77upaAfnYAGzZjz+9VZC
	 g0R2fDG0xkGe1IArjkI1BbFZgHMnX67+0IRygNeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/379] wifi: cfg80211: free beacon_ies when overridden from hidden BSS
Date: Wed, 21 Feb 2024 14:05:50 +0100
Message-ID: <20240221125959.975279096@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 32af9a9e1069e55bc02741fb00ac9d0ca1a2eaef ]

This is a more of a cosmetic fix. The branch will only be taken if
proberesp_ies is set, which implies that beacon_ies is not set unless we
are connected to an AP that just did a channel switch. And, in that case
we should have found the BSS in the internal storage to begin with.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231220133549.b898e22dadff.Id8c4c10aedd176ef2e18a4cad747b299f150f9df@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 1e6dfe204ff3..6f0a01038db1 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1801,8 +1801,12 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 				list_add(&new->hidden_list,
 					 &hidden->hidden_list);
 				hidden->refcount++;
+
+				ies = (void *)rcu_dereference(new->pub.beacon_ies);
 				rcu_assign_pointer(new->pub.beacon_ies,
 						   hidden->pub.beacon_ies);
+				if (ies)
+					kfree_rcu(ies, rcu_head);
 			}
 		} else {
 			/*
-- 
2.43.0



