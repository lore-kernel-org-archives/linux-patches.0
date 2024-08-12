Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAF2183CA6;
	Mon, 12 Aug 2024 16:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479602; cv=none; b=jo9ke5xgdyx9/VNAL0yIMgO/NnIxT/YlOPHwi/4q85Bq/zTaiYTzCPMwNFbBrav9LZVKtykoHSKl+WRLItxzChs1dhe0JASagRtoNMWojv9Drt22lQ4w6oEIvv/koseTJcMIh9xY+jZSxrB63qnsRPLDiGtPEQvbloy5+/R8IXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479602; c=relaxed/simple;
	bh=dFAP2XTMaFDWtgunsGHatrPVAqTjpj4aXHVo6ZkFg58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bt+c9dmSMnecLd0ubpYDyLAbsl3fDHItDV/GZ6915q/u1of4oSjQxEVK0BoBVup8Lc1W2PYz8OC4lXosqdrwfqQ2+bFDOg6jjooyNTwl/zTb4y1ENyl417rcmz1CeqPKzECP6rz8jd9mEVGJQ7SD/3Xdev1V05QaGQwW5yNNQ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1JzBC5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1JzBC5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1330C4AF0C;
	Mon, 12 Aug 2024 16:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479602;
	bh=dFAP2XTMaFDWtgunsGHatrPVAqTjpj4aXHVo6ZkFg58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1JzBC5tTqxVjOSqk8BLA/yv1jJM1syIXUn6+vUPJojSWAld4mk1xh2S/vIo8DBPg
	 VgDyaVO0L9IdMyhhNLrwLG7ENoYX5vHk/XeQGLcptMFpUGOk2P3lQaMJ71lpm+LfGV
	 dHvUVk9g7za6kR7NVxhq+rXKu2p5XAOhDjmFy1Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 138/189] parisc: fix unaligned accesses in BPF
Date: Mon, 12 Aug 2024 18:03:14 +0200
Message-ID: <20240812160137.455587880@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 1fd2c10acb7b35d72101a4619ee5b2cddb9efd3a upstream.

There were spurious unaligned access warnings when calling BPF code.
Sometimes, the warnings were triggered with any incoming packet, making
the machine hard to use.

The reason for the warnings is this: on parisc64, pointers to functions
are not really pointers to functions, they are pointers to 16-byte
descriptor. The first 8 bytes of the descriptor is a pointer to the
function and the next 8 bytes of the descriptor is the content of the
"dp" register. This descriptor is generated in the function
bpf_jit_build_prologue.

The problem is that the function bpf_int_jit_compile advertises 4-byte
alignment when calling bpf_jit_binary_alloc, bpf_jit_binary_alloc
randomizes the returned array and if the array happens to be not aligned
on 8-byte boundary, the descriptor generated in bpf_jit_build_prologue is
also not aligned and this triggers the unaligned access warning.

Fix this by advertising 8-byte alignment on parisc64 when calling
bpf_jit_binary_alloc.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/net/bpf_jit_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/net/bpf_jit_core.c
+++ b/arch/parisc/net/bpf_jit_core.c
@@ -114,7 +114,7 @@ struct bpf_prog *bpf_int_jit_compile(str
 			jit_data->header =
 				bpf_jit_binary_alloc(prog_size + extable_size,
 						     &jit_data->image,
-						     sizeof(u32),
+						     sizeof(long),
 						     bpf_fill_ill_insns);
 			if (!jit_data->header) {
 				prog = orig_prog;


