Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E1B6F074;
	Wed, 21 Feb 2024 13:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522591; cv=none; b=gTT21oSiBsNvBP9PfiWtbAXguXKsvy584X0Rokm7FiCcp0WjtZitO9aJWSHZCbiH0RLcWzmzFYvmKshe1PrfhMyU/WKZ8HazSUcbUDtyXxGQsu0JtJBM42w+Oeri4wVDWdtp3F4ng2Rgaxa8nwMY46lSxibXcCeNFY+OtcgqD9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522591; c=relaxed/simple;
	bh=vPiICDbIPi/cu3Y9WPyS/Mko8PtpQRFVxlDMLNzdkL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQ6QEwnwXbTHUPmY7hcXnPd9VOfkLSfMKo2ILaYsvrnMAUSRnXRMwpY9tntW8VVfpU3pO57SWUL4A44lWXJDl/xADj05CccmOy5XyW1xf7cQOShcfvqyxBnlhCwPURULnCDa6gdJdDwJ0e2H5lfsXGD1VGpEyQj62kEOftIhX+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3gSf8lj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3gSf8lj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23D3C433C7;
	Wed, 21 Feb 2024 13:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522591;
	bh=vPiICDbIPi/cu3Y9WPyS/Mko8PtpQRFVxlDMLNzdkL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3gSf8ljTCfLI1og0JHjt75VZp4R3zR+kPiWLduqEYGHT9nPyxHBDmWLSxdicelsT
	 rIIO6wVHqCJzUovARpnQVVNdyAPAbQpNv3hCjDcW0WtxZ/tb+NeGmwLsIsI8q5m7BI
	 uTpMvSYsKwOrh5rN1wSIUknHjMb1yXF6+h0QaT2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 202/476] wifi: cfg80211: free beacon_ies when overridden from hidden BSS
Date: Wed, 21 Feb 2024 14:04:13 +0100
Message-ID: <20240221130015.381176668@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4decdc2c601f..68c48970ebf7 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1808,8 +1808,12 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
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



