Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1505133BBCC;
	Mon, 20 Apr 2026 15:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699896; cv=none; b=r2JJIkwVd/6y90g+XSYLwz6QBigBrMlBpXhfNIT4bsg8LRDsICiJxP2eJTpkXeJxS74HwVISrI/04qScacaTGXekig7Qap0sIw69Cjt2Xia+Z09mBrS5rNhYTMp6SdrvCosmqgoRuoav9OwxliBmilkdG27LQKtsXg5MP+JY534=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699896; c=relaxed/simple;
	bh=d1AJ7EqISkmFq1MFrmBGUTKBMGnuHKSD01qzFlDTVE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgntEF20IsbIctx4np+gmK97hbPHrFk8TzfaWZxdeSF60LF3Uk1kO1mewc1u7wWM17NP6V4BnzVcAL5m03T/nLvcIlFLWbjkg1XopqJGDQp4QXkNonAS0NfHR5PJkiJufuRMpw7KfgeBg6+YGPqZkEVyNiqMguNqEc87BC0dVzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApUQCyko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApUQCyko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E802C19425;
	Mon, 20 Apr 2026 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699896;
	bh=d1AJ7EqISkmFq1MFrmBGUTKBMGnuHKSD01qzFlDTVE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ApUQCykonC0ydv6D2XlYgbPNA+lIP2DM+QaDqDdobV6QB09aGmJO7C9WsCRpSyDny
	 73pfRLssQNs+dgjzy57mdrmWG9CrOp9+kRAGWgEmXbt6HPdpN+iLHdKsvHPN7PZBpc
	 veE8DsUxaYyJnTz/7PTpYyHmQk/7LrDjqd4qMO54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 32/76] scripts/gdb/symbols: handle module path parameters
Date: Mon, 20 Apr 2026 17:41:43 +0200
Message-ID: <20260420153911.991319967@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

commit 8e4513303b8726e4434f718ab39749cbb4c142b1 upstream.

commit 581ee79a2547 ("scripts/gdb/symbols: make BPF debug info available
to GDB") added support to make BPF debug information available to GDB.
However, the argument handling loop was slightly broken, causing it to
fail if further modules were passed.  Fix it to append these passed
modules to the instance variable after expansion.

Link: https://lkml.kernel.org/r/20260304110642.2020614-2-benjamin@sipsolutions.net
Fixes: 581ee79a2547 ("scripts/gdb/symbols: make BPF debug info available to GDB")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gdb/linux/symbols.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/symbols.py
+++ b/scripts/gdb/linux/symbols.py
@@ -298,7 +298,7 @@ are loaded as well."""
             if p == "-bpf":
                 monitor_bpf = True
             else:
-                p.append(os.path.abspath(os.path.expanduser(p)))
+                self.module_paths.append(os.path.abspath(os.path.expanduser(p)))
         self.module_paths.append(os.getcwd())
 
         if self.breakpoint is not None:


