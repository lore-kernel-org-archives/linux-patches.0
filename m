Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4583322755;
	Mon, 18 Aug 2025 13:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525572; cv=none; b=jbYpWLz7fCJcScttmcqdeyjKtTs0Cetn2kEWcY1GKJEIKQB2ebraN2L/X5fQg6/rT3aUGOHxykcYharaDjQX4Rg8nNRxRWA9uccASF8s6+Y/yAwlxqURZbqlnEkiFVlEn8WMah1dOOfvaOZRph81EvkDKf1EtzQvYPa22HPhmwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525572; c=relaxed/simple;
	bh=FbTiKJiypmt8kf9Fx7tky3tt5jEVfoAsx9AjmjSVnoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7werR3up80idxeN3HLUFOoAAyz1gY5kSeB0WSA/ihyxXHKR8KQa8Tr8CxhGet41ENE9aAqPSmD/A+uzN0DnfSyf0ZebHxt5luhWHbchz8WlPAmRxTaIVdwdpX1bePwCuAvzNoyitXYeIO0im1e8fdeUypYWdp0AbPXpqGH/vZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dUS+LaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dUS+LaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE86C4CEEB;
	Mon, 18 Aug 2025 13:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525572;
	bh=FbTiKJiypmt8kf9Fx7tky3tt5jEVfoAsx9AjmjSVnoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2dUS+LaGzGNa2iCUXbHRgbkPfJ68Qii1tNRBbRTQ0ioOFkqPQiJP5IQnupOONiKWF
	 esLNGV8my+bXSF2uEFB7sROi3zjSlfrs+jZK+mCoAUvcyga7uobE9Hn/UcXtxBQ41Y
	 actu6o5ZAazOSI4iv8HwlDrYZLgkmVUmeF24+d+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 302/570] wifi: iwlwifi: dvm: fix potential overflow in rs_fill_link_cmd()
Date: Mon, 18 Aug 2025 14:44:49 +0200
Message-ID: <20250818124517.494855358@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 8879e668ef0d..ed964103281e 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -2899,7 +2899,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
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



