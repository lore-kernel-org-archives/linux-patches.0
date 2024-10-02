Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647DD1D1302;
	Wed,  2 Oct 2024 14:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878021; cv=none; b=pkPCyZUxlw6RvmDx+YwiR7BrJN451PHmM7KcNf4lBF5eM0fSqkYcUzH27LcqMjKx23kEqKelPCXTmWxrTVdpJA2XHpAduh/NrZKBZqacGBxcO73BINzCvwfrX916TD2hKv/fo0sKxB7R/yvNe5/WInSob6H98GM/w47ofg0Q1Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878021; c=relaxed/simple;
	bh=wKcBeuhblnlVZZ3iypzKmDwiUPVPQWI+TFvJ/GKh018=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DE8hiqebGQzi1JQ4YZb2fMbzZoCGn8TZ5r/PqHni6sw/IJ7UTXVOHMEAUEedG/8S9SdYuYgr3fac50JnjLqGas+8aN/1GCarnpH3f0fX/GJYaLysdcF8IPH85R9DOndt3Z6ngYz8Xl8plCdRrtZsXFEljBsWTjdHtcrQbvkZwJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGG9Ulx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGG9Ulx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6F4C4CEC2;
	Wed,  2 Oct 2024 14:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878021;
	bh=wKcBeuhblnlVZZ3iypzKmDwiUPVPQWI+TFvJ/GKh018=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGG9Ulx/dWHRHXK4vYp3I6vWPlXekAEEIeOiL5dt+thgQ3tvEWYsQDK9u5Dq/B8wV
	 dGLJzUq1tjML0u42Lcvp1Xna2Ba66yfjde5Ab2K16kX1CwHjlcVKVBjHAlV6tPlblH
	 risB+zuGVtoz6o1682OLN56bGmvArxZXxCiTTsYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 233/634] selftests/bpf: Fix error linking uprobe_multi on mips
Date: Wed,  2 Oct 2024 14:55:33 +0200
Message-ID: <20241002125820.296014583@linuxfoundation.org>
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
index dd49c1d23a604..2cca4913f2d45 100644
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



