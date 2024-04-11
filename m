Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E342EAE5;
	Thu, 11 Apr 2024 10:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832136; cv=none; b=WfFtgqOB6OSfpp3+HmuJNCp/o0nJwKHDz0W1owJ8j9zVMnSroLRYaJhwwoy/PZU8iah8FMY8W6kT22CLQj8HJDhFhlmMl3X/tcKx3nE0WMKJ/RGXUCq7mgWz3JYtt0xkL8ElwvjBkVHC48F2XXq6C8Qm9utRpePUmzh+C6A/dsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832136; c=relaxed/simple;
	bh=9YI7ZPpSleJ7mzgUZejWQFQKx8m4T2JXF9664DbuLoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJ7SHRiBQaJyBnmRzJmkJ1o8muLZrhIQLc2iSL9/r2PijOeG1KcXVGLvMUTId6RjqWoVFDzuB4qHw+DlmUvBJ12+kcbuanIAtINFhc3MTkDM49RZGeC/gtNcPdE6biGjCcfZQPIHzNdRZ5beneOIfV/j0eqZIxo2uw45Pge9WRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mAqglkjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mAqglkjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB876C433C7;
	Thu, 11 Apr 2024 10:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832136;
	bh=9YI7ZPpSleJ7mzgUZejWQFQKx8m4T2JXF9664DbuLoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAqglkjFyXw3JClwgedb2ZX3+aCzTcDnA898NnFhmSbDjWStOjfNFaGbrl7TywEDc
	 4Wj+6HMsf5qDyb+NzXhNpJMujuk6K/zQREW4XGVR0vI4h7zdHx4j9q7byuvqmJ+4M+
	 /NlsIHpfr1OTtSx4Dm52MhwKaqSpwv1Mz5W6Ag9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>
Subject: [PATCH 5.10 242/294] objtool: Add asm version of STACK_FRAME_NON_STANDARD
Date: Thu, 11 Apr 2024 11:56:45 +0200
Message-ID: <20240411095442.858518783@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 081df94301e317e84c3413686043987da2c3e39d upstream.

To be used for adding asm functions to the ignore list.  The "aw" is
needed to help the ELF section metadata match GCC-created sections.
Otherwise the linker creates duplicate sections instead of combining
them.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/8faa476f9a5ac89af27944ec184c89f95f3c6c49.1611263462.git.jpoimboe@redhat.com
Signed-off-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/objtool.h       |    8 ++++++++
 tools/include/linux/objtool.h |    8 ++++++++
 2 files changed, 16 insertions(+)

--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -141,6 +141,12 @@ struct unwind_hint {
 	.popsection
 .endm
 
+.macro STACK_FRAME_NON_STANDARD func:req
+	.pushsection .discard.func_stack_frame_non_standard, "aw"
+		.long \func - .
+	.popsection
+.endm
+
 #endif /* __ASSEMBLY__ */
 
 #else /* !CONFIG_STACK_VALIDATION */
@@ -158,6 +164,8 @@ struct unwind_hint {
 .endm
 .macro ANNOTATE_NOENDBR
 .endm
+.macro STACK_FRAME_NON_STANDARD func:req
+.endm
 #endif
 
 #endif /* CONFIG_STACK_VALIDATION */
--- a/tools/include/linux/objtool.h
+++ b/tools/include/linux/objtool.h
@@ -141,6 +141,12 @@ struct unwind_hint {
 	.popsection
 .endm
 
+.macro STACK_FRAME_NON_STANDARD func:req
+	.pushsection .discard.func_stack_frame_non_standard, "aw"
+		.long \func - .
+	.popsection
+.endm
+
 #endif /* __ASSEMBLY__ */
 
 #else /* !CONFIG_STACK_VALIDATION */
@@ -158,6 +164,8 @@ struct unwind_hint {
 .endm
 .macro ANNOTATE_NOENDBR
 .endm
+.macro STACK_FRAME_NON_STANDARD func:req
+.endm
 #endif
 
 #endif /* CONFIG_STACK_VALIDATION */


