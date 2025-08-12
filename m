Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7512F5481;
	Tue, 12 Aug 2025 18:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023659; cv=none; b=CuPcv26S8MgkY+4n/N+oxBo5sVvSUQsazwXYc96cWNzOkRMxAqAuMmaHen9WJdJC0q3AcEzdgdr69/eChKKacDwvERcNCmauL6VmDn2wuYONlILlcE1g7EAYMINNyw+TXsmbgAHohPWmFEaj2EkvAFVADORJ1rOr8qmg2gaIHxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023659; c=relaxed/simple;
	bh=pvIyUsUIkp+9/E/I78AOzndEqdrfZOjJkdBQ3XpkMTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLwVm49Y99+VnnoHqXQHLHZzJ0EQoBqs8Az4190UUqwVfmJbGV4tVWOvAXJGc37tMIJna6h/mgt73tboaDMbyRVml0JYPM9q5lcCPFAvJ4HpK/Bb5xuCcGPSahPV7fl2FfvPy110D3U/ZZHErSa265wWSaNsb9qU0isnWLPhx9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUhrYmJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUhrYmJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF725C4CEF0;
	Tue, 12 Aug 2025 18:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023659;
	bh=pvIyUsUIkp+9/E/I78AOzndEqdrfZOjJkdBQ3XpkMTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUhrYmJMO8kwJ3slWvQ1MIT3j54SS8+SaLlE5vlkiUIzK2LGTZHIZwv6663qvbQSz
	 yFezDupF9+likTk1d9JHKf5QQ+hAW0+uPnxspOLwG6dge36oUj2YoFgHUIliQzE8pe
	 jLKhejbWPNvQH+i8/JaCilfHHcJ9nJAWEqFBc5o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fushuai Wang <wangfushuai@baidu.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 145/627] selftests/bpf: fix signedness bug in redir_partial()
Date: Tue, 12 Aug 2025 19:27:20 +0200
Message-ID: <20250812173424.811965924@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fushuai Wang <wangfushuai@baidu.com>

[ Upstream commit 6a4bd31f680a1d1cf06492fe6dc4f08da09769e6 ]

When xsend() returns -1 (error), the check 'n < sizeof(buf)' incorrectly
treats it as success due to unsigned promotion. Explicitly check for -1
first.

Fixes: a4b7193d8efd ("selftests/bpf: Add sockmap test for redirecting partial skb data")
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Link: https://lore.kernel.org/r/20250612084208.27722-1-wangfushuai@baidu.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 1d98eee7a2c3..f1bdccc7e4e7 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -924,6 +924,8 @@ static void redir_partial(int family, int sotype, int sock_map, int parser_map)
 		goto close;
 
 	n = xsend(c1, buf, sizeof(buf), 0);
+	if (n == -1)
+		goto close;
 	if (n < sizeof(buf))
 		FAIL("incomplete write");
 
-- 
2.39.5



