Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA70F27FB37;
	Sat, 12 Sep 2026 16:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229610; cv=none; b=WL5OfHZMbR818OEp8ihc8ralZvU8EWxuUQwe1CDFM1JxsPy8GcpULHSxjlaSsKFHa1g5NwTcp69L9kA6sxTYPqjmIOGnaNnuIOwV/FCc+QGEhOKySI1b/fQ62yJxwuqrNKmILvzVFLsAN2JFDgFpsrOr6BX3wUGThzie/MWYfhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229610; c=relaxed/simple;
	bh=OhE214boqK3ifOTf4Db6cgBytDfxI0V35sEEE+ONe68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhEviRIeu7WURfV9Lx4cC/XtLn/pwBlLMwAZvW7ZDxUcIZ4ttdx68QshhsqcN6+HL2zmZ3FzHo5snIx+8+A4aQ+GA8YKG38ct2C1pXrxXJXkzULH8nSmzwm0xT00L7zekXkwhWClYugEIyDZSSIikIGNXQMNYhKUE7cxvnDhaCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQyCnzcD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQyCnzcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9330D1F000FF;
	Sat, 12 Sep 2026 16:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229609;
	bh=3vAunRxSyGolB9z/gnGsLW/EKG4G330JdpXQqbBcAms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQyCnzcDPfR+ryZOpVvp1uzxVPm4j5rWwbk57jSDyuqzi39arQKmX48MpxcuwirkP
	 xXx68LFQVQNyMtI/y0pyOpMrQNxSY0A3VBmotEhgmfhDf7aO4AFpB1yI7CGM6U+7Iy
	 wKXTu1hdY7wEcVrajfIYz1xQSeKSg5u3suUhLXLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0625/1191] wifi: iwlwifi: mvm: fix off-by-one in TXF key sanitiser
Date: Sat, 12 Sep 2026 08:55:53 +0200
Message-ID: <20260912065602.291296311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 64cc1e1bbb479..591c073bf0a98 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -826,7 +826,7 @@ static void iwl_mvm_frob_txf_key_iter(struct ieee80211_hw *hw,
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



