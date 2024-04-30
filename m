Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B033F12C46B;
	Tue, 30 Apr 2024 10:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474056; cv=none; b=PLV52Z0Fn7QCAKjS9G9hTz/Gdu1SVFDNa1NAwDUvNhtnPmeCVLBzP6RHwjj2hrnXv3hIa2nTRC3MpvUHiN778KewCScGdv2QOLVesIe3APjuGskGKRiq+jCIwW86qj4yNAfGseey+O+kGsdDtjfCLpgR4bxm2dkl6R0m7HSw8I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474056; c=relaxed/simple;
	bh=eSwh8JzyUkSRYYb1oRTPp+JSMR7+ugvwgLxjL4WlhOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8L46Cv777ZkZNryj4RF7jpabTnuOVFXaYJXuH4sO0uZzQRFFii+NwqqnoAZCWO0K+LpUUml33hH/YNgFbvQLAPhv8F+VXqOtjTVe8epcCewH18ur5maPvuqAPfhyut+H5+CX3BLYPqHQFICo3+/+vEKb23HiV8lskeba9/7aGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1vdIYVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1vdIYVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25204C2BBFC;
	Tue, 30 Apr 2024 10:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474056;
	bh=eSwh8JzyUkSRYYb1oRTPp+JSMR7+ugvwgLxjL4WlhOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1vdIYVleo1mN12zcvJdm6k5EK6AQrzs5icm2FpJzg5jieA85o2RuMuNWMlD4v0Wp
	 ftyS/q5vWz0gwvZUA4rqu3i43XaBm/AS87h8f5EvAZcwPUXTJI6MbFWZ3m/X9ZNf3b
	 gB+52QrmT6I5+6huFvyY6g5tmpqV/mZ46CiLWFWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 045/228] wifi: mac80211_hwsim: init peer measurement result
Date: Tue, 30 Apr 2024 12:37:03 +0200
Message-ID: <20240430103105.112806808@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2a4e01e5270b9fa9f6e6e0a4c24ac51a758636f9 ]

If we don't get all the values here, we might pass them to
cfg80211 uninitialized. Fix that, even if the input might
then not make much sense.

Fixes: 2af3b2a631b1 ("mac80211_hwsim: add PMSR report support via virtio")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240418105220.e1317621c1f9.If7dd447de24d7493d133284db5e9e482e4e299f8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index a84340c2075ff..a9c3fb2ccdcdb 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -3818,7 +3818,7 @@ static int hwsim_pmsr_report_nl(struct sk_buff *msg, struct genl_info *info)
 	}
 
 	nla_for_each_nested(peer, peers, rem) {
-		struct cfg80211_pmsr_result result;
+		struct cfg80211_pmsr_result result = {};
 
 		err = mac80211_hwsim_parse_pmsr_result(peer, &result, info);
 		if (err)
-- 
2.43.0



