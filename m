Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C4021ADC7;
	Tue, 29 Apr 2025 17:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947148; cv=none; b=Plubg79vNJ/yjmgE6xNZ+2xaaTpODRzWQQ94ebVVQ3YqRh1GlkP8zvQBbkaqFlnUpMbGxRJ/Yvtzdhtx9sfkVozNeUspj49jQlulnfcfev657mnBvJGhMc8aj8fdmJF57PZZ/6j4yoNN3YfSPFeUm+b5ceXlQQh3pM6PoUhM6Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947148; c=relaxed/simple;
	bh=9OoWsTUF7DZ/qHC77RC55WHBgMxnCX7G8qoNPGVdKM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQd4IK90EBGw2lH/k+8NVnGpuJ38mH5mGTc9f3Ds1y/zxUIfs3Vl8ETWMQcl7iz8FUghMDbiucORHPXW9kyxGlUk41C/WxYrUJHwNI/oTUE0K58arpZN8VTi3vi8apnSYTRCxF6F1O8xmmcrNrRnZldhR9KPMlublhtzEMK0vYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUUBTnLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUUBTnLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3429C4CEE3;
	Tue, 29 Apr 2025 17:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947148;
	bh=9OoWsTUF7DZ/qHC77RC55WHBgMxnCX7G8qoNPGVdKM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUUBTnLMLZGiz+ODSznoHRdtwIIy4XzuY8wL2jAT8GkMi/09oNMqB0oiXwid5BKYF
	 dVhUZGSFUbgWg5Z+JYEwrENwGG+OEYv8QZQMY2A+qHzFwIEePetXmOYg/yruimKR27
	 r1GT5bruOjxYr/QXE/krzHiQdXNSI67wKSRn2yBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris.p.wilson@intel.com>,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Zhi Yang <Zhi.Yang@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 187/286] drm/i915/gt: Cleanup partial engine discovery failures
Date: Tue, 29 Apr 2025 18:41:31 +0200
Message-ID: <20250429161115.661003656@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris.p.wilson@intel.com>

commit 78a033433a5ae4fee85511ee075bc9a48312c79e upstream.

If we abort driver initialisation in the middle of gt/engine discovery,
some engines will be fully setup and some not. Those incompletely setup
engines only have 'engine->release == NULL' and so will leak any of the
common objects allocated.

v2:
 - Drop the destroy_pinned_context() helper for now.  It's not really
   worth it with just a single callsite at the moment.  (Janusz)

Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220915232654.3283095-2-matthew.d.roper@intel.com
Signed-off-by: Zhi Yang <Zhi.Yang@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -904,8 +904,13 @@ int intel_engines_init(struct intel_gt *
 			return err;
 
 		err = setup(engine);
-		if (err)
+		if (err) {
+			intel_engine_cleanup_common(engine);
 			return err;
+		}
+
+		/* The backend should now be responsible for cleanup */
+		GEM_BUG_ON(engine->release == NULL);
 
 		err = engine_init_common(engine);
 		if (err)


