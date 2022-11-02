Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734C8633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB7EC433C1;
	Wed,  2 Nov 2022 03:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360391;
	bh=Y9TiJ7ocCbb8FEOd8kNs4F3f9x8QaeHr4IcETx5EhKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWG23tPwWYaoVGQ+G0bp2bLBxHgK3hB2InrNKg9my8DcmnvMwK/wiNvW38Ua6fzQA
	 HUG5DuZ92xTHdBH95ku6UlVpUyhqmu+MUREy005uqm5Tzn+zJIumVzUDg+9ilw7GWm
	 5U2j7TK4XBVvFf4WavD3jw1ZNiTyuRnI91alB0OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C8=98tefan=20Talpalaru?= <stefantalpalaru@yahoo.com>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.14 03/60] x86/microcode/AMD: Apply the patch early on every logical thread
Date: Wed,  2 Nov 2022 03:34:24 +0100
Message-Id: <20221102022051.183484599@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Borislav Petkov <bp@suse.de>

commit e7ad18d1169c62e6c78c01ff693fd362d9d65278 upstream.

Currently, the patch application logic checks whether the revision
needs to be applied on each logical CPU (SMT thread). Therefore, on SMT
designs where the microcode engine is shared between the two threads,
the application happens only on one of them as that is enough to update
the shared microcode engine.

However, there are microcode patches which do per-thread modification,
see Link tag below.

Therefore, drop the revision check and try applying on each thread. This
is what the BIOS does too so this method is very much tested.

Btw, change only the early paths. On the late loading paths, there's no
point in doing per-thread modification because if is it some case like
in the bugzilla below - removing a CPUID flag - the kernel cannot go and
un-use features it has detected are there early. For that, one should
use early loading anyway.

  [ bp: Fixes does not contain the oldest commit which did check for
    equality but that is good enough. ]

Fixes: 8801b3fcb574 ("x86/microcode/AMD: Rework container parsing")
Reported-by:  Ștefan Talpalaru <stefantalpalaru@yahoo.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by:  Ștefan Talpalaru <stefantalpalaru@yahoo.com>
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216211
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -222,7 +222,13 @@ apply_microcode_early_amd(u32 cpuid_1_ea
 		return ret;
 
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
-	if (rev >= mc->hdr.patch_id)
+
+	/*
+	 * Allow application of the same revision to pick up SMT-specific
+	 * changes even if the revision of the other SMT thread is already
+	 * up-to-date.
+	 */
+	if (rev > mc->hdr.patch_id)
 		return ret;
 
 	if (!__apply_microcode_amd(mc)) {
@@ -304,8 +310,12 @@ void load_ucode_amd_ap(unsigned int cpui
 
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
-	/* Check whether we have saved a new patch already: */
-	if (*new_rev && rev < mc->hdr.patch_id) {
+	/*
+	 * Check whether a new patch has been saved already. Also, allow application of
+	 * the same revision in order to pick up SMT-thread-specific configuration even
+	 * if the sibling SMT thread already has an up-to-date revision.
+	 */
+	if (*new_rev && rev <= mc->hdr.patch_id) {
 		if (!__apply_microcode_amd(mc)) {
 			*new_rev = mc->hdr.patch_id;
 			return;


