Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376D47461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96ADEC433C8;
	Sun, 17 Sep 2023 20:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981250;
	bh=Bjts4zYnTepW+eoLhxYTZokRLTZcJNOeJJf0ZOpv874=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gp3gXBdyaOpjFdj2y7RLZ05tgRE4KqZ359in9UG7jdcywraBh+KHlTpKHwg5jutvI
	 tfZ12Nws1Yyzyd5Qh7rZ4dxWDeHoiB3JzqYSE7XgO0KG8k/B2EX4DAfHJCXTO7PewI
	 p+bxWQTaaL/yXb/Rwi5/xfjyQ2S6oxXffUy/25mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yan Zhao <yan.y.zhao@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhi Wang <zhi.a.wang@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/219] drm/i915/gvt: Put the page reference obtained by KVMs gfn_to_pfn()
Date: Sun, 17 Sep 2023 21:13:42 +0200
Message-ID: <20230917191044.410496538@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 708e49583d7da863898b25dafe4bcd799c414278 ]

Put the struct page reference acquired by gfn_to_pfn(), KVM's API is that
the caller is ultimately responsible for dropping any reference.

Note, kvm_release_pfn_clean() ensures the pfn is actually a refcounted
struct page before trying to put any references.

Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
Link: https://lore.kernel.org/r/20230729013535.1070024-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/gtt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index 92462cd4bf7cc..980d671ac3595 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1179,6 +1179,7 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
 {
 	const struct intel_gvt_gtt_pte_ops *ops = vgpu->gvt->gtt.pte_ops;
 	kvm_pfn_t pfn;
+	int ret;
 
 	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
 		return 0;
@@ -1192,7 +1193,9 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
 	if (!pfn_valid(pfn))
 		return -EINVAL;
 
-	return PageTransHuge(pfn_to_page(pfn));
+	ret = PageTransHuge(pfn_to_page(pfn));
+	kvm_release_pfn_clean(pfn);
+	return ret;
 }
 
 static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
-- 
2.40.1



