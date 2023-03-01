Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FC6847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C8BC433D2;
	Wed,  1 Mar 2023 18:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694358;
	bh=WmmSo+PPUSiilOX17OKFwDqRZ5c4dlqDWEOHhDSRDlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ym8UsEAS5aQ3OPfpJwBTPOD1q3mYmVSDuvdwrrgFdX65ACL6NpsvIkHEBU2DuuBM3
	 rEr9X4l0ch4jG3VQEPeZfqjqxBhqjjbe9IYrB/ctAii27xzS3XyJr9bI0weIDgmmjz
	 UX19ySwxNj2ck5SZsb519S6JwGDOcdqnKWUQfh80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Solomon Chiu <solomon.chiu@amd.com>,
	Alan Liu <HaoPing.Liu@amd.com>,
	Stylon Wang <stylon.wang@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <mario.limonciello@amd.com>
Subject: [PATCH 6.1 35/42] drm/amd/display: Properly reuse completion structure
Date: Wed,  1 Mar 2023 19:08:56 +0100
Message-Id: <20230301180658.624349421@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stylon Wang <stylon.wang@amd.com>

commit 0cf8307adbc6beb5ff3b8a76afedc6e4e0b536a9 upstream.

[Why]
Connecting displays to TBT3 docks often produces invalid
replies for DPIA AUX requests. It turns out the completion
structure was not re-initialized before reusing it, resulting
in immature wake up to completion.

[How]
Properly call reinit_completion() on reused completion structure.

Cc: stable@vger.kernel.org
Reviewed-by: Solomon Chiu <solomon.chiu@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10251,6 +10251,7 @@ int amdgpu_dm_process_dmub_aux_transfer_
 	ret = p_notify->aux_reply.length;
 	*operation_result = p_notify->result;
 out:
+	reinit_completion(&adev->dm.dmub_aux_transfer_done);
 	mutex_unlock(&adev->dm.dpia_aux_lock);
 	return ret;
 }
@@ -10278,6 +10279,8 @@ int amdgpu_dm_process_dmub_set_config_sy
 		*operation_result = SET_CONFIG_UNKNOWN_ERROR;
 	}
 
+	if (!is_cmd_complete)
+		reinit_completion(&adev->dm.dmub_aux_transfer_done);
 	mutex_unlock(&adev->dm.dpia_aux_lock);
 	return ret;
 }


