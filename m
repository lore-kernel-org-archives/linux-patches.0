Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5BD15705F;
	Mon, 29 Jan 2024 17:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548606; cv=none; b=bOMroCCpKxQvgZiu99733ChwNrdAyqRNr1ms75JJZXDFM0nMehi/QtDccqpX2FzuLaqqOLrz3R3sDtEngiDJFsn0ISrNej3Zpje4mh/Y8gQux7XAEAwzpVwU1OiTfVPRPKEC3ghYo/O4eZ8hy7PoMov6H5tAe6MkKokb4TZke8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548606; c=relaxed/simple;
	bh=jzIT87BCIs9xoDeqihXtHO08XK998n+wyYkRWVsgcwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RD+Jj+9aZyrYEz3l+lQan28/jTfvQ1mx1dLX0i3dORZveR5w64a/PzYa23f61deQni4YjgA11rKan4qAPS4GQH+Yce5UG5ArHOhFEggcru+DDFP3IUrm+xvzBGrBYNkbOX6HlhfK31Am0Y1+5b7P45fnnkWIgCGsgbP126plZXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xm3ho1VH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xm3ho1VH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F62C433F1;
	Mon, 29 Jan 2024 17:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548606;
	bh=jzIT87BCIs9xoDeqihXtHO08XK998n+wyYkRWVsgcwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xm3ho1VHuaivxoYvDvaYNHRItwvLUktHB6crDPUWssH05LyC7z+14zoWrJKSm04hV
	 DiG6v8FZP+livJGG5vPTprwJ3LDf1hlGKmBp9tmmZIxbQoDhVueF0oLqkzgWLeDHek
	 4HluQquSF5yXVQkqFwiRMV9Om9el7TkMjisAorrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.6 269/331] drm/amd/display: Align the returned error code with legacy DP
Date: Mon, 29 Jan 2024 09:05:33 -0800
Message-ID: <20240129170022.738993286@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <Wayne.Lin@amd.com>

commit bfe79f5fff1300d96203383582b078c7b0aec80a upstream.

[Why]
For usb4 connector, AUX transaction is handled by dmub utilizing a differnt
code path comparing to legacy DP connector. If the usb4 DP connector is
disconnected, AUX access will report EBUSY and cause igt@kms_dp_aux_dev
fail.

[How]
Align the error code with the one reported by legacy DP as EIO.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -956,6 +956,11 @@ int dm_helper_dmub_aux_transfer_sync(
 		struct aux_payload *payload,
 		enum aux_return_code_type *operation_result)
 {
+	if (!link->hpd_status) {
+		*operation_result = AUX_RET_ERROR_HPD_DISCON;
+		return -1;
+	}
+
 	return amdgpu_dm_process_dmub_aux_transfer_sync(ctx, link->link_index, payload,
 			operation_result);
 }


