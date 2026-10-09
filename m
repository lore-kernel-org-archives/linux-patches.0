Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8684E36D1;
	Fri,  9 Oct 2026 14:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557262; cv=none; b=C3nAUhepVgegeqxYclPOFMEwHDXinkMTB6447o9FYbtS8hrddceOWe4w5AZTleiHT8Z8CKLgfu9Wgn16yIMblISxvGJzrYovabLGHR1B+Qhrng9y/VI+PaNwzaP2KWRJoxUgXgJffTe7X8V3/B9ycRfvu8MI4SjOS/SrwT62s9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557262; c=relaxed/simple;
	bh=BdbhP+iXhOGvvrMVu1lTDhDOYLrxbkW6xZoPPJqBWOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQyk57/O+0HfAHCIHq0rWMQyY/cOaagMnUJWlANah1FmyxzI49TvGRirYe+mWJ3E15Vh1of9VjvbeTAmVzU/YyScz3feNZFRm06KtH6XdiuGXO/9Dv70/ZtNhgTbmU4oNbAbRvA+3xWfZKPTIMi+tF1E4hhD6fmuzGwBwCu0CBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaNXqh0Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaNXqh0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A9B1F000FF;
	Fri,  9 Oct 2026 14:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557261;
	bh=8bXxg8pJJaxfQbfDidSRllaIxfXkuS86CqgrjywRvTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GaNXqh0QFC6QoXrT5GufUbmutxamBs3fUovD1DBPyXkidJCEDaMxCAr7OM3v2vKQh
	 VBR+/IiMSEvCMHGY8GD7JYcnhMFrT9M2Yjoi24bLOwxfn0gLtfMAW94fyq/M+C7/gt
	 hd+Ag2/rURuVHmUTMoiULUgIFESGzyNuu4inpCNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Zhang <george.zhang@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Arthur Heymans <arthur@aheymans.xyz>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 373/403] drm/amd/display: Preserve eDP mode on initial ASSR failure
Date: Fri,  9 Oct 2026 16:12:14 +0200
Message-ID: <20261009141001.034559353@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Arthur Heymans <arthur@aheymans.xyz>

[ Upstream commit 5e08102d1d336593160d1434261d50b0c0f6cbe6 ]

Commit 56d8ce9d8c17 ("drm/amd/display: Apply correct panel mode when
reinitializing hardware") made ASSR failure fall back to the default panel
mode unless eDP mode had previously been applied.

However, dc_link is zero-initialized and DP_PANEL_MODE_DEFAULT is zero.
Before the first call to dp_set_panel_mode(), panel_mode therefore looks
like a previously applied default mode. If ASSR setup fails during the
first link training attempt, the driver incorrectly trains the eDP link
using the default scrambling mode.

On a Google Vilboz Chromebook running self-built coreboot firmware and
PSP verstage, this leaves the panel mostly black with corrupted output
along the top edge.

Track whether panel_mode has actually been initialized, and only consult
the saved mode after it has been applied. This retains the recovery
behavior while preserving eDP mode during initial link training.

Fixes: 56d8ce9d8c17 ("drm/amd/display: Apply correct panel mode when reinitializing hardware")
Assisted-by: Pi:gpt-5.6-sol
Reviewed-by: George Zhang <george.zhang@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Arthur Heymans <arthur@aheymans.xyz>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ccb6c2702033f1002b45807fb3cc938760f26f78)
Cc: stable@vger.kernel.org # 6.4.x
[ sashal: Adjusted context to preserve the existing diagnostic-message formatting in dp_set_panel_mode(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h                                    |    1 +
 drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -1624,6 +1624,7 @@ struct dc_scratch_space {
 	struct ddc_service *ddc;
 
 	enum dp_panel_mode panel_mode;
+	bool panel_mode_initialized;
 	bool aux_mode;
 
 	/* Private to DC core */
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
@@ -91,6 +91,7 @@ void dp_set_panel_mode(struct dc_link *l
 	}
 
 	link->panel_mode = panel_mode;
+	link->panel_mode_initialized = true;
 	DC_LOG_DETECTION_DP_CAPS("Link: %d eDP panel mode supported: %d "
 		 "eDP panel mode enabled: %d \n",
 		 link->link_index,
@@ -1293,7 +1294,8 @@ void edp_set_panel_assr(struct dc_link *
 
 		result = cp_psp->funcs.enable_assr(cp_psp->handle, link);
 
-		if (!result && link->panel_mode != DP_PANEL_MODE_EDP)
+		if (!result && link->panel_mode_initialized &&
+		    link->panel_mode != DP_PANEL_MODE_EDP)
 			*panel_mode = DP_PANEL_MODE_DEFAULT;
 	}
 }


