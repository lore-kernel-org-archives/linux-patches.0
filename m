Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B8237DE83;
	Thu, 20 Aug 2026 15:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238092; cv=none; b=C15rTaXipl+nVNChSX81PiQyXGDFhA1SaeGhXhGjwZFZpEpXVEF0oSakfkS6N7YN47Gj1ENPe3V6usPn6OsvrSggK103AfOrn+kskllfmGT6Yck1GlwqpUQV63KUQuf9AFXikNSDLe+zycAWRMhVGTGO+EnAQOOw4hHBHxOosR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238092; c=relaxed/simple;
	bh=NcNa3ggpMN/wQnx8ZSDbd402P/PhTgE5bVznhz5rWdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFHw4LghvK+0ZQWfJExlTg/nV3Kp3nI1EO96TgQlrrqt7uzGBgkUDCaWcOqR5yV3sHt/PpEQKLOugTqSSzgKHDZ9CIveFWwuH5VTrIZGW9VJ9++uaMpJkmNG3qPHk6vzBXrdZhb1nelapqk6C2prEuUq5qssM6Wf3uWvK7NkVIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uz2qWoAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uz2qWoAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776FA1F00A3A;
	Thu, 20 Aug 2026 15:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238091;
	bh=ru/FW0owK2xygn8+9Ikd/6DelPMTHQysJk6X/A9aYKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uz2qWoACfzNuglayymEcEuJVomSz3zYMasBQ1rtL3Gf9lM5yshSOdagkErfM0Ghs9
	 Mc823UJN9IufxBjGW9/KC0nNsemdRqXbMlD0A/AHXJo1KVEW8eHGqQKNzuM3XUk+Mq
	 GhOq6c/s7ukV8gyVh02LbiWeMZhjUtBJpvM2heww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Travis K. Bangs" <tbangs89@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 030/228] drm/amd: Disable DP audio spread spectrum for Cyan Skillfish
Date: Thu, 20 Aug 2026 16:52:52 +0200
Message-ID: <20260820145245.377228463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Travis K. Bangs <tbangs89@gmail.com>

commit ff209cd04845d819acc2fcc19b25904b4b7c3ea9 upstream.

The VBIOS for Cyan Skillfish devices (DCN201) indicates there is
DisplayPort ref clock spread spectrum downspread, so the audio clock
is corrected for it.

However, the clock source in this hardware does not seem to actually be
running with a clock downspread, so DisplayPort audio desyncs with video
after several minutes.

Ignore dprefclk SS downspread on CYAN_SKILLFISH2 asic.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5429
Signed-off-by: Travis K. Bangs <tbangs89@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f3a2d86587432fdd9a6d401507b60a01153453c5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2079,6 +2079,11 @@ static int amdgpu_dm_init(struct amdgpu_
 		init_data.flags.unify_link_enc_assignment = true;
 		init_data.flags.usb4_bw_alloc_support = true;
 	}
+
+	/* DCN201 audio desyncs using DP SS */
+	if (adev->apu_flags & AMD_APU_IS_CYAN_SKILLFISH2)
+		init_data.flags.ignore_dpref_ss = true;
+
 	retrieve_dmi_info(&adev->dm);
 	if (adev->dm.edp0_on_dp1_quirk)
 		init_data.flags.support_edp0_on_dp1 = true;


