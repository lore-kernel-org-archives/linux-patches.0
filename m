Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A104C1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A237C433D6;
	Wed, 23 Nov 2022 09:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196093;
	bh=K+ITz+lLt9tzxt9nW+T7r8cYp5zE7bu9BcyMuS6Sv1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jz2rDD+xCZQIJA0C52JnOo2e/ydLthUXuoBgd1iTiOf9DOBNRtW56PxIAIU7bRj1c
	 S7ELYRsQQaSNGSjvb5j0r18uyb6AHdbbGY3qoTxafwLne/60vPnL08CgjUrnUd3PBm
	 JIVO5uLflFC0liChYd0oQTuW1OWHoVQt+UB6Uwog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 117/181] drm/amd/display: Add HUBP surface flip interrupt handler
Date: Wed, 23 Nov 2022 09:51:20 +0100
Message-Id: <20221123084607.423770761@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

commit 7af87fc1ba136143314c870059b8f60180247cbd upstream.

On IGT, there is a test named amd_hotplug, and when the subtest basic is
executed on DCN31, we get the following error:

[drm] *ERROR* [CRTC:71:crtc-0] flip_done timed out
[drm] *ERROR* flip_done timed out
[drm] *ERROR* [CRTC:71:crtc-0] commit wait timed out
[drm] *ERROR* flip_done timed out
[drm] *ERROR* [CONNECTOR:88:DP-1] commit wait timed out
[drm] *ERROR* flip_done timed out
[drm] *ERROR* [PLANE:59:plane-3] commit wait timed out

After enable the page flip log with the below command:

 echo -n 'format "[PFLIP]" +p' > /sys/kernel/debug/dynamic_debug/control

It is possible to see that the flip was submitted, but DC never replied
back, which generates time-out issues. This is an indication that the
HUBP surface flip is missing. This commit fixes this issue by adding
hubp1_set_flip_int to DCN31.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c
@@ -79,6 +79,7 @@ static struct hubp_funcs dcn31_hubp_func
 	.hubp_init = hubp3_init,
 	.set_unbounded_requesting = hubp31_set_unbounded_requesting,
 	.hubp_soft_reset = hubp31_soft_reset,
+	.hubp_set_flip_int = hubp1_set_flip_int,
 	.hubp_in_blank = hubp1_in_blank,
 };
 


