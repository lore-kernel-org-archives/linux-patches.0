Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F49145B3E;
	Tue, 26 Aug 2025 12:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212996; cv=none; b=D8Wl+pXyc81Hc/pU0WUdxISS+6sTRTRbl0lJNmC6/xSHjGc/TE7mZGkQTtJNgN4je+g7fpSGl+4hiFgGH3peZBWAwqYhRlX7yADosmMVnxN6+1AYn4WSeMvCHwSJHn0KjlTdlEzFOflyv9cbgdiGPlt0Qjd4TFSbDXvuvkXsEXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212996; c=relaxed/simple;
	bh=MV3onLz/Tai9CDwer0NzcxVtOzDEuYsvAtw+dz/+9y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9mK/ddzGQupfNB22DqZ6ibMV471icoSjq5gc8J7QjxbvBFYlBCn1HwI3xQs7Bp/VKDvb4MSAc12d3ca5FvfLVP09eyhzN1BfgnYcw7ADr5Dtr9N68GYA9AWAXkGlGbslbJ5WONEAFnofr9pwcSQ+5s4Y6A6wwd7AJ67KR5YM70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIn8xOb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIn8xOb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939C4C4CEF1;
	Tue, 26 Aug 2025 12:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212996;
	bh=MV3onLz/Tai9CDwer0NzcxVtOzDEuYsvAtw+dz/+9y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIn8xOb2WB9voMzckBUJ+2PXyzARJCD11hm0PXbyH1vOgUM2JYDwrT3p8XCAT4X5K
	 RoWfdTK9sen/Kbl94k7WS6va3+I/Rqm/d8tzDqZkLeiCVUaSG+c4CPDXOwj/5Rvger
	 s8ddcGTcS1SR3/dRi4Vg55EgV53nYSU/P5cVjY6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/587] wifi: iwlwifi: dvm: fix potential overflow in rs_fill_link_cmd()
Date: Tue, 26 Aug 2025 13:05:30 +0200
Message-ID: <20250826110957.547007945@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f4a6f76cf193..e70024525eb9 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -2904,7 +2904,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
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



