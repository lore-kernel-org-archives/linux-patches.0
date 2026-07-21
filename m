Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865EC46D08F;
	Tue, 21 Jul 2026 18:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659756; cv=none; b=VeEYz/SwHjpNhA07lEO8TzRHc3Wx7chQM3v1AbYI0s6FhqpyzCuhLbv0MBtYUUklPlUw/hxlR5VFccfRLxe/wfxGH32yOldNpbkVAboZqJns82P7nlMdP6Odpl/e9xSk4djEaCnbqPS+ktY7/+V7ojIW6kXmG64ZskrHOz6nHAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659756; c=relaxed/simple;
	bh=CE8dKCzj6R9C63gN1L/QzDzEmbnkGKIt+Kuuloytfx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtnXK2B5uIu1SGjFK5ZK8DjM5B2pBktslzbSYOLeuwQY2tDOIOH7SdbDoplXKVPwfWMcnG0piwenn9j0mNR075nFEsjnLeWbEcXADaw5wpUkeCQZ7YuxygfswplQlbmQDd1ex00uxjdYmKXAx+yLjsZDLmHnwqnwEhfz5+/5dYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGyKRn10; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGyKRn10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5F61F000E9;
	Tue, 21 Jul 2026 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659754;
	bh=LysgT4RV1WnOm9jkg5YFTOHECaKQqoyW19GuJUjRK60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tGyKRn10K+jseSnXs9eug4nkLi2CdLPQFdnd6xw2BhgH+nE1B9PSLKCVXv2WqGNu2
	 6elpSupOzWeqKd/2GPsrHc78mpek2VjOgfcI8nmajUp3IBSgBgnzu5klA/PQmN8lCb
	 Tf2HhRT67rCNqz5wcWD7UVOK+0vXi0wZtOT+TCIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0720/2077] cxl/test: Unregister cxl_acpi in cxl_test_init() error path
Date: Tue, 21 Jul 2026 17:06:33 +0200
Message-ID: <20260721152609.785628411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 50cc34be04a0ea7522b739c9c7a71367cfbc489c ]

In cxl_test_init(), Once cxl_mock_platform_device_add() succeeds, all
error paths after needs to call platform_device_unregister() instead of
platform_device_put() to clean up.

Fixes: 67dcdd4d3b83 ("tools/testing/cxl: Introduce a mocked-up CXL port hierarchy")
Reported-by: sashiko-bot
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260611230355.198912-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 296516eecfd6af..fd6ff00541dced 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -1951,7 +1951,7 @@ static __init int cxl_test_init(void)
 err_mem:
 	cxl_mem_exit();
 err_root:
-	platform_device_put(cxl_acpi);
+	platform_device_unregister(cxl_acpi);
 err_rch:
 	cxl_rch_topo_exit();
 err_single:
-- 
2.53.0



