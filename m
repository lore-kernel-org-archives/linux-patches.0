Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CEE393DF1;
	Fri, 17 Oct 2025 15:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715270; cv=none; b=N2Hh6ifnr5iyhbYQTXUJuBN6j47Snpth+8SlATuF1ms9scSN8to3xWsJVGLkJTywCxXkHWKjcjBEVn1XEvXA01berx37Gdz5FkRoD3R0tPpAjen0ViYTlQnkwRx4Ekt0b5fbl1aCV5/+V2hrHMWhBd7B/ZcO02O1ByoV7vrUfFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715270; c=relaxed/simple;
	bh=HeIGjbT528AZfG1W7GHtT/lDAag18KYOSj8BnmeBypI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEEtubY52FkWkockZ8S01U5VqnjI5WBMXgIgkPu17Aka747XoeGm6v6079Qt2YK964y8FcfTEly5tmi2Or6orLHh/B19X2E3P5hdLnNbh7oUYOuaW71FqK5KDx2YGaqN5wHloEoQz4Xp29vrj8BwJXAzvu1cMnaMHi5rgTdwAiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmUtSNmK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmUtSNmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71261C4CEE7;
	Fri, 17 Oct 2025 15:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715269;
	bh=HeIGjbT528AZfG1W7GHtT/lDAag18KYOSj8BnmeBypI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmUtSNmK+KCZ+3vlYIwqI5Qgmj3As5s8Gu/tXqGQJ1hrr2lx+6dTovKWMCQrnuhQb
	 uc2KTA8OyNNtAUXg5hTGC3z2DBJ/Z5hMnhcMAtfckKExHY6dSMB6tzrdwfrAIHiqbH
	 FkIS7w7p6sQ2Me+bv27nOZUHhA9PZfA3pMCQpqV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.17 156/371] KVM: arm64: Fix page leak in user_mem_abort()
Date: Fri, 17 Oct 2025 16:52:11 +0200
Message-ID: <20251017145207.578592629@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <tabba@google.com>

commit 5f9466b50c1b4253d91abf81780b90a722133162 upstream.

The user_mem_abort() function acquires a page reference via
__kvm_faultin_pfn() early in its execution. However, the subsequent
checks for mismatched attributes between stage 1 and stage 2 mappings
would return an error code directly, bypassing the corresponding page
release.

Fix this by storing the error and releasing the unused page before
returning the error.

Fixes: 6d674e28f642 ("KVM: arm/arm64: Properly handle faulting of device mappings")
Fixes: 2a8dfab26677 ("KVM: arm64: Block cacheable PFNMAP mapping")
Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/mmu.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1673,7 +1673,7 @@ static int user_mem_abort(struct kvm_vcp
 			 * cache maintenance.
 			 */
 			if (!kvm_supports_cacheable_pfnmap())
-				return -EFAULT;
+				ret = -EFAULT;
 		} else {
 			/*
 			 * If the page was identified as device early by looking at
@@ -1696,7 +1696,12 @@ static int user_mem_abort(struct kvm_vcp
 	}
 
 	if (exec_fault && s2_force_noncacheable)
-		return -ENOEXEC;
+		ret = -ENOEXEC;
+
+	if (ret) {
+		kvm_release_page_unused(page);
+		return ret;
+	}
 
 	/*
 	 * Potentially reduce shadow S2 permissions to match the guest's own


