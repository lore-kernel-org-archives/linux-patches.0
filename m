Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA124FBE8
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B648C433D2;
	Thu,  1 Jun 2023 13:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625965;
	bh=K/xKNoIuzB7rDEgRy7eOXxRaaUq/nom7QM8tG9venyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqJNPhz/lC1aJRZ0F0N91Q3TeaceS346ANdqEaLPoSUMGc9pKgc6okxgXwEqy0X1D
	 vE5O7JTcwZMgZ0ie20QHVO8rk6Thqnwz+nRUwjL27KgR6M0u3jlJAzsC4oSxj4nn6X
	 9rK+dJ1nPK7t1GUkR+rvTgw8Ze080AdIRQpPZM88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Sowden <jeremy@azazel.net>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 06/45] selftests/bpf: Fix pkg-config call building sign-file
Date: Thu,  1 Jun 2023 14:21:02 +0100
Message-Id: <20230601131938.994669081@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131938.702671708@linuxfoundation.org>
References: <20230601131938.702671708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Sowden <jeremy@azazel.net>

[ Upstream commit 5f5486b620cd43b16a1787ef92b9bc21bd72ef2e ]

When building sign-file, the call to get the CFLAGS for libcrypto is
missing white-space between `pkg-config` and `--cflags`:

  $(shell $(HOSTPKG_CONFIG)--cflags libcrypto 2> /dev/null)

Removing the redirection of stderr, we see:

  $ make -C tools/testing/selftests/bpf sign-file
  make: Entering directory '[...]/tools/testing/selftests/bpf'
  make: pkg-config--cflags: No such file or directory
    SIGN-FILE sign-file
  make: Leaving directory '[...]/tools/testing/selftests/bpf'

Add the missing space.

Fixes: fc97590668ae ("selftests/bpf: Add test for bpf_verify_pkcs7_signature() kfunc")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Link: https://lore.kernel.org/bpf/20230426215032.415792-1-jeremy@azazel.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index b677dcd0b77af..ad01c9e1ff12b 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -197,7 +197,7 @@ $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c $(OUTPUT)/liburandom_r
 
 $(OUTPUT)/sign-file: ../../../../scripts/sign-file.c
 	$(call msg,SIGN-FILE,,$@)
-	$(Q)$(CC) $(shell $(HOSTPKG_CONFIG)--cflags libcrypto 2> /dev/null) \
+	$(Q)$(CC) $(shell $(HOSTPKG_CONFIG) --cflags libcrypto 2> /dev/null) \
 		  $< -o $@ \
 		  $(shell $(HOSTPKG_CONFIG) --libs libcrypto 2> /dev/null || echo -lcrypto)
 
-- 
2.39.2



