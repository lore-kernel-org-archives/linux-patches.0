Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBDABA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07D3C433EF;
	Tue,  7 Mar 2023 17:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209555;
	bh=LAqsQrN1qAGjAmWviYfjpxz5jvtkAjxLb3LrVEOcbGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNXlKzBwTAXQWCeGdjrCvNmo6ARL1Th4enR86pQRXHxExQIk22p2iFxvzzyxT+SiR
	 HmCDAHYqn/htm0zTAaQd0FueMqfwt5FPuTIyk4FJyG1tn/hLq8fh5/A01J7N1IKqum
	 8BS/IpoDvlXnSKsyne6VYFN3EETfAp+Bw6va3od0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Daniel T. Lee" <danieltimlee@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0225/1001] selftests/bpf: Fix vmtest static compilation error
Date: Tue,  7 Mar 2023 17:49:57 +0100
Message-Id: <20230307170031.648037025@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel T. Lee <danieltimlee@gmail.com>

[ Upstream commit 2514a31241e1e9067d379e0fbdb60e4bc2bf4659 ]

As stated in README.rst, in order to resolve errors with linker errors,
'LDLIBS=-static' should be used. Most problems will be solved by this
option, but in the case of urandom_read, this won't fix the problem. So
the Makefile is currently implemented to strip the 'static' option when
compiling the urandom_read. However, stripping this static option isn't
configured properly on $(LDLIBS) correctly, which is now causing errors
on static compilation.

    # LDLIBS=-static ./vmtest.sh
    ld.lld: error: attempted static link of dynamic object liburandom_read.so
    clang: error: linker command failed with exit code 1 (use -v to see invocation)
    make: *** [Makefile:190: /linux/tools/testing/selftests/bpf/urandom_read] Error 1
    make: *** Waiting for unfinished jobs....

This commit fixes this problem by configuring the strip with $(LDLIBS).

Fixes: 68084a136420 ("selftests/bpf: Fix building bpf selftests statically")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230125100440.21734-1-danieltimlee@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index c22c43bbee194..2323a2b98b815 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -181,14 +181,15 @@ endif
 # do not fail. Static builds leave urandom_read relying on system-wide shared libraries.
 $(OUTPUT)/liburandom_read.so: urandom_read_lib1.c urandom_read_lib2.c
 	$(call msg,LIB,,$@)
-	$(Q)$(CLANG) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $^ $(LDLIBS)   \
+	$(Q)$(CLANG) $(filter-out -static,$(CFLAGS) $(LDFLAGS))   \
+		     $^ $(filter-out -static,$(LDLIBS))	     \
 		     -fuse-ld=$(LLD) -Wl,-znoseparate-code -Wl,--build-id=sha1 \
 		     -fPIC -shared -o $@
 
 $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c $(OUTPUT)/liburandom_read.so
 	$(call msg,BINARY,,$@)
 	$(Q)$(CLANG) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $(filter %.c,$^) \
-		     liburandom_read.so $(LDLIBS)			       \
+		     liburandom_read.so $(filter-out -static,$(LDLIBS))	     \
 		     -fuse-ld=$(LLD) -Wl,-znoseparate-code -Wl,--build-id=sha1 \
 		     -Wl,-rpath=. -o $@
 
-- 
2.39.2



