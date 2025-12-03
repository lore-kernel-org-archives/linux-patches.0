Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B48313538;
	Wed,  3 Dec 2025 16:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778589; cv=none; b=tA1/tB/zOsEp7ebHUSn6Xw5OzIj2AVvMVeZUwKDN3Rx/mvVLq7XxRQnVyPU9mERw066JLz43IfLvhCthHP+StUAKjUga0S8zU37eVuetTpnxgY0bJ7KgefKLwK8NA3xXw/fuMZfOIcQtUauFnzmJsCCo0szVVkib8wjWtFt9yQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778589; c=relaxed/simple;
	bh=COtum0BEqQ3SnVzYZF7VnA04RAItCu/m2fhp/LA9NDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRKvj/j+3uSEKVK95OUp3BjoLZb47h4ZT9HN/97aARx+V1rn/kQvvtAeDfBZ1CGpCZJWzxFzFIFUFrKmgGpQ/iQD8/AM4M4eHt2KVN9s9jD6PeBsmx5jsAt2UVcS60scwczCoMU0tkrDpOxf7goemXCpM61oddual/7aTSUBsoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUMNQ+GT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUMNQ+GT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2331C4CEF5;
	Wed,  3 Dec 2025 16:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778589;
	bh=COtum0BEqQ3SnVzYZF7VnA04RAItCu/m2fhp/LA9NDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUMNQ+GTQSW/nuL7KBg1itJUw9r3PVVx8OR3SYr6nVDMa4LefbEmhMvV1qTCszp/d
	 XChrq7rVCEyZT2Y/SJdLKKydRsT/Lflh6HCdR44huqRmDH3i5to5gNvZTSriOunYt9
	 fopYmLC4kfjWSH8a4C5KaiDR71HPDmKy2kMydmP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Daniel T. Lee" <danieltimlee@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 5.15 392/392] libbpf: Fix invalid return address register in s390
Date: Wed,  3 Dec 2025 16:29:02 +0100
Message-ID: <20251203152428.615704531@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel T. Lee <danieltimlee@gmail.com>

commit 7244eb669397f309c3d014264823cdc9cb3f8e6b upstream.

There is currently an invalid register mapping in the s390 return
address register. As the manual[1] states, the return address can be
found at r14. In bpf_tracing.h, the s390 registers were named
gprs(general purpose registers). This commit fixes the problem by
correcting the mistyped mapping.

[1]: https://uclibc.org/docs/psABI-s390x.pdf#page=14

Fixes: 3cc31d794097 ("libbpf: Normalize PT_REGS_xxx() macro definitions")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221224071527.2292-7-danieltimlee@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/bpf_tracing.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -119,7 +119,7 @@
 #define __PT_PARM3_REG gprs[4]
 #define __PT_PARM4_REG gprs[5]
 #define __PT_PARM5_REG gprs[6]
-#define __PT_RET_REG grps[14]
+#define __PT_RET_REG gprs[14]
 #define __PT_FP_REG gprs[11]	/* Works only with CONFIG_FRAME_POINTER */
 #define __PT_RC_REG gprs[2]
 #define __PT_SP_REG gprs[15]


