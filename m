Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A5619755E;
	Thu,  5 Sep 2024 09:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529882; cv=none; b=JBKvfb6CXk+PciDeX9EHzLGavuaqQmmY7PKI++wUnAaFWpyk4BqBxbxmpjreRVI6jYBPHpNclpkTfEXY3gaTErdjJ0yZTsEzLBZSDRZixs7HxJuY2fZFbmzHiRtcC/llxLyzI6w4zYeFI9Di/qUpL62EbHHq9fK2Jtb/6AB+DUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529882; c=relaxed/simple;
	bh=F2jqXMTyEphzrx0diXfzsLTxfws4PcTUBxQ8ycjyKck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R68fxP84NRT0Uj3SCJNf0fk6apWPjI/D7ZyO+eiUsfezCqqaWfvywuF9rDLUdzQ/niMDfJGcCSHy7t8GM+wzzYJm1lbvNsoxLfUAcrE0h401lEzKZULBUAuZkpMStaW23Y/tTL2WZyTMpsYD+8I06wbbVhis7FAJOcj+BIEJflo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBLLO6J9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBLLO6J9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0348AC4CEC3;
	Thu,  5 Sep 2024 09:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529882;
	bh=F2jqXMTyEphzrx0diXfzsLTxfws4PcTUBxQ8ycjyKck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBLLO6J9ore+tZo/RyD8FHgEPcjh/Mf5OJlXi5uAZWjsUIwjZ1GA6Ls5ZqK7ooHu5
	 5Inu3cZOyPlvOZ2tSu1BEr5qH4N3VtBQTej7wY5ietLHzZKqJt9BlZ26+wu1Xpd7x5
	 jEQgQl0lQOAbBU2on+y49VZlwWIpB5Q4JK/4N/RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 172/184] drm/amd/display: Disable DMCUB timeout for DCN35
Date: Thu,  5 Sep 2024 11:41:25 +0200
Message-ID: <20240905093739.053077760@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 7c70e60fbf4bff1123f0e8d5cb1ae71df6164d7f ]

[Why]
DMCUB can intermittently take longer than expected to process commands.

Old ASIC policy was to continue while logging a diagnostic error - which
works fine for ASIC without IPS, but with IPS this could lead to a race
condition where we attempt to access DCN state while it's inaccessible,
leading to a system hang when the NIU port is not disabled or register
accesses that timeout and the display configuration in an undefined
state.

[How]
We need to investigate why these accesses take longer than expected, but
for now we should disable the timeout on DCN35 to avoid this race
condition. Since the waits happen only at lower interrupt levels the
risk of taking too long at higher IRQ and causing a system watchdog
timeout are minimal.

Reviewed-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
index 28c459907698..915d68cc04e9 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
@@ -785,6 +785,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.ips2_entry_delay_us = 800,
 	.disable_dmub_reallow_idle = false,
 	.static_screen_wait_frames = 2,
+	.disable_timeout = true,
 };
 
 static const struct dc_panel_config panel_config_defaults = {
-- 
2.43.0



