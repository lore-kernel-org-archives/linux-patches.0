Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30DB25C6E4;
	Tue, 25 Mar 2025 12:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906185; cv=none; b=GQ9Z8vzou/eTnb04oKOdbNJhBVx8E1t6ONe3VbEx8PgbL3Pko9lViWncmAX6d/NnsvuAUmkF8J/1e40cYKVoYigZmHxUNii8vmLBrlzwn42J4gbcEOAwJMyhmVBW04Gh8b11pyndyU59D8AeZths//j620Jq7MRD9aXYp2X4MM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906185; c=relaxed/simple;
	bh=Nxr/u6hF2bvxiwY394g8b2CyDX3va03jtdQvNVlzc1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CByHsS1BPTVMuZogA+MP7Zg9HF0k2U20TRBuKisTvY3o1WJ1+CmWaVSW9nbDVHvvcU3G8T+Usr3trDQZCEKClEDz1tNeWy+PeZf6CyqfGjDowmcP38aAEGW6eAogkyb7UUzk1Mxfuy4wVn6R4RNi93AILrayb1kw6FV7c3k49IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1e+sW2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1e+sW2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A57C4CEE4;
	Tue, 25 Mar 2025 12:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906184;
	bh=Nxr/u6hF2bvxiwY394g8b2CyDX3va03jtdQvNVlzc1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1e+sW2amWmQLrYVvi1T7ZyGHKqRfEt1HmkfHpsZa4uCKtpGWXoXGfbeXpgRmAKvE
	 ncifKv0j/FakoFw6ndqBVVHqPHvApbDv6VzGiQXAfUDejJSif8KYBbzakgjEERXOel
	 beq+Nt6y1lsAfZutvhVzc9MAqbDDMw6cIeJP3p3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChiaHsuan Chung <chiahsuan.chung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 60/77] drm/amd/display: Use HW lock mgr for PSR1 when only one eDP
Date: Tue, 25 Mar 2025 08:22:55 -0400
Message-ID: <20250325122145.920109552@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit acbf16a6ae775b4db86f537448cc466288aa307e upstream.

[WHY]
DMUB locking is important to make sure that registers aren't accessed
while in PSR.  Previously it was enabled but caused a deadlock in
situations with multiple eDP panels.

[HOW]
Detect if multiple eDP panels are in use to decide whether to use
lock. Refactor the function so that the first check is for PSR-SU
and then replay is in use to prevent having to look up number
of eDP panels for those configurations.

Fixes: f245b400a223 ("Revert "drm/amd/display: Use HW lock mgr for PSR1"")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3965
Reviewed-by: ChiaHsuan Chung <chiahsuan.chung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ed569e1279a3045d6b974226c814e071fa0193a6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
@@ -69,5 +69,16 @@ bool should_use_dmub_lock(struct dc_link
 	if (link->replay_settings.replay_feature_enabled)
 		return true;
 
+	/* only use HW lock for PSR1 on single eDP */
+	if (link->psr_settings.psr_version == DC_PSR_VERSION_1) {
+		struct dc_link *edp_links[MAX_NUM_EDP];
+		int edp_num;
+
+		dc_get_edp_links(link->dc, edp_links, &edp_num);
+
+		if (edp_num == 1)
+			return true;
+	}
+
 	return false;
 }


