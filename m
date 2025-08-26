Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F9D352FF2;
	Tue, 26 Aug 2025 13:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216305; cv=none; b=QoloROF65aK1eHPmP0g+8i+OCwmQNJFU7cpN4ywEzyAPqjJ07kvJz9N7ySg3/XMXln9uZtd/TiV2Zh+0EBRpAMtMHk9H21Z65Zp9CUGvgREOEwIyiWPvsrDXGtGQJ94M0DEh/b3U+bo6oejVUWE8pp+BKUNYY9B/QacNeXwkkN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216305; c=relaxed/simple;
	bh=MZCD2Pgczw6+OxF9ym4/BkHkT6cM0TuU1mNQed3UwPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5slD83NNzlTGLOXNjpUwhy+ow83tNVrcVtlShKs22Etar3aj86rfwpyLitW6tnENneXIedNEkyvU/EIWFgegZBmTr3HRHIRhlFLuPfHwTpIIva7NWqHwM6yi0Nw3jjqly3CKSycFQLeg+s6+ap94KtFaZ/dkWie7B4swh2EUxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuea4F6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuea4F6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D728EC4CEF1;
	Tue, 26 Aug 2025 13:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216305;
	bh=MZCD2Pgczw6+OxF9ym4/BkHkT6cM0TuU1mNQed3UwPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uuea4F6FZ5okcqWeEz9moc5vUfX3WTqb+QvGniC9VOHRYkF28FtbzAMe2qtuQWwYE
	 1ldXOq41VYZlmSthaChLRL2YVREua3EidaXASmo0tJ5VlXaJb2Juaxp97QYWu1Juqf
	 E9eUQ7L0TQxX3qPZpBs2s62ObUwTC2Q/PEapXL18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 362/644] wifi: iwlwifi: dvm: fix potential overflow in rs_fill_link_cmd()
Date: Tue, 26 Aug 2025 13:07:33 +0200
Message-ID: <20250826110955.384227840@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rand Deeb <rand.sec96@gmail.com>

[ Upstream commit e3ad987e9dc7d1e12e3f2f1e623f0e174cd0ca78 ]

The 'index' variable in the rs_fill_link_cmd() function can reach
LINK_QUAL_MAX_RETRY_NUM during the execution of the inner loop. This
variable is used as an index for the lq_cmd->rs_table array, which has a
size of LINK_QUAL_MAX_RETRY_NUM, without proper validation.

Modify the condition of the inner loop to ensure that the 'index' variable
does not exceed LINK_QUAL_MAX_RETRY_NUM - 1, thereby preventing any
potential overflow issues.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rand Deeb <rand.sec96@gmail.com>
Link: https://patch.msgid.link/20240313101755.269209-1-rand.sec96@gmail.com
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
index 958bfc38d390..f44448a13172 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -2926,7 +2926,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 		/* Repeat initial/next rate.
 		 * For legacy IWL_NUMBER_TRY == 1, this loop will not execute.
 		 * For HT IWL_HT_NUMBER_TRY == 3, this executes twice. */
-		while (repeat_rate > 0 && (index < LINK_QUAL_MAX_RETRY_NUM)) {
+		while (repeat_rate > 0 && index < (LINK_QUAL_MAX_RETRY_NUM - 1)) {
 			if (is_legacy(tbl_type.lq_type)) {
 				if (ant_toggle_cnt < NUM_TRY_BEFORE_ANT_TOGGLE)
 					ant_toggle_cnt++;
-- 
2.39.5



