Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADC3FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403C0C433AA;
	Mon, 15 May 2023 17:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170011;
	bh=HBeguLkvqwmESsAcM+3GWYQltD5pdUwiFwgU7sAlujk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l15I6VD63HVAbc+d42UEymketWARxx1q9tVcT54XxNSVYvcSkqaPUMHzoUuzkcc1j
	 dOCdesbyK9QwMs3GOBpZfsEgIhR6XuN/GGfDuYlppF7l4vbi4OMTMRa+NZ0qCvzF0O
	 wXjcrX7mRUy26lgiqN1xzA1g7xbExshcmVvqfNRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Anusha Srivatsa <anusha.srivatsa@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 217/246] drm/i915: Add _PICK_EVEN_2RANGES()
Date: Mon, 15 May 2023 18:27:09 +0200
Message-Id: <20230515161729.105836992@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 357513233d6456c9f99e34794897efd4ae907e83 ]

It's a constant pattern in the driver to need to use 2 ranges of MMIOs
based on port, phy, pll, etc. When that happens, instead of using
_PICK_EVEN(), _PICK() needs to be used.  Using _PICK() is discouraged
due to some reasons like:

1) It increases the code size since the array is declared
   in each call site
2) Developers need to be careful not to incur an
   out-of-bounds array access
3) Developers need to be careful that the indexes match the
   table. For that it may be that the table needs to contain
   holes, making (1) even worse.

Add a variant of _PICK_EVEN() that works with 2 ranges and selects which
one to use depending on the index value.

v2: Fix the address expansion in the example (Anusha)
v3: Also rename macro to _PICK_EVEN_2RANGES() in the documentation
    and reword it to clarify what ranges are chosen based on the index
    (Jani)

Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Anusha Srivatsa <anusha.srivatsa@intel.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230125182403.7526-1-lucas.demarchi@intel.com
Stable-dep-of: 214b09db6197 ("drm/msm: fix drm device leak on bind errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_reg_defs.h | 29 ++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_reg_defs.h b/drivers/gpu/drm/i915/i915_reg_defs.h
index be43580a69793..983c5aa3045b3 100644
--- a/drivers/gpu/drm/i915/i915_reg_defs.h
+++ b/drivers/gpu/drm/i915/i915_reg_defs.h
@@ -119,6 +119,35 @@
  */
 #define _PICK_EVEN(__index, __a, __b) ((__a) + (__index) * ((__b) - (__a)))
 
+/*
+ * Like _PICK_EVEN(), but supports 2 ranges of evenly spaced address offsets.
+ * @__c_index corresponds to the index in which the second range starts to be
+ * used. Using math interval notation, the first range is used for indexes [ 0,
+ * @__c_index), while the second range is used for [ @__c_index, ... ). Example:
+ *
+ * #define _FOO_A			0xf000
+ * #define _FOO_B			0xf004
+ * #define _FOO_C			0xf008
+ * #define _SUPER_FOO_A			0xa000
+ * #define _SUPER_FOO_B			0xa100
+ * #define FOO(x)			_MMIO(_PICK_EVEN_2RANGES(x, 3,		\
+ *					      _FOO_A, _FOO_B,			\
+ *					      _SUPER_FOO_A, _SUPER_FOO_B))
+ *
+ * This expands to:
+ *	0: 0xf000,
+ *	1: 0xf004,
+ *	2: 0xf008,
+ *	3: 0xa000,
+ *	4: 0xa100,
+ *	5: 0xa200,
+ *	...
+ */
+#define _PICK_EVEN_2RANGES(__index, __c_index, __a, __b, __c, __d)		\
+	(BUILD_BUG_ON_ZERO(!__is_constexpr(__c_index)) +			\
+	 ((__index) < (__c_index) ? _PICK_EVEN(__index, __a, __b) :		\
+				   _PICK_EVEN((__index) - (__c_index), __c, __d)))
+
 /*
  * Given the arbitrary numbers in varargs, pick the 0-based __index'th number.
  *
-- 
2.39.2



