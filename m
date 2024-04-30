Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD38212CDA5;
	Tue, 30 Apr 2024 11:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475386; cv=none; b=n2BiAcywt/QyZ9ZI6mA2/8RYMsfQlg+zhQsBuAQE7UrHz+nrA4BMOM/FKryPzSd4R9zWK4FZsFvFj3rSqDe/oUDj7J+btT3clOsLktHB3OJ8VlZLoZRkVclR9UYkrE9C43OUGu8Q3Nyanyz6CMYO6Nmi0etQUs6wAB4ZLxXVGCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475386; c=relaxed/simple;
	bh=iw7S9ZWcidVGngfoATVxcafaGIBza+4tv/NsQrlMw3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZH4Snwv4xnc9kuHn0KHPb0sumuJsTZnwVeYg6MQyBklmjkXV8Qbduh2T0dAFhZSVF7Gzbi35m/GtRP9uLsc9hvd5z2Obs0xIMpPPbS9vfJYY30jzdDQIF5Q/IH7GfaI5+Z+/DR3VKfM49I75yX56un0UPT4kzQQ7+muCaznfezQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psi2o2ng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psi2o2ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CDEC2BBFC;
	Tue, 30 Apr 2024 11:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475386;
	bh=iw7S9ZWcidVGngfoATVxcafaGIBza+4tv/NsQrlMw3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psi2o2ngp08UGHlK1i3jV7AOxkj/gwLBix23xcfwoCxLue4qGZJF8g5mIh6WoLmHo
	 gy9BhgcnZgiRjMNDv7pqC7k162mrgdd3HVYl2TbMm/aRj5+Ja+jvgERwGVUw7yrxfw
	 RbyCySWBmRdrFLlWHrO2rR9xYkWr2tCWOGV2ULkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/186] wifi: mac80211_hwsim: init peer measurement result
Date: Tue, 30 Apr 2024 12:38:13 +0200
Message-ID: <20240430103059.223705218@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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
index f5a0880da3fcc..07be0adc13ec5 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -3795,7 +3795,7 @@ static int hwsim_pmsr_report_nl(struct sk_buff *msg, struct genl_info *info)
 	}
 
 	nla_for_each_nested(peer, peers, rem) {
-		struct cfg80211_pmsr_result result;
+		struct cfg80211_pmsr_result result = {};
 
 		err = mac80211_hwsim_parse_pmsr_result(peer, &result, info);
 		if (err)
-- 
2.43.0



