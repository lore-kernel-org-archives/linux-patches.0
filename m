Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F8B1C6BA
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMece5VZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05612C433CB;
	Wed,  4 Oct 2023 18:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444613;
	bh=U/Vm6T6EGsFSKetjop8CDgESAfrljwvsy4bYpeW3nd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMece5VZmsAY5QFsLHfdpaSOC3TYindMbIcnUPQK9qKrU64ZoR0RAoFBfcjXkmwUs
	 KhSrstkiUKwjn3iE0CTjOmennqjo+uJophxZZVS30E+RE2rfi95rIC33J72SABOa3E
	 9WiR5Hc2FZUXGvNGsCsAA0lRJPpQeeAg4DBRUysM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Broadworth <mark.broadworth@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.5 313/321] drm/amd/display: fix the ability to use lower resolution modes on eDP
Date: Wed,  4 Oct 2023 19:57:38 +0200
Message-ID: <20231004175243.795243188@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

commit 2de19022c5d7ff519dd5b9690f7713267bd1abfe upstream.

On eDP we can receive invalid modes from dm_update_crtc_state() for
entirely new streams for which drm_mode_set_crtcinfo() shouldn't be
called on. So, instead of calling drm_mode_set_crtcinfo() from within
create_stream_for_sink() we can instead call it from
amdgpu_dm_connector_mode_valid(). Since, we are guaranteed to only call
drm_mode_set_crtcinfo() for valid modes from that function (invalid
modes are rejected by that callback) and that is the only user
of create_validate_stream_for_sink() that we need to call
drm_mode_set_crtcinfo() for (as before commit cb841d27b876
("drm/amd/display: Always pass connector_state to stream validation"),
that is the only place where create_validate_stream_for_sink()'s
dm_state was NULL).

Cc: stable@vger.kernel.org
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2693
Fixes: cb841d27b876 ("drm/amd/display: Always pass connector_state to stream validation")
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6062,8 +6062,6 @@ create_stream_for_sink(struct amdgpu_dm_
 
 	if (recalculate_timing)
 		drm_mode_set_crtcinfo(&saved_mode, 0);
-	else if (!old_stream)
-		drm_mode_set_crtcinfo(&mode, 0);
 
 	/*
 	 * If scaling is enabled and refresh rate didn't change
@@ -6625,6 +6623,8 @@ enum drm_mode_status amdgpu_dm_connector
 		goto fail;
 	}
 
+	drm_mode_set_crtcinfo(mode, 0);
+
 	stream = create_validate_stream_for_sink(aconnector, mode,
 						 to_dm_connector_state(connector->state),
 						 NULL);


