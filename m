Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90739440
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CF4C433C8;
	Sun, 16 Jul 2023 20:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539010;
	bh=W2UgJ+hedM1B6F6FfMGqC1QdqXRvk8fzBDvoihpBkhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNkjawTnbKQ8QAn0UB9Bpz6lXJX3bjKbXPVBG4PbNRhHpaEd6PKdRhYKcIo2d9ng3
	 ZjBgsrSql+9EnuB5woUIPcZPwznEjJq6evgAqjnUfWbYbn5LUn5nQ1phvtzvsfRYzP
	 C6ghRTU84AkaQoCjL3MLpXoVlLMRp2fkS7Z8SwdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 654/800] drm/i915/psr: Use hw.adjusted mode when calculating io/fast wake times
Date: Sun, 16 Jul 2023 21:48:27 +0200
Message-ID: <20230716195004.302673518@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 5311892a0ad1d301aafd53ca0154091b3eb407ea ]

Encoder compute config is changing hw.adjusted mode. Uapi.adjusted mode
doesn't get updated before psr compute config gets called. This causes io
and fast wake line calculation using adjusted mode containing values before
encoder adjustments. Fix this by using hw.adjusted mode instead of
uapi.adjusted mode.

Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>

Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8475
Fixes: cb42e8ede5b4 ("drm/i915/psr: Use calculated io and fast wake lines")
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230620111745.2870706-1-jouni.hogander@intel.com
(cherry picked from commit ef0af9db2a21257885116949f471fe5565b2f0ab)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 6badfff2b4a28..b7cbc780e672f 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -851,9 +851,9 @@ static bool _compute_psr2_wake_times(struct intel_dp *intel_dp,
 	}
 
 	io_wake_lines = intel_usecs_to_scanlines(
-		&crtc_state->uapi.adjusted_mode, io_wake_time);
+		&crtc_state->hw.adjusted_mode, io_wake_time);
 	fast_wake_lines = intel_usecs_to_scanlines(
-		&crtc_state->uapi.adjusted_mode, fast_wake_time);
+		&crtc_state->hw.adjusted_mode, fast_wake_time);
 
 	if (io_wake_lines > max_wake_lines ||
 	    fast_wake_lines > max_wake_lines)
-- 
2.39.2



