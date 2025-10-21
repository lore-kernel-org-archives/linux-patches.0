Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33F6279798;
	Tue, 21 Oct 2025 20:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077552; cv=none; b=WklSSsgefcxWMbbZPf4f+Ddsi+qEqFFHE3Q0I+BuKd/4MmLMnVNiDwnAaeluzTKLal6wlVQG9Au4nyqSN62XX1WjnYBoLjx345cpqS4Fmnew3zDWCiSG8lAaoUbl0f6z41VGWCyMvyiilc2zV89wCXxiTAieK9Si45fRJ1VfiRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077552; c=relaxed/simple;
	bh=JvywHpEGtIp7pYUXmEXnTxZLwQqLiAw5Jqq8BA74HrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBUM++wTjDX4mhh6U0zrVo7LJ1Nj3sxkjSK6E84FbSerjcVexfM7ScyitU5Ilh17TMhQbOzZoabFRmuDEpYnRxrJWe2kT710MAy5pxZDsFfTZOx8vSFIxyIYkWihl6+kaFWUlQ/v/yYR0PUJDEPoWZtzBpJxy6729Xgj/R8+3uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXfO9tQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXfO9tQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C61C4CEF1;
	Tue, 21 Oct 2025 20:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077552;
	bh=JvywHpEGtIp7pYUXmEXnTxZLwQqLiAw5Jqq8BA74HrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXfO9tQF/6Hh1M9pOS26NWMlPZL86qsISqGcxtVZ5eRYcYQ8T9wFmxIGNYaOBraB4
	 6LyXlh//eM9tpiQmYzUb5OXGD4SKrdA+r26mzsmX3W5yBK1HTgk7I4SHCHakqv+Pzt
	 Vuz2gBWnh/aApMt5iCNyVKyWDTwZn4ir3GG9+Kfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xing Guo <higuoxing@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 134/159] selftests: arg_parsing: Ensure data is flushed to disk before reading.
Date: Tue, 21 Oct 2025 21:51:51 +0200
Message-ID: <20251021195046.370432712@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xing Guo <higuoxing@gmail.com>

[ Upstream commit 0c1999ed33722f85476a248186d6e0eb2bf3dd2a ]

test_parse_test_list_file writes some data to
/tmp/bpf_arg_parsing_test.XXXXXX and parse_test_list_file() will read
the data back.  However, after writing data to that file, we forget to
call fsync() and it's causing testing failure in my laptop.  This patch
helps fix it by adding the missing fsync() call.

Fixes: 64276f01dce8 ("selftests/bpf: Test_progs can read test lists from file")
Signed-off-by: Xing Guo <higuoxing@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20251016035330.3217145-1-higuoxing@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/arg_parsing.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/arg_parsing.c b/tools/testing/selftests/bpf/prog_tests/arg_parsing.c
index fbf0d9c2f58b3..e27d66b75fb1f 100644
--- a/tools/testing/selftests/bpf/prog_tests/arg_parsing.c
+++ b/tools/testing/selftests/bpf/prog_tests/arg_parsing.c
@@ -144,6 +144,9 @@ static void test_parse_test_list_file(void)
 	if (!ASSERT_OK(ferror(fp), "prepare tmp"))
 		goto out_fclose;
 
+	if (!ASSERT_OK(fsync(fileno(fp)), "fsync tmp"))
+		goto out_fclose;
+
 	init_test_filter_set(&set);
 
 	if (!ASSERT_OK(parse_test_list_file(tmpfile, &set, true), "parse file"))
-- 
2.51.0



