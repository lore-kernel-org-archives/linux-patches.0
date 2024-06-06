Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D58197526;
	Thu,  6 Jun 2024 14:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683642; cv=none; b=Sd9GMtPvOdCkFAYt861QajQoOrNtTnkoUJQMLAIzaEB1CXLIrSU21GPdU7YfqNzS+vjd7A0OtKZmSOW6dAX0w8v4VKNnE5aTk8RjtTZeDKAnXC95p8z2UGh4HC92t++EKZkv2MV3OcHGXJiyONBFGv+F35AR4GSKvoK9BJmq800=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683642; c=relaxed/simple;
	bh=zTEgKzrVSCzIdSxhY7p8SJPERa7Ve1C2RQNknrgWcXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWcOTbZCiuRba4aPbdpGX326UudPlVniFsSZGONgSI67NX62C/xFqxatMxezef4zNYejLk0QZagGsRDehNWOlTydEBLB0ndxuO+pwS2do0I/InbcEvy2QjH7ckInsbsmEE+a2rYJoLcdcJaWlYaO5/CJVjHYnQK8p6UxtNrbTbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KaZqOljX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaZqOljX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168ADC2BD10;
	Thu,  6 Jun 2024 14:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683642;
	bh=zTEgKzrVSCzIdSxhY7p8SJPERa7Ve1C2RQNknrgWcXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KaZqOljXwgcvyc7ycwUn5jxxwdkZGKvdUHYUUSZ/Mo8sYv85sqr5a3KnXfI2TNnVd
	 YCnD6RBSfm7gHQSG6NTWTTKph10EUi4vVhSwm33Lki+4tWpHdtRE17TG+Uz/gkDziB
	 Uju4osU+KNh5IUdT65Tl7OfrEt5C+bjhqMvTpeM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 462/473] drm/i915/guc: avoid FIELD_PREP warning
Date: Thu,  6 Jun 2024 16:06:31 +0200
Message-ID: <20240606131714.954576361@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d4f36db62396b73bed383c0b6e48d36278cafa78 ]

With gcc-7 and earlier, there are lots of warnings like

In file included from <command-line>:0:0:
In function '__guc_context_policy_add_priority.isra.66',
    inlined from '__guc_context_set_prio.isra.67' at drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c:3292:3,
    inlined from 'guc_context_set_prio' at drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c:3320:2:
include/linux/compiler_types.h:399:38: error: call to '__compiletime_assert_631' declared with attribute error: FIELD_PREP: mask is not constant
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                      ^
...
drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c:2422:3: note: in expansion of macro 'FIELD_PREP'
   FIELD_PREP(GUC_KLV_0_KEY, GUC_CONTEXT_POLICIES_KLV_ID_##id) | \
   ^~~~~~~~~~

Make sure that GUC_KLV_0_KEY is an unsigned value to avoid the warning.

Fixes: 77b6f79df66e ("drm/i915/guc: Update to GuC version 69.0.3")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Signed-off-by: Julia Filipchuk <julia.filipchuk@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240430164809.482131-1-julia.filipchuk@intel.com
(cherry picked from commit 364e039827ef628c650c21c1afe1c54d9c3296d9)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/abi/guc_klvs_abi.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/abi/guc_klvs_abi.h b/drivers/gpu/drm/i915/gt/uc/abi/guc_klvs_abi.h
index 4a59478c3b5c4..bbeceb640d31e 100644
--- a/drivers/gpu/drm/i915/gt/uc/abi/guc_klvs_abi.h
+++ b/drivers/gpu/drm/i915/gt/uc/abi/guc_klvs_abi.h
@@ -29,9 +29,9 @@
  */
 
 #define GUC_KLV_LEN_MIN				1u
-#define GUC_KLV_0_KEY				(0xffff << 16)
-#define GUC_KLV_0_LEN				(0xffff << 0)
-#define GUC_KLV_n_VALUE				(0xffffffff << 0)
+#define GUC_KLV_0_KEY				(0xffffu << 16)
+#define GUC_KLV_0_LEN				(0xffffu << 0)
+#define GUC_KLV_n_VALUE				(0xffffffffu << 0)
 
 /**
  * DOC: GuC Self Config KLVs
-- 
2.43.0



