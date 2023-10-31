Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2965208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T82RpS9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413D7C433C8;
	Tue, 31 Oct 2023 17:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774515;
	bh=u1gmawsYRdXjuVHzYZGNPVIF9TqUsTqzu3iO0QmnRQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T82RpS9HQyeWicYEX4zTxFaHUEQf9ZJTESzIcW8y/WE8eP9YGEft9+XH2gkBqYdPO
	 y8HbXdjqK1ojUU4xDeFMpYqTPzBgBVz/R3aCLIRTFLuGN4mUVO5M382tgqH0TzOGyr
	 18KnyEy3j3lMX5TR03cHkC0Y1Hw6q+unucBL7NJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 073/112] drm/i915/perf: Determine context valid in OA reports
Date: Tue, 31 Oct 2023 18:01:14 +0100
Message-ID: <20231031165903.622067161@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit cba94bbcff08d209710dd7bdc139caad675a6f8d ]

When supporting OA for TGL, it was seen that the context valid bit in
the report ID was not defined, however revisiting the spec seems to have
this bit defined. The bit is used to determine if a context is valid on
a context switch and is essential to determine active and idle periods
for a context. Re-enable the context valid bit for gen12 platforms.

BSpec: 52196 (description of report_id)

v2: Include BSpec reference (Ashutosh)

Fixes: 00a7f0d7155c ("drm/i915/tgl: Add perf support on TGL")
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230802202854.1224547-1-umesh.nerlige.ramappa@intel.com
(cherry picked from commit 7eeaedf79989a8f131939782832e21e9218ed2a0)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_perf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index 49c6f1ff11284..331685e1b7b7d 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -482,8 +482,7 @@ static void oa_report_id_clear(struct i915_perf_stream *stream, u32 *report)
 static bool oa_report_ctx_invalid(struct i915_perf_stream *stream, void *report)
 {
 	return !(oa_report_id(stream, report) &
-	       stream->perf->gen8_valid_ctx_bit) &&
-	       GRAPHICS_VER(stream->perf->i915) <= 11;
+	       stream->perf->gen8_valid_ctx_bit);
 }
 
 static u64 oa_timestamp(struct i915_perf_stream *stream, void *report)
@@ -5106,6 +5105,7 @@ static void i915_perf_init_info(struct drm_i915_private *i915)
 		perf->gen8_valid_ctx_bit = BIT(16);
 		break;
 	case 12:
+		perf->gen8_valid_ctx_bit = BIT(16);
 		/*
 		 * Calculate offset at runtime in oa_pin_context for gen12 and
 		 * cache the value in perf->ctx_oactxctrl_offset.
-- 
2.42.0



