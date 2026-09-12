Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0498630AAD8;
	Sat, 12 Sep 2026 14:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223383; cv=none; b=MylzPo6a4suhkd0oAHhsBQ8hXhH3iNF1ghik05QjRaiyo82ckJn+kK177vrFZ7kl209stcwgQia1iK/Bj6l5bY25egB4KGpf+rJM35eimY1tQNjR5RhEOluul8D5L1OEmRNoXO4sADc/lDUqcXoXhyF3PVYA6FFbgyfa45S65KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223383; c=relaxed/simple;
	bh=d2ANAvppj+l5RK6NvvV2pphEa4icafWhMQx53MaHuoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaIjkprJ8KkL043HUCJ3dQaAm3u/EmzNVDSRT4YSYFIb+F2ed3KTQpr7JuyOsNyE1NQRHb4MTwL0g8pY2gRDX+tRVYeiyz7G3lAz+GeAju5FZsPVZu32SUNf/lEOO61eHHG1RE+vzqQAyK2TtQR43mx0szgMoaaXhHGIj4bjSPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezQzlspq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezQzlspq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D231F000FF;
	Sat, 12 Sep 2026 14:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223381;
	bh=qvn3SuW4CCTx+FfM7dmACl52ISCdlHRnsk8H7jNPN4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezQzlspq+rjk8CFsUZcmGUs61fJqjffzjR/czupT/Kap3qaF0jzXB7qZzwsijjMB/
	 Z1pc05uVddNXKVYC7/81fjYT5ZEoEhAAm6COaxhGQcTABBExanG9riNH+apZeIyOpo
	 bhQKxdb6QRmBMh/GdHvxkHryHpSQn8MdMOK3VC4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0779/1424] wifi: iwlwifi: mvm: fix off-by-one in TXF key sanitiser
Date: Sat, 12 Sep 2026 08:53:31 +0200
Message-ID: <20260912065624.743547774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d2dbbc9fe3844..7ed684d638bd7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -858,7 +858,7 @@ static void iwl_mvm_frob_txf_key_iter(struct ieee80211_hw *hw,
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



