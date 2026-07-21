Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B41446839;
	Tue, 21 Jul 2026 17:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655871; cv=none; b=HWMznfu6GbKOqjLYY0jHmctyFgVBtqizJfELoXfNl0Nz44U/mbXhhB6Tu6I5QUuJaKLcVM7+iX8n9dBslkIW3jyaNqJfw1bDB293fG+TFcKnQqrLPRHQ8lt+wavVTGnM71+AXxYuYId1fGKOqRJ47HRzptp0dzD6qKe5W/Th/rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655871; c=relaxed/simple;
	bh=fQl4Hpv2WDbc3C7/a1+rU5s2nlUVly1nd5fAUFqfjTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHODM+LZaOof0G0yIDENUK22yWil/h8iviRKSTm0V7V2rxSzrxDc7YwOqFaFFylPmfr9e8GxZdcH6JzO914bb3qO6ej/itym99UzCwXGb2L+fpSKfAGuQrMeJFb3xMKCHOaNYjIEBvhiGwtBJXU4VjJWjJUhtlMej3wzYy/jRns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ko/wPImZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ko/wPImZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56ED81F000E9;
	Tue, 21 Jul 2026 17:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655868;
	bh=ks61LAr3//8e3buvM1CX34rrEp+h23OgGjPJgSLtR3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ko/wPImZGa3/qz99f0M2JKxHxi16Z589OASTqGcNCiUaYK1C7k6qPLAQf8DQroekT
	 pQvEPjryc7TXJpCGIgyac4lN7AjNyzuuiaBvWBbqeaEFp8vmPthEatoUvnuOR9LbSb
	 SUVfFNLAsoPjAboWbkI8+Y0EeFSx/LXPeU+Db50s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0171/1611] staging: media: atomisp: fix loop shadowing in ia_css_stream_destroy()
Date: Tue, 21 Jul 2026 17:04:47 +0200
Message-ID: <20260721152518.743617187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cd5719dc164674..cc9ca691b1ad7b 100644
--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -8198,7 +8198,7 @@ ia_css_stream_create(const struct ia_css_stream_config *stream_config,
 int
 ia_css_stream_destroy(struct ia_css_stream *stream)
 {
-	int i;
+	int i, j;
 	int err = 0;
 
 	IA_CSS_ENTER_PRIVATE("stream = %p", stream);
@@ -8229,10 +8229,10 @@ ia_css_stream_destroy(struct ia_css_stream *stream)
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



