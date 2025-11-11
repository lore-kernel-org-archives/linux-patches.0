Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6442A73451;
	Tue, 11 Nov 2025 00:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822160; cv=none; b=geYuj1LPw9IqLXyY7rJ9f+Iht+9IcvklROwKd2g+bGN5JELMpSUJ2boUJPZRiuk7SF/KxjOGdcxbCZb5w1siFU+kqlmIDT94grQzfzd69Fgh/9QP3azDqUo8nqQnRp5t9AiA1HMgniwTUx4jret8Ya6Wxp4rLdT+Zi30hufojGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822160; c=relaxed/simple;
	bh=xLeYgTjxS1iER0lp/IucKiH1HDPRMnvpWrfQ3Jo1VWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bz1PSf0eVpyKcLwOji+F5iio38u/adiTW8wAr8hno76mwpPxftx9QVyIRQnpTnaDsTeeHhFuiswFv4oyIFe/2AZnkV7nl3zhAF1AaE/MG8YKH7LdtcXDQCgEomjsMoVfYID9aL6S0KvAFVDrlua8y2MIX/NU9TEZkbVaX30EbfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYb/c17d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYb/c17d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BB3C113D0;
	Tue, 11 Nov 2025 00:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822160;
	bh=xLeYgTjxS1iER0lp/IucKiH1HDPRMnvpWrfQ3Jo1VWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYb/c17doY+Il5cAxyDFB8p3Mcg4t7EvN0mZgWsMABzTpISt/o2h47pIDZBYpYiHl
	 Gh5iba16PDEqNqUg+k463iqeMqOQyPsE8g9noEygOPrT/OvNaBws209tMCRVH9WPCO
	 qoYl3LnvEvOHsnnXIVdeSZq9QuP0xfb8fMJidOOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 041/849] wifi: nl80211: call kfree without a NULL check
Date: Tue, 11 Nov 2025 09:33:31 +0900
Message-ID: <20251111004537.431786559@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 249e1443e3d57e059925bdb698f53e4d008fc106 ]

Coverity is unhappy because we may leak old_radio_rts_threshold. Since
this pointer is only valid in the context of the function and kfree is
NULL pointer safe, don't check and just call kfree.
Note that somehow, we were checking old_rts_threshold to free
old_radio_rts_threshold which is a bit odd.

Fixes: 264637941cf4 ("wifi: cfg80211: Add Support to Set RTS Threshold for each Radio")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20251020075745.44168-1-emmanuel.grumbach@intel.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 852573423e52d..46b29ed0bd2e4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4012,8 +4012,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			rdev->wiphy.txq_quantum = old_txq_quantum;
 		}
 
-		if (old_rts_threshold)
-			kfree(old_radio_rts_threshold);
+		kfree(old_radio_rts_threshold);
 		return result;
 	}
 
-- 
2.51.0



