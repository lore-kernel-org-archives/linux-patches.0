Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929531D5ABA;
	Wed, 25 Feb 2026 01:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982955; cv=none; b=mJ0GbZhSm3MiMl9aQ8Np/+kuauxxTVn4w1jKtpjYKx0Czjdgt7WUTsO3QoKscqywnW9TBScNXr83k5Y/Wb8sjPUkC81h/7EUSoJUIkr25LRiksDDwSK58duH8eqlZ4n04pHas/GF8tuqJj/Y2myt/gBvpolKZgwUvv6U/LnclRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982955; c=relaxed/simple;
	bh=CPaGR3pQ8bUc/+objnSoKvJ4cZu4urYXmeZ41b+PHEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePyT9P5A4cuF7EhbAiFUjLVvn+hNZeWJFD8VA5tIr8tDHTI4cv1YRfCem9s9bc/J4DoGk5I3ux4iudDqF+ZiQBQq0lkPcz+fpk4+Y1mVyIaNFo20uNyAAyifQU2ntUWvF9/8jBbNPGSmU2qxZYiFDYfSSdUfEizXltMiDa1l6Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSF17j79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSF17j79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D127C116D0;
	Wed, 25 Feb 2026 01:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982955;
	bh=CPaGR3pQ8bUc/+objnSoKvJ4cZu4urYXmeZ41b+PHEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSF17j79tB66G/1TjVz7tDjGoYhIp7EJxwLOCARryBAgrqZdCAp0bShOlYZW1DZcQ
	 8E2Q+GNdpGjJH89lAzHgJpbMmlUaYWUTqnQYPAV3io7pYeWGeBKBFO9D3+bjmK486N
	 UM6ijIZPezQ14gUbm2fQDcgF0qRuTjaRmkNGToHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	KP Singh <kpsingh@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 132/781] bpf: Limit bpf program signature size
Date: Tue, 24 Feb 2026 17:14:01 -0800
Message-ID: <20260225012402.908505591@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KP Singh <kpsingh@kernel.org>

[ Upstream commit ea1535e28bb3773fc0b3cbd1f3842b808016990c ]

Practical BPF signatures are significantly smaller than
KMALLOC_MAX_CACHE_SIZE

Allowing larger sizes opens the door for abuse by passing excessive
size values and forcing the kernel into expensive allocation paths (via
kmalloc_large or vmalloc).

Fixes: 349271568303 ("bpf: Implement signature verification for BPF programs")
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: KP Singh <kpsingh@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260205063807.690823-1-kpsingh@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 763868d327b4a..f89aa142f71b8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2815,6 +2815,13 @@ static int bpf_prog_verify_signature(struct bpf_prog *prog, union bpf_attr *attr
 	void *sig;
 	int err = 0;
 
+	/*
+	 * Don't attempt to use kmalloc_large or vmalloc for signatures.
+	 * Practical signature for BPF program should be below this limit.
+	 */
+	if (attr->signature_size > KMALLOC_MAX_CACHE_SIZE)
+		return -EINVAL;
+
 	if (system_keyring_id_check(attr->keyring_id) == 0)
 		key = bpf_lookup_system_key(attr->keyring_id);
 	else
-- 
2.51.0



