Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023F37EF1F;
	Mon,  8 Apr 2024 14:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585017; cv=none; b=MduUpTNASn2kpGTpfkRnkmMXdXE2p2H9pQj5BST/38s1wK8JduChcpNpxuli6G2GEzp46jA5k89EETEmIBDNPZztQVNJQ46lutiavTfdDb4K98yV6l8oT8lFURK/7V/v89knubinXrbKxhk1Mi/tVLNYrRP4vf2k9MTdQWR5ZS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585017; c=relaxed/simple;
	bh=35PocaNTHZfIJT8Dx0tYcyIXPgCYI1VY4WvyeJrlOtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXEwdWKjol3FJj7bxici/oYgz1KcTIcbzcliLPJqUKGbXMFqBGa7XmwSsOGcOqP4OurvjORzjYOQO+R91UYDn8XdrJvCYxfnWSqlwG+b6uPVRGxXdwGYBccH5OJ6HlP/ncWYawojLkmlSaKrgpT7jI+I0wuw1AyiL9JErpXJu+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qr7g8Or1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qr7g8Or1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B48AC43390;
	Mon,  8 Apr 2024 14:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585016;
	bh=35PocaNTHZfIJT8Dx0tYcyIXPgCYI1VY4WvyeJrlOtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qr7g8Or1UI/RIgPa3WLIJ83wLhN/jcd2CkamINTJiKh9TUp4qx+457ErY8tx1lShG
	 OzWIA13myOWDxzY1OuooYddFAIIX8ly1/TyXw8naIKYLFPPgxShmbXWBbdBghOVGVv
	 ndQonLgdhWwB0rWsqaU9gdoaJhPWsb9XMiFSCoXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 634/690] KVM: x86: Bail to userspace if emulation of atomic user access faults
Date: Mon,  8 Apr 2024 14:58:20 +0200
Message-ID: <20240408125422.631126129@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 5d6c7de6446e9ab3fb41d6f7d82770e50998f3de upstream.

Exit to userspace when emulating an atomic guest access if the CMPXCHG on
the userspace address faults.  Emulating the access as a write and thus
likely treating it as emulated MMIO is wrong, as KVM has already
confirmed there is a valid, writable memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220202004945.2540433-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7108,7 +7108,7 @@ static int emulator_cmpxchg_emulated(str
 	}
 
 	if (r < 0)
-		goto emul_write;
+		return X86EMUL_UNHANDLEABLE;
 	if (r)
 		return X86EMUL_CMPXCHG_FAILED;
 


