Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61A9847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C40DC433EF;
	Wed,  1 Mar 2023 18:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694159;
	bh=SGeZvXxVid3oFCksruJnbpOvkqzy8S1ahmZ+YWSsJ3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuF26BJkI796zNgQds3f2oqcFDZYIDC04lJpJ+hCt9IHnm1f7OOkteUCM8ASniIdD
	 AGIgCcV5ziGQ38n5k40rnTv35EIl2FEGPK/Xm0Ma7ugJtxLvqVI09GV8LX2aj5xYeX
	 XeR4hAEExnUOlXWl4b4sPE2A9vCnyZh5z7zYvRKQ=
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
Subject: [PATCH 6.2 06/16] drm/amd/display: Properly reuse completion structure
Date: Wed,  1 Mar 2023 19:07:42 +0100
Message-Id: <20230301180653.525477944@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
References: <20230301180653.263532453@linuxfoundation.org>
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
@@ -10359,6 +10359,7 @@ int amdgpu_dm_process_dmub_aux_transfer_
 	ret = p_notify->aux_reply.length;
 	*operation_result = p_notify->result;
 out:
+	reinit_completion(&adev->dm.dmub_aux_transfer_done);
 	mutex_unlock(&adev->dm.dpia_aux_lock);
 	return ret;
 }
@@ -10386,6 +10387,8 @@ int amdgpu_dm_process_dmub_set_config_sy
 		*operation_result = SET_CONFIG_UNKNOWN_ERROR;
 	}
 
+	if (!is_cmd_complete)
+		reinit_completion(&adev->dm.dmub_aux_transfer_done);
 	mutex_unlock(&adev->dm.dpia_aux_lock);
 	return ret;
 }


