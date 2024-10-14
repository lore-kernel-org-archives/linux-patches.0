Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736FE4A24;
	Mon, 14 Oct 2024 14:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916757; cv=none; b=CCkNctMtx6OAse7o321QSw8W5S05u2g78WymjrixRBRhzZiEbGQmH0ILYeN9kB0KrRz1DKUMCuo0k1JlpCUgPoZI3IYg0A7AuC+vr4MFHaGD7/IUkusVLgy/fcQBft2n6ntokVyJ6xjwFexGSMlLxAIc1WF2PCzupchC3yB+StI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916757; c=relaxed/simple;
	bh=v1VAMGVtRJygQKTX5QRJ4lG8JNOKY33bZCjhEFkF4Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSuj/DzcKFV0yQJQsKKGKQ2UJHSXUx1UDNtYPjY1Eij/OUcIHakzVmCPZaNuhmCtMEuU0COO0e8sxfJttMzUrfA3qMf/wlcrvtKUFD1HGU7UaQ2SBMf+ZaogNXVVwvgb/s/UQHp9+eSu/jY9+F2BUXuGa80l5xUphPt7QrWYDoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQvXluZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQvXluZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCE2C4CEC3;
	Mon, 14 Oct 2024 14:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916757;
	bh=v1VAMGVtRJygQKTX5QRJ4lG8JNOKY33bZCjhEFkF4Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQvXluZNBEeFeVBhZhZFKm3LBOtyIQ5pqnaVn6rrFfliYEp7U2rvuUF05wQxgKQhU
	 wD4POZU6tJ4E0manQ4FrJZSbILEBSBoSDqnY1FXgI2MynXHhaG9GSEIaFku7Bn7Ps0
	 cAIfKAltPvAiB3HkZhD8Rd35FeG0PF6v/HtuQOPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/213] selftests/bpf: Fix ARG_PTR_TO_LONG {half-,}uninitialized test
Date: Mon, 14 Oct 2024 16:19:22 +0200
Message-ID: <20241014141045.176971869@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit b8e188f023e07a733b47d5865311ade51878fe40 ]

The assumption of 'in privileged mode reads from uninitialized stack locations
are permitted' is not quite correct since the verifier was probing for read
access rather than write access. Both tests need to be annotated as __success
for privileged and unprivileged.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20240913191754.13290-6-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/verifier_int_ptr.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/verifier_int_ptr.c b/tools/testing/selftests/bpf/progs/verifier_int_ptr.c
index 589e8270de462..d873da71f1436 100644
--- a/tools/testing/selftests/bpf/progs/verifier_int_ptr.c
+++ b/tools/testing/selftests/bpf/progs/verifier_int_ptr.c
@@ -8,7 +8,6 @@
 SEC("socket")
 __description("ARG_PTR_TO_LONG uninitialized")
 __success
-__failure_unpriv __msg_unpriv("invalid indirect read from stack R4 off -16+0 size 8")
 __naked void arg_ptr_to_long_uninitialized(void)
 {
 	asm volatile ("					\
@@ -36,9 +35,7 @@ __naked void arg_ptr_to_long_uninitialized(void)
 
 SEC("socket")
 __description("ARG_PTR_TO_LONG half-uninitialized")
-/* in privileged mode reads from uninitialized stack locations are permitted */
-__success __failure_unpriv
-__msg_unpriv("invalid indirect read from stack R4 off -16+4 size 8")
+__success
 __retval(0)
 __naked void ptr_to_long_half_uninitialized(void)
 {
-- 
2.43.0



