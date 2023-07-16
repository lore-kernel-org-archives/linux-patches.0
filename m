Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903DC8F40
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A91C433C7;
	Sun, 16 Jul 2023 20:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539650;
	bh=RZ4Z2oa4BDF6jLfbGaxI6McBDfkzvnUK45mJkBbIReI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FU9DlmsnAlUFd2M6znkCF+5ii+fG0fSLElCwQKTHPHhjx07cW/gqenDHo4vujLlzM
	 ztjJWDf0wACTG4zM75+o4KyARYnVJY6Ua+hKwC0CREejfPd6NtzTs43yHeqAqFA/3+
	 8jry+PUhq/Uz5xTTqmzGmSkWu6iYSCvv/sGCAcNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Gladkov <legion@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Stanislav Fomichev <sdf@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/591] selftests/bpf: Do not use sign-file as testcase
Date: Sun, 16 Jul 2023 21:43:42 +0200
Message-ID: <20230716194926.029454935@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexey Gladkov <legion@kernel.org>

[ Upstream commit f04a32b2c5b539e3c097cb5c7c1df12a8f4a0cf0 ]

The sign-file utility (from scripts/) is used in prog_tests/verify_pkcs7_sig.c,
but the utility should not be called as a test. Executing this utility produces
the following error:

  selftests: /linux/tools/testing/selftests/bpf: urandom_read
  ok 16 selftests: /linux/tools/testing/selftests/bpf: urandom_read

  selftests: /linux/tools/testing/selftests/bpf: sign-file
  not ok 17 selftests: /linux/tools/testing/selftests/bpf: sign-file # exit=2

Also, urandom_read is mistakenly used as a test. It does not lead to an error,
but should be moved over to TEST_GEN_FILES as well. The empty TEST_CUSTOM_PROGS
can then be removed.

Fixes: fc97590668ae ("selftests/bpf: Add test for bpf_verify_pkcs7_signature() kfunc")
Signed-off-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Acked-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/bpf/ZEuWFk3QyML9y5QQ@example.org
Link: https://lore.kernel.org/bpf/88e3ab23029d726a2703adcf6af8356f7a2d3483.1684316821.git.legion@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 0465ddc81f352..3b57fbf8fff4a 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -85,8 +85,7 @@ TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
 	xskxceiver xdp_redirect_multi xdp_synproxy veristat
 
-TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read $(OUTPUT)/sign-file
-TEST_GEN_FILES += liburandom_read.so
+TEST_GEN_FILES += liburandom_read.so urandom_read sign-file
 
 # Emit succinct information message describing current building step
 # $1 - generic step name (e.g., CC, LINK, etc);
-- 
2.39.2



