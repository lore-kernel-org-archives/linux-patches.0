Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36281494B8;
	Mon, 12 Aug 2024 16:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480502; cv=none; b=Yqpw36kPhS0CQdREilhH+pm0O4oOFGSrWyUX/M2zoiJx6ShL5WYUKrqPAjjpqvi/pqPTjdqMSYElNiKw3wS7+wcclYESXdD6Eo1bCdNBck48031imd6oZ7ouhDArSqr/nUXZqTiiSXHsdYDN8qaVATt8wZxgBSwRf12phX6tiwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480502; c=relaxed/simple;
	bh=n0pWSROb00cySgL+Ygmc91yIAm+bHJJtHesI4ecKyYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PC4UkzlWlpiiNe/8gYsAOQ86QdruEExU8TjcVIrfwrP58sqdwzNTl4AHK/loYq9ciNTqM0/deHKbQoteTF1Iwi6fLdX7YiaMrK+YCFZo7ifj9pqc//4hbvIrfJtI7SQsXkhbdW4eHTotSaJWZlVyMVzNVvvwKCPerwGOdnWksB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rN364Jgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rN364Jgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFF7C32782;
	Mon, 12 Aug 2024 16:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480501;
	bh=n0pWSROb00cySgL+Ygmc91yIAm+bHJJtHesI4ecKyYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rN364JgwLJ08rlqw/js7+v52uUKujyINPoX/dY7ZCRZZk0LsMa6dtqnS2YJi71CTj
	 zcU6iTTh+sS68n7KdVIKlJkOCmrzdR9kFpBRIruMEwpLaEKN3xJCEleS9FU8UTMsoo
	 D1Mkfx05YCpkeMgy0vcI09yCwKYyraIWIF6x9Quc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.10 214/263] parisc: fix unaligned accesses in BPF
Date: Mon, 12 Aug 2024 18:03:35 +0200
Message-ID: <20240812160154.736533526@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


