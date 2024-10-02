Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7081D07AD;
	Wed,  2 Oct 2024 14:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877957; cv=none; b=PfW88CEvLqgrr9iEuU+nnv/ThcjCiIW6JhmeTATtEqSGYgTL02RpYfZOlQ1XoYOwxWnDrFotSKopLtvLPhgB4mDF3kOm7tvbssvoRdtTrZvUgO4W5F0DcbQwGt/Zaj8AW2f3nK3nkoVVFikA4y6Ixhb95efLe7m9FQMw6viGgWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877957; c=relaxed/simple;
	bh=Jnz3QpoixdEiVtyCS5gEaJyXTWYeC4Kegj+VVCTSDvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q48TNcmOL6mtJ5QEcuK1tMw+B15W8ynAWY44JJeVDf9UdLqk1PHvsKmANqlxtDNli77SbytScjxFcLruCWQixtifV35lhX0lATbwG8QSsP/64dnhYr50y9vZ2QbDlMrUciny3HXtXQJBhlH4uOsy1XbEPc1oOACV5cOVHXHxrn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Amp489sS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Amp489sS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89502C4CEC2;
	Wed,  2 Oct 2024 14:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877956;
	bh=Jnz3QpoixdEiVtyCS5gEaJyXTWYeC4Kegj+VVCTSDvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Amp489sSDOVDAsAj5KGYZnhuAze3MrajPiuiADawOI6kCwzNgpAVknpYgOuNGmI4e
	 fN4bQwepNMx0yvqoqgLnA7sQTjM8LsgeHAN1FCBV4WqPegq/ev33rrJYBwduOgUflI
	 svih5PcZ5OYQfdCy2li9pEWcyG1rFlyhw8KZFroM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 235/634] tools/runqslower: Fix LDFLAGS and add LDLIBS support
Date: Wed,  2 Oct 2024 14:55:35 +0200
Message-ID: <20241002125820.374059054@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit f86601c3661946721e8f260bdd812b759854ac22 ]

Actually use previously defined LDFLAGS during build and add support for
LDLIBS to link extra standalone libraries e.g. 'argp' which is not provided
by musl libc.

Fixes: 585bf4640ebe ("tools: runqslower: Add EXTRA_CFLAGS and EXTRA_LDFLAGS support")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://lore.kernel.org/bpf/20240723003045.2273499-1-tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/runqslower/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
index d8288936c9120..c4f1f1735af65 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -15,6 +15,7 @@ INCLUDES := -I$(OUTPUT) -I$(BPF_INCLUDE) -I$(abspath ../../include/uapi)
 CFLAGS := -g -Wall $(CLANG_CROSS_FLAGS)
 CFLAGS += $(EXTRA_CFLAGS)
 LDFLAGS += $(EXTRA_LDFLAGS)
+LDLIBS += -lelf -lz
 
 # Try to detect best kernel BTF source
 KERNEL_REL := $(shell uname -r)
@@ -51,7 +52,7 @@ clean:
 libbpf_hdrs: $(BPFOBJ)
 
 $(OUTPUT)/runqslower: $(OUTPUT)/runqslower.o $(BPFOBJ)
-	$(QUIET_LINK)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
+	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $^ $(LDLIBS) -o $@
 
 $(OUTPUT)/runqslower.o: runqslower.h $(OUTPUT)/runqslower.skel.h	      \
 			$(OUTPUT)/runqslower.bpf.o | libbpf_hdrs
-- 
2.43.0



