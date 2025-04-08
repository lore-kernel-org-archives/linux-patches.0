Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9251B26A0E0;
	Tue,  8 Apr 2025 12:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116747; cv=none; b=lIrVHPI7jt6FFsclQ6lO2i4YQV3GaibL7xew12UoL9y6p1g8LUbluSO+YNbQJ6x2aUudP33ZjMQGg8KeC+c9JwMcAjPrCxUItuaxk+I6chxJKrQnY7pRIzz1dKtBgKWvYdFFRupQCzz7Wl3k4/tReJA3mrV9MMkcoO2wx7WXqs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116747; c=relaxed/simple;
	bh=bhaUW8cI5SeeAj1+cXU8wsquJjbkcR854bzMCqnYqNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N39uOelow1nkT928BZFRpm93I3gTIcbfewpNxACSkAqMvK7sj8p7WO1nxHTDP8lr1KoE9v4sUFobWZNFw44X1DpYfAQA87W55mudVh3vrjsPALrsrDnAHnHZPmd8R8szWWjZ+LqiNPN852LNk8iBX1ZQLxhcwa/8Ow6t2GOgrNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQpzvq/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQpzvq/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F48C4CEEA;
	Tue,  8 Apr 2025 12:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116747;
	bh=bhaUW8cI5SeeAj1+cXU8wsquJjbkcR854bzMCqnYqNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQpzvq/+ZEwrK5AhSI34qqgByfvbg5VPdPoBTHxLRbi9dbcPHcPZYf69HxHSyStjP
	 K+mR5QuDJEcCE+Fz2cmVcaGadt0Cz19w2qMYyVYoDfZ9cUK78iLeoOc0Q8SWexBELg
	 52yCP4CcR7ZFXS83LiTNMTMtaBLBn8FEcaEgXywI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 253/423] wifi: mac80211: Cleanup sta TXQs on flush
Date: Tue,  8 Apr 2025 12:49:39 +0200
Message-ID: <20250408104851.633930334@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Alexander Wetzel <Alexander@wetzel-home.de>

[ Upstream commit 5b999006e35ea9c11116ddff7e375b256421d0af ]

Drop the sta TXQs on flush when the drivers is not supporting
flush.

ieee80211_set_disassoc() tries to clean up everything for the sta.
But it ignored queued frames in the sta TX queues when the driver
isn't supporting the flush driver ops.

Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
Link: https://patch.msgid.link/20250204123129.9162-1-Alexander@wetzel-home.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 2b6e8e7307ee5..a98ae563613c0 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -685,7 +685,7 @@ void __ieee80211_flush_queues(struct ieee80211_local *local,
 			      struct ieee80211_sub_if_data *sdata,
 			      unsigned int queues, bool drop)
 {
-	if (!local->ops->flush)
+	if (!local->ops->flush && !drop)
 		return;
 
 	/*
@@ -712,7 +712,8 @@ void __ieee80211_flush_queues(struct ieee80211_local *local,
 		}
 	}
 
-	drv_flush(local, sdata, queues, drop);
+	if (local->ops->flush)
+		drv_flush(local, sdata, queues, drop);
 
 	ieee80211_wake_queues_by_reason(&local->hw, queues,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH,
-- 
2.39.5



