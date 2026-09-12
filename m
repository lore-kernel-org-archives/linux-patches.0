Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AE73624A5;
	Sat, 12 Sep 2026 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207481; cv=none; b=X/us+7mjo+qxxBBLlgDFx6V81IeA4jCIYNbt7IA72Nnktus1N+ABxXn6yjA9GlAerD1ChO6GK+7iR2BsaGSm+zc6N4fpHKddnxvy48Ul2aiqFZWtIjW/uIFaKE8T9ht0I75+4o1xthKDiVQDyZBPKPZOgT88hV5LN9Wkg5/4S6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207481; c=relaxed/simple;
	bh=XVwqDBkg+3Y5nQhi+zDijf2McLmEXfkhF97UEdz25jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5sS6tXEokzjOZZ2ygoDKF7sc8V+qJCUGI17viZrX7U3Bshr9RLfvUpoz9XE12Ztdwh/Va7ilWjrM7EmjRpNQ/SmiELWrhqolsnrUZt8VesMR24glrcylFqW+88MdEnkyhpA46RlhdLc/i8LGOOBpNWQSsut1XV3duzrBCyl5z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oh5IJf2p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oh5IJf2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCCD1F000FF;
	Sat, 12 Sep 2026 10:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207480;
	bh=JmOSY4PPQUFUkDwLZ9jvl4OwB2112zzHKinZ9Isb+k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oh5IJf2pDBUu1FnQXhFGClU3Woqu4mr+mKWkXB/93NkIEsmf88FKkbOFXU6f/4Lon
	 XJ4GVNYUBvXIZuASy4CxotLP1bLwbPfpBYmguIxNlAbuWMNriJ9wL6cvohR+/9ph4U
	 n7rA2uxq+IvW42qwHnO3UiCQKj1IIZM+jjFVHwDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0422/1518] wifi: iwlwifi: mvm: fix off-by-one in TXF key sanitiser
Date: Sat, 12 Sep 2026 08:43:11 +0200
Message-ID: <20260912065632.997991408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8e6913c7712f0..d6a13174b5617 100644
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



