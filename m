Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169CC79DAE;
	Wed, 21 Feb 2024 14:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525319; cv=none; b=eNwEk8r7iTsOQmsup9H2YnBF8AOnTeN7rlhuwlcumHtsz7+EC4hZURMnLJ4UWvEOT+6Fmw4BIuaxiZYRUO1Eo39/52qIQzl4c/QhbYRjn0HBrRGAUfjBpNom3t1iaZZTQp4dAHdyk8DQdOmdwOAaj2eB6Wwhs/JTTwYziaZnljM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525319; c=relaxed/simple;
	bh=UNhrh4HaQ59OwhBlNMayRLy2M4cD5JR1q4QXOsLDUXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kejAQ3N4twGZuyMsB5daUUWiPsQmVlMIDjoA31EfBuV5qXaSaYQQ2s4yLsQ5GkVQrASgsSNUpVwfKM9I3K90wJfeCH7XGa4TBBfka90Pc0VN5ZK1sxAcICHRfx8M1MTd3Gjg8nQ3hPGXwm9xSFgUX4R9OuY91sX0DoKuS/ojtZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+IOG6In; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+IOG6In"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB5CC433C7;
	Wed, 21 Feb 2024 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525319;
	bh=UNhrh4HaQ59OwhBlNMayRLy2M4cD5JR1q4QXOsLDUXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+IOG6InBuN9K3jnQbRSZihTW3FHTJUnEIlDmURAWRjH60wiyrsEqAdSrSZGqwpCK
	 GczedmPPl0oduUFHkyWEU2HpFFXFMA3VekIiMy1n401juhQDJAwATjlU7tV+X5f+Mw
	 OiYRCb31o45qNXped3cAwFqUDu54n9QZpsktlqOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 119/267] wifi: cfg80211: free beacon_ies when overridden from hidden BSS
Date: Wed, 21 Feb 2024 14:07:40 +0100
Message-ID: <20240221125943.717146965@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e35c54ba2fd5..f3a957f2bc49 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1294,8 +1294,12 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
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



