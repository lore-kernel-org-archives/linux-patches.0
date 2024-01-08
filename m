Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D7D47791;
	Mon,  8 Jan 2024 15:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hG1fiihS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C363CC43395;
	Mon,  8 Jan 2024 15:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726713;
	bh=InO2eEbOIn9TUhr4z/iAnhEN6U4DV5Ir2M1lfNXXTz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hG1fiihSHJpvEE1DbeXuBqjn/GW3+sks1hVyLaX7aIGutmi1aDjzVrac7zrfcnQu8
	 4l6IAxjrTxXXUv1UPKIM+WF3/JOEcOO5mEcyPYY0oZ6mbXvO1VgEkAMBvbjH0EV76q
	 vDUL/NsRd8Mbovl+i1JDESTCXCzqPl+LM68lz7ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/124] drm/i915/perf: Update handling of MMIO triggered reports
Date: Mon,  8 Jan 2024 16:07:31 +0100
Message-ID: <20240108150604.126760556@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit ee11d2d37f5c05bd7bf5ccc820a58f48423d032b ]

On XEHP platforms user is not able to find MMIO triggered reports in the
OA buffer since i915 squashes the context ID fields. These context ID
fields hold the MMIO trigger markers.

Update logic to not squash the context ID fields of MMIO triggered
reports.

Fixes: cba94bbcff08 ("drm/i915/perf: Determine context valid in OA reports")
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231219000543.1087706-1-umesh.nerlige.ramappa@intel.com
(cherry picked from commit 0c68132df6e66244acec1bb5b9e19b0751414389)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_perf.c | 39 ++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index 109135fcfca28..8f4a25d2cfc24 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -785,10 +785,6 @@ static int gen8_append_oa_reports(struct i915_perf_stream *stream,
 		 * The reason field includes flags identifying what
 		 * triggered this specific report (mostly timer
 		 * triggered or e.g. due to a context switch).
-		 *
-		 * In MMIO triggered reports, some platforms do not set the
-		 * reason bit in this field and it is valid to have a reason
-		 * field of zero.
 		 */
 		reason = oa_report_reason(stream, report);
 		ctx_id = oa_context_id(stream, report32);
@@ -800,8 +796,41 @@ static int gen8_append_oa_reports(struct i915_perf_stream *stream,
 		 *
 		 * Note: that we don't clear the valid_ctx_bit so userspace can
 		 * understand that the ID has been squashed by the kernel.
+		 *
+		 * Update:
+		 *
+		 * On XEHP platforms the behavior of context id valid bit has
+		 * changed compared to prior platforms. To describe this, we
+		 * define a few terms:
+		 *
+		 * context-switch-report: This is a report with the reason type
+		 * being context-switch. It is generated when a context switches
+		 * out.
+		 *
+		 * context-valid-bit: A bit that is set in the report ID field
+		 * to indicate that a valid context has been loaded.
+		 *
+		 * gpu-idle: A condition characterized by a
+		 * context-switch-report with context-valid-bit set to 0.
+		 *
+		 * On prior platforms, context-id-valid bit is set to 0 only
+		 * when GPU goes idle. In all other reports, it is set to 1.
+		 *
+		 * On XEHP platforms, context-valid-bit is set to 1 in a context
+		 * switch report if a new context switched in. For all other
+		 * reports it is set to 0.
+		 *
+		 * This change in behavior causes an issue with MMIO triggered
+		 * reports. MMIO triggered reports have the markers in the
+		 * context ID field and the context-valid-bit is 0. The logic
+		 * below to squash the context ID would render the report
+		 * useless since the user will not be able to find it in the OA
+		 * buffer. Since MMIO triggered reports exist only on XEHP,
+		 * we should avoid squashing these for XEHP platforms.
 		 */
-		if (oa_report_ctx_invalid(stream, report)) {
+
+		if (oa_report_ctx_invalid(stream, report) &&
+		    GRAPHICS_VER_FULL(stream->engine->i915) < IP_VER(12, 50)) {
 			ctx_id = INVALID_CTX_ID;
 			oa_context_id_squash(stream, report32);
 		}
-- 
2.43.0



