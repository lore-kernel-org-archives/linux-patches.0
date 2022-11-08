Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8518F15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A7BC433D6;
	Tue,  8 Nov 2022 14:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916892;
	bh=Kcm2xD3SzDwXU0YQvjuokruLH9nM2QlUZJTTHjPBrcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usi3yMS3oSUAmX+uA04O2Jr5tL9HvnLUT9j26qmTnUsfVJ3ALBpcoYVBjl+4mwU4t
	 8KGC/wL1iApOISnwNLJnvZyGIHhaUo8FHcq+LQH6LXzGgHYWP6nAJC8JHfghMHbF2+
	 OJAGiHEnAqZPUpLQ7aJJMQagEScFH0pHEdZQT8Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 6.0 167/197] x86/tdx: Prepare for using "INFO" call for a second purpose
Date: Tue,  8 Nov 2022 14:40:05 +0100
Message-Id: <20221108133402.525335354@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Hansen <dave.hansen@linux.intel.com>

commit a6dd6f39008bb3ef7c73ef0a2acc2a4209555bd8 upstream.

The TDG.VP.INFO TDCALL provides the guest with various details about
the TDX system that the guest needs to run.  Only one field is currently
used: 'gpa_width' which tells the guest which PTE bits mark pages shared
or private.

A second field is now needed: the guest "TD attributes" to tell if
virtualization exceptions are configured in a way that can harm the guest.

Make the naming and calling convention more generic and discrete from the
mask-centric one.

Thanks to Sathya for the inspiration here, but there's no code, comments
or changelogs left from where he started.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/tdx/tdx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -98,7 +98,7 @@ static inline void tdx_module_call(u64 f
 		panic("TDCALL %lld failed (Buggy TDX module!)\n", fn);
 }
 
-static u64 get_cc_mask(void)
+static void tdx_parse_tdinfo(u64 *cc_mask)
 {
 	struct tdx_module_output out;
 	unsigned int gpa_width;
@@ -121,7 +121,7 @@ static u64 get_cc_mask(void)
 	 * The highest bit of a guest physical address is the "sharing" bit.
 	 * Set it for shared pages and clear it for private pages.
 	 */
-	return BIT_ULL(gpa_width - 1);
+	*cc_mask = BIT_ULL(gpa_width - 1);
 }
 
 /*
@@ -758,7 +758,7 @@ void __init tdx_early_init(void)
 	setup_force_cpu_cap(X86_FEATURE_TDX_GUEST);
 
 	cc_set_vendor(CC_VENDOR_INTEL);
-	cc_mask = get_cc_mask();
+	tdx_parse_tdinfo(&cc_mask);
 	cc_set_mask(cc_mask);
 
 	/*


