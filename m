Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDD115C127;
	Mon, 12 Aug 2024 16:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480666; cv=none; b=n9sGxKJcERpXQo1OdlycUnIq0LIwh58SY2DaMlSer3jh7QqMDf0aQvQ8eC3Ys+DgGsSWqJBYe1DnK6VwZT+06Nf1S6vpUtnbJR8qpQukKDVTp2prgasXlFrWfJ/eXDQLrpQjwKimq8dtop60I5D3Ead5DuZmkC+vWyV8veyLikA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480666; c=relaxed/simple;
	bh=eRezweB8NYDCdswoqnNSFa8M75l9IHWZqnZYDa04iMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDzc/rkETQIvDrqEvN47u1YlCTqD7adGZvx3nUueQKLVS0e6S9iCRyQqBWo2GNXeC/ToirVO6XnVI2Fz24/lxJO6JjjU2dGq32qBGnsM9dbRo3tJ8CBYo5UZixWF+vThiLT5Wt70rgHhl7LuQS1912qmdJ6cFjX8rACAncGK/M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJKAZfog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJKAZfog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872A6C32782;
	Mon, 12 Aug 2024 16:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480665;
	bh=eRezweB8NYDCdswoqnNSFa8M75l9IHWZqnZYDa04iMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJKAZfoglhpNUi/7c9qhoswt9P6CFg5cxgQJVVvL5KM1rQRv+rEmYMGPpTZk6xTyD
	 Pab73fnGQxvOHVUA0RznpcKGd1IynwjugLzmIYT1PSTeBwKj8988X+CEBopyw+95JQ
	 iIWgy8uQTXzvV5uK9wuhVsqgUOe7AMTXslq0VXvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Natanel Roizenman <natanel.roizenman@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 255/263] drm/amd/display: Add null check in resource_log_pipe_topology_update
Date: Mon, 12 Aug 2024 18:04:16 +0200
Message-ID: <20240812160156.306003343@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

From: Natanel Roizenman <natanel.roizenman@amd.com>

commit 899d92fd26fe780aad711322aa671f68058207a6 upstream.

[WHY]
When switching from "Extend" to "Second Display Only" we sometimes
call resource_get_otg_master_for_stream on a stream for the eDP,
which is disconnected. This leads to a null pointer dereference.

[HOW]
Added a null check in dc_resource.c/resource_log_pipe_topology_update.

CC: stable@vger.kernel.org
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Natanel Roizenman <natanel.roizenman@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2267,6 +2267,10 @@ void resource_log_pipe_topology_update(s
 
 		otg_master = resource_get_otg_master_for_stream(
 				&state->res_ctx, state->streams[stream_idx]);
+
+		if (!otg_master)
+			continue;
+
 		resource_log_pipe_for_stream(dc, state, otg_master, stream_idx);
 	}
 	if (state->phantom_stream_count > 0) {


