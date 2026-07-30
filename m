Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE53A40926C;
	Thu, 30 Jul 2026 14:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421753; cv=none; b=H1T78Q0G9BzPQVgBE4FBKId/WOLrbp42sa6jJpOOOq75CLE3pWFF7mR2YT2Mt46Udh9rkS4DQ9Cf/EK6oC5nSswIf79BTqP7vGsbuncT1z4pAIzmJUcB93JFYz4OpiOj8PqnF1TvAP4vv6MXvAL6pwy3qlmAao8mE1bKppr886Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421753; c=relaxed/simple;
	bh=X/hM2ywqgT+Ya0QJcWWKsZwy6PgVBadNWq2dBSmGYZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTlndRs6VquOjuNt7bVZ3fcw/ydZz/3PAFox0lAwwOWzeCzfveDhvBRv+FMY1mmqPa6m6FKY6IlMiXIUqr+XWZeHFQr5QzfUzMkuoGYcf+jjFhwhHNnQpzFBYQxT0s2H6yNJ3EpfwMIxmx7/oL9als54uUgo4klw1ntGgP+OfyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1z5q7aE9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1z5q7aE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321D81F00A3D;
	Thu, 30 Jul 2026 14:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421751;
	bh=ExleSuI78gj433FTEXRAElscpRiYMgC6A+2M5sHrQDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1z5q7aE9MbqR2jNU1tDrac3BxN3Ii1Ojg9gw8OqzhvdXVIFbPpSisuv8GgeBdttnt
	 3GCKsM4Degumq05TLoaRwQCyCqUBhlEW3mg2iwWVMEd8WPdJN/NesuJG5Tb6YDJHUd
	 kdFYkWdN85vmXQ0LJ2vCgH5yR8L2PQ182qoBlRPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 208/744] wifi: iwlwifi: fix pointer arithmetic in iwl_add_mcc_to_tas_block_list
Date: Thu, 30 Jul 2026 16:08:01 +0200
Message-ID: <20260730141448.700725123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 55128caac7ed9f..14c813cf530f66 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -384,7 +384,7 @@ bool iwl_add_mcc_to_tas_block_list(u16 *list, u8 *size, u16 mcc)
 	if (*size >= IWL_WTAS_BLACK_LIST_MAX)
 		return false;
 
-	list[*size++] = mcc;
+	list[(*size)++] = mcc;
 	return true;
 }
 IWL_EXPORT_SYMBOL(iwl_add_mcc_to_tas_block_list);
-- 
2.53.0



