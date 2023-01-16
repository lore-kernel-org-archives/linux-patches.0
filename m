Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8014246B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D920CC433EF;
	Mon, 16 Jan 2023 16:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886248;
	bh=olQIEdNEtO096hKVgYo6H64hQRZjSZv9sq+jVQepkgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqLNmfKkUHQWas8lAaPiUJBVsbsqstoStyUPGn24qM4U/baA4iA4y5O63KnX+wyo2
	 /SRrWsyWBR/7ZpWHNYhFjhM92iaT8rWfk6d7ScjvNYGpMCly3oYBgn2zPvnjxKWRpk
	 3YrEnug33/Nlq+SI/OWyIdlBdkQJUc/Zn9KAF8Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 359/658] selftests/powerpc: Fix resource leaks
Date: Mon, 16 Jan 2023 16:47:27 +0100
Message-Id: <20230116154926.009969627@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 8f4ab7da904ab7027ccd43ddb4f0094e932a5877 ]

In check_all_cpu_dscr_defaults, opendir() opens the directory stream.
Add missing closedir() in the error path to release it.

In check_cpu_dscr_default, open() creates an open file descriptor.
Add missing close() in the error path to release it.

Fixes: ebd5858c904b ("selftests/powerpc: Add test for all DSCR sysfs interfaces")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221205084429.570654-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c b/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c
index 02f6b4efde14..e54d7a4089ea 100644
--- a/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c
+++ b/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c
@@ -24,6 +24,7 @@ static int check_cpu_dscr_default(char *file, unsigned long val)
 	rc = read(fd, buf, sizeof(buf));
 	if (rc == -1) {
 		perror("read() failed");
+		close(fd);
 		return 1;
 	}
 	close(fd);
@@ -65,8 +66,10 @@ static int check_all_cpu_dscr_defaults(unsigned long val)
 		if (access(file, F_OK))
 			continue;
 
-		if (check_cpu_dscr_default(file, val))
+		if (check_cpu_dscr_default(file, val)) {
+			closedir(sysfs);
 			return 1;
+		}
 	}
 	closedir(sysfs);
 	return 0;
-- 
2.35.1



