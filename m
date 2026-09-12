Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4FD299943;
	Sat, 12 Sep 2026 07:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198846; cv=none; b=lAa6gDJHH25Fg2AgSapaxlFy/yr05XQ3jUp4PRKCUU3mP6Q95PprZcMXeMLeUTlqp5K3xwGwCew8vyQhdM4/6qGTk5XxHPlpo+wFg/kNpMWtpm6nTldq7DdcwfcYgT0vxR9Uc7yHACSSltzuqnT1KSpLG9bvynnNUT36L+ADKjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198846; c=relaxed/simple;
	bh=nnDQhqI47eEf9cDZj17qbKN0n1AWdpYixJBOhWRvDYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvrPfAsemQHFi7tOVS7nOm9Xrx5kyl8mkiMspGHk10VPwzmM6p2tRNd0d/E7tZvFvewGMGSh4nMnvxlTuOQqyGSTllPWyF7u8olEN/C84Dbp62CR2MK6VVxNIX1Q4+x/2Yrh3FmXJrbM6TMHbDAVynUXT1fCA1ff2VM1XnDab5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T750/Krb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T750/Krb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDBD1F000FF;
	Sat, 12 Sep 2026 07:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198845;
	bh=Q2w2pOjdXgOCrHHQXsN5PS7/5VcaEjdYQ7SGTchzslw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T750/KrbPI2R2QzTcbFqp++UJzY63T3UXVDSa7/BKt7q+jm8KwWnIfKbB2nfdMo9B
	 PKe/HNucupF/zyn4LKw4HOv31xvcFNuiL4AednkbJgDjWLO5chZd4l7YxdA0bS/sM9
	 wNLM/ds2ILUwQ1G8lKxZXr2t6KcpUic++M4mthFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0465/1815] wifi: iwlwifi: mvm: fix off-by-one in TXF key sanitiser
Date: Sat, 12 Sep 2026 08:36:55 +0200
Message-ID: <20260912065659.805894782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit f6a6c01cbc046f68e6916a7e047a1bc881c8c9ab ]

iwl_mvm_frob_txf_key_iter() tracks the last matched byte position
in loop variable 'i'. When a full key match is found (match ==
keylen), 'i' points at the last byte of the matched key. The
memset start offset should therefore be i + 1 - keylen, not
i - keylen; the current code zeroes one byte before the match
and leaves the final key byte un-sanitised.

Fixes: 12d60c1efc29 ("iwlwifi: mvm: scrub key material in firmware dumps")
Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715220243.355998ec4fbe.I40f3427657b897e911bdf4ebf8e494745508d126@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 2297392db9558..b07a78524bcc8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -954,7 +954,7 @@ static void iwl_mvm_frob_txf_key_iter(struct ieee80211_hw *hw,
 		}
 		match++;
 		if (match == keylen) {
-			memset(txf->buf + i - keylen, 0xAA, keylen);
+			memset(txf->buf + i + 1 - keylen, 0xAA, keylen);
 			match = 0;
 		}
 	}
-- 
2.53.0



