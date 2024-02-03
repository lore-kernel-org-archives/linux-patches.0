Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF3310A09;
	Sat,  3 Feb 2024 04:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933582; cv=none; b=K43OSr//iOAhwhNUfnWRjnjt6oZqu+nMwv2jbetXs0MGraIqL0CeaGJVXOjkqJo/7UYB10eG8pkMB6JybSANYFi3X8284y+wliSDzQqKk55BYUsqQ9gfu1OG0xFJaCBJRR+QjLDYjtgn7GK35IX0++2qq0itkOz3VKOksK/wxsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933582; c=relaxed/simple;
	bh=HWm/tLckfHNq4X10TFWQhiYp+xldV9cgsw1BvtEHHrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4P8xBhfF5o0aYq0CXIhJB1ZJEvmaWPwU2XdCoSKIUN+sivogRyqCMFQTFmMH5Ta6twf2p9p/l11WmgwCMR8E7MdnK42dCjW8CsYSuKnIQy7wd2qew9JbuQ7JeEXxti49xmfYp/WpIYwsKLpI21OaPovSevBOV2ke/NTgswNLLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJGq3/ai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJGq3/ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664D3C43394;
	Sat,  3 Feb 2024 04:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933582;
	bh=HWm/tLckfHNq4X10TFWQhiYp+xldV9cgsw1BvtEHHrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJGq3/aiiSp1Rhz0W1d6C9L4cWjRj3KguUcT8A2nk1Skh6V4ipH6Ez9B8PDo2XeQr
	 2k2UH/y/YjlFONblHPpOlgqq/OgKwvFiQBk+t8ClEErqPD0IDVur6uvIFlbqzCVHz4
	 TQ3bYyEPHKDs7w5iNDv3yOYUO24dJnTzYXP7VM2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/322] wifi: cfg80211: free beacon_ies when overridden from hidden BSS
Date: Fri,  2 Feb 2024 20:04:01 -0800
Message-ID: <20240203035403.819893844@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bd4dd75e446e..04ef7cdd39b5 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1829,8 +1829,12 @@ __cfg80211_bss_update(struct cfg80211_registered_device *rdev,
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



