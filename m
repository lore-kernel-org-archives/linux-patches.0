Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852083BE643;
	Sat, 12 Sep 2026 12:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215809; cv=none; b=dM2wOnEwSiOZE0LCwMY+7n2rIGthe9nNzi+xFVg39BBwbsdMUZhRjy1L26PetIOMtheh8DtSNvFQo5VqMmm1ZqGVZtQ9wms1UXrDpbCiat5plXfBiQwg1XxDznfsV1Wyz1XnhdTgcUc/GBPdrkMLrROwgBf80o8qAVIzfv1+SBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215809; c=relaxed/simple;
	bh=LZGqLlYw9R66lkQcX0/rCtuZQ3bwRj8vCTUiIlSoexw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjuCL45bfc+Sf5sBQPJKxlGupM/gug+kP/S9MwkAK/ZtCcweEW8LNozQNqC3icO4adOGdu3W2PzTkhXrpFLgkBPKfFFvBdUtVE3CaAm1W/3x0XDFPPZcim6BNPN/m7Zs7kuM8uCcHYdNCgl76+O+38AcZUe7NZfIGd9EG89s7Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGRuxLAg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGRuxLAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890BF1F00893;
	Sat, 12 Sep 2026 12:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215808;
	bh=SCpBL8WutVzGSiB3B+tJ1kxc0vR/Di3GS/vzHX/ic5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yGRuxLAgoxuhjgzfxJv5QguII2MSasVPqegUDnXhDGKfCMR7OK6h9NDpLq6lGP8B1
	 Cgjk135Xv31pW2MbF1V8PTf9g6Jh6hH+CZqp8uGAPqhL68rBX/IiiEy10UmKxpPQZg
	 X4r7wLEu/vlAAE3SDoexGd6ZcXViGn9/V5iOBPuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0565/1376] wifi: iwlwifi: mvm: fix off-by-one in TXF key sanitiser
Date: Sat, 12 Sep 2026 08:49:51 +0200
Message-ID: <20260912065620.125350711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a7dbc0a5ea84e..96de7edf17929 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1010,7 +1010,7 @@ static void iwl_mvm_frob_txf_key_iter(struct ieee80211_hw *hw,
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



