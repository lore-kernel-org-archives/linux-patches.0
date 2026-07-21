Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63801436BC6;
	Tue, 21 Jul 2026 19:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661616; cv=none; b=upXf8diqMWUJMekhRVWQNMoElHwr7wEZhRDrmQucdiBVmXWvHp4uYDKdIsMcCUW48q7na3SnkwdKQ99doICOniLBrHhg8fqSLlOJ33QmQuqEPmQh0T6HA3xMK/d0o8+xWXfDSzId939gUOcMoU9qPNFc6zkrGyNHMzTWPysZP7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661616; c=relaxed/simple;
	bh=zV64PClgYSW7HsU+eVUOj1SBcCPwe6k8YjE31d8GE5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPmeQkztTOxAWZHS4i1Z6xQ55UnTSn5mpS3AluddxwhXZPKbS+T1yw+54JQGhg/ORjeXVvnXNNizfduDSCAw7kVJBbYaQtzeFpXPeTK0gSK47d6cYGdrMkSCyOVaK6zrFJo1KOfv2HQXYChf9Ee27yknj4jioFG8v5iMJtbv7oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8ivoViX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8ivoViX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F191F000E9;
	Tue, 21 Jul 2026 19:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661614;
	bh=pEeX7guA30W/yhOfiZTBT8R2yVl2xXd5H++0h7RBImc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8ivoViXA4gWiiao8ULDWojs3UVPt/7OAPGzFeZDGrZ+giR1SfgDxUm0GPbT2xaWq
	 BSdv+ABGgK1uTlGPSYYY0YgOsEhQRzcytiHAMbc/m9nI+GOniku4HrH2ySQuwKtQYA
	 acw7DlYf71HDFqFhpgLJATZ4yDMhSJ2JgZRFiNXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0131/1276] staging: media: atomisp: fix loop shadowing in ia_css_stream_destroy()
Date: Tue, 21 Jul 2026 17:09:34 +0200
Message-ID: <20260721152449.034881051@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose A. Perez de Azpillaga <azpijr@gmail.com>

[ Upstream commit 9087395a383212ab1beaefcbe3b57ed131c7823d ]

The nested loop inside the IS_ISP2401 block incorrectly uses the same
variable 'i' as the outer loop. This shadows the outer loop variable
and causes premature termination or skipped array elements.

Change the inner loop to use a new variable 'j' to prevent this.

Fixes: 113401c67386 ("media: atomisp: sh_css: Removed #ifdef ISP2401 to make code generic")
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/sh_css.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/sh_css.c b/drivers/staging/media/atomisp/pci/sh_css.c
index 499afd73939221..e6ffef36a7ae4a 100644
--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -8237,7 +8237,7 @@ ia_css_stream_create(const struct ia_css_stream_config *stream_config,
 int
 ia_css_stream_destroy(struct ia_css_stream *stream)
 {
-	int i;
+	int i, j;
 	int err = 0;
 
 	IA_CSS_ENTER_PRIVATE("stream = %p", stream);
@@ -8268,10 +8268,10 @@ ia_css_stream_destroy(struct ia_css_stream *stream)
 					sp_pipeline_input_terminal =
 						&sh_css_sp_group.pipe_io[sp_thread_id].input;
 
-					for (i = 0; i < IA_CSS_STREAM_MAX_ISYS_STREAM_PER_CH; i++) {
+					for (j = 0; j < IA_CSS_STREAM_MAX_ISYS_STREAM_PER_CH; j++) {
 						ia_css_isys_stream_h isys_stream =
-							&sp_pipeline_input_terminal->context.virtual_input_system_stream[i];
-						if (stream->config.isys_config[i].valid && isys_stream->valid)
+							&sp_pipeline_input_terminal->context.virtual_input_system_stream[j];
+						if (stream->config.isys_config[j].valid && isys_stream->valid)
 							ia_css_isys_stream_destroy(isys_stream);
 					}
 				}
-- 
2.53.0



