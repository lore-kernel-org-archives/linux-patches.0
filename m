Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BBC1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8D1C433C8;
	Tue, 25 Jul 2023 11:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284949;
	bh=puvGtCHrfFjPOy2iCaOxBGZxvH48hW5OyqAOqpcDZmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddXxWJE0uOo50la/ilGcNINIa4j1Rsd6vlVMkXJeB+sJ0rcQfB2GtFHqxsBr55tOt
	 YrbHdUXHg7jx4snMre0ggce1RMM00hop35BgahxHEmNnY4Bk58ou2pUPEHgdLC3Zp3
	 mM20g6rRzxqEMJOwerb5Q31cKBhSCXTg4tb0UKXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris@chris-wilson.co.uk>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>
Subject: [PATCH 5.4 006/313] drm/i915: Initialise outparam for error return from wait_for_register
Date: Tue, 25 Jul 2023 12:42:39 +0200
Message-ID: <20230725104521.465745459@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Wilson <chris@chris-wilson.co.uk>

commit b79ffa914ede785a721f42d8ee3ce7b8eeede2bb upstream.

Just in case the caller passes in 0 for both slow&fast timeouts, make
sure we initialise the stack value returned. Add an assert so that we
don't make the mistake of passing 0 timeouts for the wait.

drivers/gpu/drm/i915/intel_uncore.c:2011 __intel_wait_for_register_fw() error: uninitialized symbol 'reg_value'.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200916105022.28316-1-chris@chris-wilson.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_uncore.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_uncore.c
+++ b/drivers/gpu/drm/i915/intel_uncore.c
@@ -1926,13 +1926,14 @@ int __intel_wait_for_register_fw(struct
 				 unsigned int slow_timeout_ms,
 				 u32 *out_value)
 {
-	u32 reg_value;
+	u32 reg_value = 0;
 #define done (((reg_value = intel_uncore_read_fw(uncore, reg)) & mask) == value)
 	int ret;
 
 	/* Catch any overuse of this function */
 	might_sleep_if(slow_timeout_ms);
 	GEM_BUG_ON(fast_timeout_us > 20000);
+	GEM_BUG_ON(!fast_timeout_us && !slow_timeout_ms);
 
 	ret = -ETIMEDOUT;
 	if (fast_timeout_us && fast_timeout_us <= 20000)


