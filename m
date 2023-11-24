Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222F934197;
	Fri, 24 Nov 2023 18:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yb5wBPGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529CFC433C8;
	Fri, 24 Nov 2023 18:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850316;
	bh=4IaispNVxf/Hsg6nyONNId4QgOzLdCSSQV+axLqUa2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yb5wBPGrbAkztMthsh2tJ07nEnDnInwgXwU5zL54qg1U5Qzqgf+OTT2Scd/X8me7b
	 A8iNQOmsO4cq/Qad5mL+M7fUDkWUgymnlnpPWw3s3tQ7XDMX6qWkioFfBccI/0fTNq
	 8tr55Ae16Kiv0zR0ObrGLuTJw46vJDorOZN6kEqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 513/530] drm/i915: Fix potential spectre vulnerability
Date: Fri, 24 Nov 2023 17:51:19 +0000
Message-ID: <20231124172043.784485040@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Kunwu Chan <chentao@kylinos.cn>

commit 1a8e9bad6ef563c28ab0f8619628d5511be55431 upstream.

Fix smatch warning:
drivers/gpu/drm/i915/gem/i915_gem_context.c:847 set_proto_ctx_sseu()
warn: potential spectre issue 'pc->user_engines' [r] (local cap)

Fixes: d4433c7600f7 ("drm/i915/gem: Use the proto-context to handle create parameters (v5)")
Cc: <stable@vger.kernel.org> # v5.15+
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231103110922.430122-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit 27b086382c22efb7e0a16442f7bdc2e120108ef3)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_context.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -844,6 +844,7 @@ static int set_proto_ctx_sseu(struct drm
 		if (idx >= pc->num_user_engines)
 			return -EINVAL;
 
+		idx = array_index_nospec(idx, pc->num_user_engines);
 		pe = &pc->user_engines[idx];
 
 		/* Only render engine supports RPCS configuration. */


