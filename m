Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2451917F1;
	Wed,  5 Feb 2025 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766546; cv=none; b=m8hGr1SbME9e/I07oEaArLMbguAxzrZfUIj7j6Ak+6yTZ7cWa85AKTCNhCx38GSuePW8S/Yfaf7COz1VeVCV3Fq43qJODIN5n4z3boe3iYEwrN0Hdcta4rk3tz2z6S4/sdKHhaNXGv0W+SkhYQqB5buFeTacjiSdCmT2zHR6Zt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766546; c=relaxed/simple;
	bh=d/UvbPlxNXHo9UVAjvfMLOJA2DrwcsWWLnZpOVD1GAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWGC56kyj/nJudysl4PsD5LouqhGr810N+KopLvNZqMm4OPQlwnr4Un5dWHNEbypbZQq3i84j/MQi3epOKWZ58geCRzmVPSLT1fRzpXoaGnJORl8GLyBqdvlVt8Uoao2rBApmPXxE4kogwVSShAzfY3+dxVwYXtHJhz0CqMGfVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxiQXzKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxiQXzKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084B7C4CED1;
	Wed,  5 Feb 2025 14:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766546;
	bh=d/UvbPlxNXHo9UVAjvfMLOJA2DrwcsWWLnZpOVD1GAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxiQXzKS3YKYifKbpXEaIwO/6EGoSk78Hc3MXoXy65IT6hab5OV8TydY9r2XbsJx5
	 TT/G6kyvzTG7frh1ZfjqKYIyGYmPGa1aiKzN9CKMofuOfi6v2vsZbbIm4fk3CDgVuV
	 7WwIleL5JvST8C06h8sp4o6+pTtKGW/UQs8B5E4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <mrpre@163.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 286/623] selftests/bpf: Avoid generating untracked files when running bpf selftests
Date: Wed,  5 Feb 2025 14:40:28 +0100
Message-ID: <20250205134507.171880031@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <mrpre@163.com>

[ Upstream commit 73b9075f334f5debf28646884a320b796b27768d ]

Currently, when we run the BPF selftests with the following command:

  make -C tools/testing/selftests TARGETS=bpf SKIP_TARGETS=""

The command generates untracked files and directories with make version
less than 4.4:

'''
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	tools/testing/selftests/bpfFEATURE-DUMP.selftests
	tools/testing/selftests/bpffeature/
'''

We lost slash after word "bpf". The reason is slash appending code is as
follow:

'''
OUTPUT := $(OUTPUT)/
$(eval include ../../../build/Makefile.feature)
OUTPUT := $(patsubst %/,%,$(OUTPUT))
'''

This way of assigning values to OUTPUT will never be effective for the
variable OUTPUT provided via the command argument [1] and BPF makefile
is called from parent Makfile(tools/testing/selftests/Makefile) like:

'''
all:
  ...
	$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET
'''

According to GNU make, we can use override Directive to fix this issue [2].

  [1] https://www.gnu.org/software/make/manual/make.html#Overriding
  [2] https://www.gnu.org/software/make/manual/make.html#Override-Directive

Fixes: dc3a8804d790 ("selftests/bpf: Adapt OUTPUT appending logic to lower versions of Make")
Signed-off-by: Jiayuan Chen <mrpre@163.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20241224075957.288018-1-mrpre@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 7eeb3cbe18c70..8d206266d98c8 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -203,9 +203,9 @@ ifeq ($(shell expr $(MAKE_VERSION) \>= 4.4), 1)
 $(let OUTPUT,$(OUTPUT)/,\
 	$(eval include ../../../build/Makefile.feature))
 else
-OUTPUT := $(OUTPUT)/
+override OUTPUT := $(OUTPUT)/
 $(eval include ../../../build/Makefile.feature)
-OUTPUT := $(patsubst %/,%,$(OUTPUT))
+override OUTPUT := $(patsubst %/,%,$(OUTPUT))
 endif
 endif
 
-- 
2.39.5



