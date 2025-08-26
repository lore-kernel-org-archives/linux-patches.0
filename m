Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D9D22DF99;
	Tue, 26 Aug 2025 13:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214334; cv=none; b=VFcVClAfGpYdpZKXBkGcRQpNlI1gRFH+51aS22vNhTyfL5eBBjFMmdjZxqr1TDZA5CHdQeE87ljcz+7EU7IQJxt1yDs7k6mu3WEO2DUPHMExT5YFKC6pzvF/hno3vakJ/Mkh/Ls3sWOp07/CNOD49rXWhAl1Zami7KoVc3r7pX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214334; c=relaxed/simple;
	bh=6NQHH2yU+c3di1Nsz7mTR1pv+94G/g6NtGAkulLpGv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwN0pLxtV7A1K86vOc+rPb/k5MrvT0hD6/pvYMrrbgnol6Qb8hGRkZhxf3F4fmZww/rkfdf7C3ygyf04QrWtOvch/NuuIZUs6YbHl2giIT5l2Xacz0GXfUjom9Kaznxp+br7mufKgPnIVjVphXVMu9YxNkv63a6r+R7aN8KTpIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eaj6EGke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eaj6EGke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA54EC4CEF1;
	Tue, 26 Aug 2025 13:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214334;
	bh=6NQHH2yU+c3di1Nsz7mTR1pv+94G/g6NtGAkulLpGv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eaj6EGkeFR+ucbuVCxOiEScJLzfYhTCAq0x9WhPyT6BXF/Pz51+Zcl0+7NM3fqVj5
	 y9A/ug3CkD+L6RCBeHHNag3EMKXyZqKgmc7BNnHRe/FeowjjXsuaEdox66zos2DqqT
	 7nrXFtq26Zg7TfDYjKcBKVDRqeyTPgtgRtVE7o+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/482] x86/bugs: Avoid warning when overriding return thunk
Date: Tue, 26 Aug 2025 13:05:52 +0200
Message-ID: <20250826110933.273139685@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

[ Upstream commit 9f85fdb9fc5a1bd308a10a0a7d7e34f2712ba58b ]

The purpose of the warning is to prevent an unexpected change to the return
thunk mitigation. However, there are legitimate cases where the return
thunk is intentionally set more than once. For example, ITS and SRSO both
can set the return thunk after retbleed has set it. In both the cases
retbleed is still mitigated.

Replace the warning with an info about the active return thunk.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250611-eibrs-fix-v4-3-5ff86cac6c61@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index dba5262e1509..4fbb5b15ab75 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -70,10 +70,9 @@ void (*x86_return_thunk)(void) __ro_after_init = &__x86_return_thunk;
 
 static void __init set_return_thunk(void *thunk)
 {
-	if (x86_return_thunk != __x86_return_thunk)
-		pr_warn("x86/bugs: return thunk changed\n");
-
 	x86_return_thunk = thunk;
+
+	pr_info("active return thunk: %ps\n", thunk);
 }
 
 /* Update SPEC_CTRL MSR and its cached copy unconditionally */
-- 
2.39.5



