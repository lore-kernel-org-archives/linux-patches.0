Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9285A1D0781;
	Wed,  2 Oct 2024 13:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875992; cv=none; b=SrVbGJMAZqDej/8mImrTzaIDJOjT6lUBGhyNiYA/VPo4qvgjKhvCWCVT9HRuWckiObKIrwOa163KfS1JJ5Lk5rV2bo6D7xOuM0RahSLVymg1O15Cq+jeB5YeyI4EpQUfNL/vUXt3vGKmi+NauoH1IaHbKp8qxD9SvSITLQhitzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875992; c=relaxed/simple;
	bh=o+4m1pdeA637yuRNRjKPLi9Pc9swH8APsZBL++Cxzw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laiHDrpti/LaLqybVRcX1Q2xHSBMhnQnTHnFBmcJoydBsHpbCvL8xYUtLxz09o8H4H0XupFfCKUXMU0rhY+7/A5gwOqHbxpgfyWzDsflOH0TaKbI5woRAjM16BbRa71/E0UHSjGXUOmtqLgeiAYtd148By7YbN71CTASzlzc6qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dv3lQwEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dv3lQwEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F82C4CEC5;
	Wed,  2 Oct 2024 13:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875992;
	bh=o+4m1pdeA637yuRNRjKPLi9Pc9swH8APsZBL++Cxzw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dv3lQwEz9MGbiRlbxbrY7FAHSKGy2MM7fJ1WYxq6csr/aBReEgVYM9TGhH0eyufw/
	 9WJnWmimRNxkBf+SbcNvSyqpiRGp3syh/Woc4FvS5ZZNNyYHyaX5kRsecEKaIpDSD3
	 DbpuBj2Sus+2N7mDA3wd1uD8a1T5EVzh1Uu0y9TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 260/695] selftests/bpf: Fix error linking uprobe_multi on mips
Date: Wed,  2 Oct 2024 14:54:18 +0200
Message-ID: <20241002125832.825935170@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit a5f40d596bff182b4b47547712f540885e8fb17b ]

Linking uprobe_multi.c on mips64el fails due to relocation overflows, when
the GOT entries required exceeds the default maximum. Add a specific CFLAGS
(-mxgot) for uprobe_multi.c on MIPS that allows using a larger GOT and
avoids errors such as:

  /tmp/ccBTNQzv.o: in function `bench':
  uprobe_multi.c:49:(.text+0x1d7720): relocation truncated to fit: R_MIPS_GOT_DISP against `uprobe_multi_func_08188'
  uprobe_multi.c:49:(.text+0x1d7730): relocation truncated to fit: R_MIPS_GOT_DISP against `uprobe_multi_func_08189'
  ...
  collect2: error: ld returned 1 exit status

Fixes: 519dfeaf5119 ("selftests/bpf: Add uprobe_multi test program")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/14eb7b70f8ccef9834874d75eb373cb9292129da.1721692479.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 81d4757ecd4c6..9351f37b720cf 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -762,6 +762,8 @@ $(OUTPUT)/veristat: $(OUTPUT)/veristat.o
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.a %.o,$^) $(LDLIBS) -o $@
 
+# Linking uprobe_multi can fail due to relocation overflows on mips.
+$(OUTPUT)/uprobe_multi: CFLAGS += $(if $(filter mips, $(ARCH)),-mxgot)
 $(OUTPUT)/uprobe_multi: uprobe_multi.c
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(CFLAGS) -O0 $(LDFLAGS) $^ $(LDLIBS) -o $@
-- 
2.43.0



