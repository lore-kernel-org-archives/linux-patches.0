Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CF543E09D;
	Thu, 30 Jul 2026 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423874; cv=none; b=udfQg7oWULTUEM3jgzbMCI56zPuJVF0CJEwnnuPUBVd5rxHY4ASDthGJC8gK6DFMfv/TL1XAHlz3mYpKlp0K0nlWcjBp8Lqb7b4dVlXxOT+PsXH+t/HlRUQfiWpncqChm2dRkIWYZN47kQW8cLCGWjUlsEtxI48GQtPOFMLMFOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423874; c=relaxed/simple;
	bh=zDBxj03Ie+uHZo4jBR7bGlgtv+83sK+zTyv8UBk4cGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOlIAosQ4hOIkzeZy29/CAQ3DhXhfm5xRH+dJa8+TNqQAXTy69Ji9TCC0bzShPLHmjM/pnXyYtmkmXDvn4/KcAJYHP1CGwywhObUQ61qNeUrf7fs5VBkhPplCDt9wRADPz+7vMGhUZzmA8r/8jaFArxnuudvZzT3mAS4QD6nRsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cu8wYgqI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cu8wYgqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992B61F000E9;
	Thu, 30 Jul 2026 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423873;
	bh=9WbvnjAroEsK3Zr/vSp755AofiRtGMK1OjRFbTuqvFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cu8wYgqIjB4L5fsKz/cSqxmQONop8xsBXE6sxQCkvF+YCHy7vh5TwLt5eC0oW6uSr
	 tQ6+QrBKcSJ7Zvqhz0rF8a7kc3XYIsFmWeUQvkqxK495cAGwXi3skP2k3K19rREffQ
	 SnEmmheMyIxWW09MTkDwp21vSFgFWgclcln3eC3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 196/675] wifi: iwlwifi: fix pointer arithmetic in iwl_add_mcc_to_tas_block_list
Date: Thu, 30 Jul 2026 16:08:46 +0200
Message-ID: <20260730141449.310118258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

[ Upstream commit bc796f84ec9a95b356959ec7caf1d4fce33f3a76 ]

The expression list[*size++] increments the pointer 'size'
rather than the u8 value it points to (operator precedence: ++
binds to the pointer before the dereference). As a result the
block-list entry is written at the correct index but *size is
never incremented, so the caller's count stays at zero and
subsequent calls overwrite slot 0 every time.

Change to list[(*size)++] so that the value pointed to by size
is incremented after use as the array index.

Fixes: 5f4656610edb ("wifi: iwlwifi: extend TAS_CONFIG cmd support for v5")
Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.d2cd92242582.Ife4140a4e27be2a1cd9f886c5a9b376ce182a019@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
index e1f28b0532530a..818eb1c4b158f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -483,7 +483,7 @@ bool iwl_add_mcc_to_tas_block_list(u16 *list, u8 *size, u16 mcc)
 	if (*size >= IWL_WTAS_BLACK_LIST_MAX)
 		return false;
 
-	list[*size++] = mcc;
+	list[(*size)++] = mcc;
 	return true;
 }
 IWL_EXPORT_SYMBOL(iwl_add_mcc_to_tas_block_list);
-- 
2.53.0



