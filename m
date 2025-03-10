Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1A52253FE;
	Mon, 10 Mar 2025 17:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628271; cv=none; b=HEVVHC75pK1eeMsVqdPb8lwe4vkOFuaHFEbkt4QkBYxYbAUAgXegCKOAKf3wkrBUpcdacHt5EFLzuV8z7lA5h80eVlj4X3TB8cfBwgc0smdqIFje4z5OS/OsqNOpNg+dFYARvCm5S30KrRy9/kQDvbC5hSpN6Zwuz63RMwQRryQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628271; c=relaxed/simple;
	bh=gwB+enhjYsW+JQ4VR9BaDxpz6HAtKYOqBY33lYkJJJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5+tYFdfp/gl3pMlEnxGdwbHm8kW4y9TbUWyWFQFTSy7rjNHkzStOjkuQV+Cz/SELax4fxTaMDIVvCAs2YkS6s+ykXXccP6j34iZd6aiT0OMd7emk2QnuWmflJ4SwmXt2RM689b+5Aufbv9f8fv9v4k6+6FG6UQh72dH2UPT1c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEnEvSTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEnEvSTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A887DC4CEE5;
	Mon, 10 Mar 2025 17:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628271;
	bh=gwB+enhjYsW+JQ4VR9BaDxpz6HAtKYOqBY33lYkJJJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEnEvSTKJDRGc56DFqLpWbp4bUvCCPCzSnpsqAEjsY08qQ7FPIhEGeJwsegZY3Smb
	 3Onx+Xsp/FhrEmQrCSfja/aECYzOb9MBtVMvCn7Qxb4GTGQ8mJ5oQhJdlSh3FDwsA/
	 fO+F9bN0gAUuez5B1WuDvsyp87e99k/nJVn9HhSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 135/145] Revert "KVM: PPC: e500: Mark "struct page" pfn accessed before dropping mmu_lock"
Date: Mon, 10 Mar 2025 18:07:09 +0100
Message-ID: <20250310170440.207881241@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 59e21c4613b0a46f46eb124984928df46d88ad57 which is
commit 84cf78dcd9d65c45ab73998d4ad50f433d53fb93 upstream.

It should not have been applied.

Link: https://lore.kernel.org/r/CABgObfb5U9zwTQBPkPB=mKu-vMrRspPCm4wfxoQpB+SyAnb5WQ@mail.gmail.com
Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/e500_mmu_host.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -498,9 +498,11 @@ static inline int kvmppc_e500_shadow_map
 	kvmppc_mmu_flush_icache(pfn);
 
 out:
+	spin_unlock(&kvm->mmu_lock);
+
 	/* Drop refcount on page, so that mmu notifiers can clear it */
 	kvm_release_pfn_clean(pfn);
-	spin_unlock(&kvm->mmu_lock);
+
 	return ret;
 }
 


