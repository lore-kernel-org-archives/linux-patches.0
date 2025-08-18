Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0CE320CBA;
	Mon, 18 Aug 2025 13:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524566; cv=none; b=dRHxnU9fNSYEvt7wRh5+9ws6D+7pBKecWrV8ImAjtoYReKJHvTEdhbFjB4FKal4gqkjayw0bzzedC+kxUwGB4iA0+1B2CZI0qX4FKpL4yw8EG8ELXW5zdpcDwXVFjkAfsoHh5X2FCQaqMNXgWDYaGcZohhxki9nf0X/4Q7u3wss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524566; c=relaxed/simple;
	bh=4Iy9ZGKqh9YSmMNU+R4l6RhTD0pmKATcaR6PqClgDjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhNxSPRrA7DCiOfyJK/0A0Bze1nqLW4NMgk8ou+ceDZLXnBsDPO5eHZ9gAKMs+O6MxY+cPHW3BJXzMOaqCmuHTA2aXR36BoxAruLW6XSWVcSDrbNkOOxzGUPvxpn6Kq3n2rcLVd9mophcH8h5fPd0MizeVsXEPQ9DzmgqOKZ9Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCKxIlxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCKxIlxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6494C4CEEB;
	Mon, 18 Aug 2025 13:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524566;
	bh=4Iy9ZGKqh9YSmMNU+R4l6RhTD0pmKATcaR6PqClgDjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCKxIlxAZK5yb8Cvi/rhsmPyWJT4PJlWNn8tZ/ok6MVDeqttlQKCLpKWUNFOXfVJ7
	 JDgmVYemYQ9IWr8CBBD1wL2KzLLsGnsFD7pE3iFFzFTesymUabCq8wmSt8G8hu4la4
	 VyGZZij4Cw6/OuayyHamCcLOinzRo3PZZeyEvfAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 512/515] drm/amd/display: Allow DCN301 to clear update flags
Date: Mon, 18 Aug 2025 14:48:18 +0200
Message-ID: <20250818124518.144959499@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Lipski <ivan.lipski@amd.com>

commit 2d418e4fd9f1eca7dfce80de86dd702d36a06a25 upstream.

[Why & How]
Not letting DCN301 to clear after surface/stream update results
in artifacts when switching between active overlay planes. The issue
is known and has been solved initially. See below:
(https://gitlab.freedesktop.org/drm/amd/-/issues/3441)

Fixes: f354556e29f4 ("drm/amd/display: limit clear_update_flags t dcn32 and above")
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -5335,7 +5335,8 @@ bool dc_update_planes_and_stream(struct
 	else
 		ret = update_planes_and_stream_v2(dc, srf_updates,
 			surface_count, stream, stream_update);
-	if (ret && dc->ctx->dce_version >= DCN_VERSION_3_2)
+	if (ret && (dc->ctx->dce_version >= DCN_VERSION_3_2 ||
+		dc->ctx->dce_version == DCN_VERSION_3_01))
 		clear_update_flags(srf_updates, surface_count, stream);
 
 	return ret;


