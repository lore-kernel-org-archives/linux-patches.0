Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7702698AE;
	Tue,  8 Apr 2025 12:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116416; cv=none; b=DUf5577mftsEEbKZyl+oP0XqG6qPb0xnibcW3YY0VycjYf8e5AFgO2EsdA6Ip59cNkL9DG4NrrRPrHPaTudsSv3LRaexn7llhb9e4X7/ryVtpIs834NDVLn6XhBG5SAYrjxDb+lHazqmQSzRsvtCVVbThKf+b5BP1efHb/D5/wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116416; c=relaxed/simple;
	bh=XVI8VKqPIWihtMq42yFwym6ZeDJlyF7erPzz4iTB3eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h55o3h90WCBbsakacj30r7w5Uvisqq/xPVEBWqU8C4LQk/4seBMxzk/Ktd2bDHfaFdDwiU+rlUdVLeBT8g1JxfyllE0Bc2nlhju72JYZgprcBIyG+V+gI1qcsagxx7lFCr/GhgB0BP1EgQGjBFKN62cL76jbN8CNEGnuD9sASbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6sEGkl5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6sEGkl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E7CC4CEE5;
	Tue,  8 Apr 2025 12:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116415;
	bh=XVI8VKqPIWihtMq42yFwym6ZeDJlyF7erPzz4iTB3eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6sEGkl5mF1HRzT/T04ylW104O4Bj7M8NqTD05U7B22t6qxwSOB5JYVH4ksB5xj/l
	 Dr0ktPEEMeiiDPCOAF16NfYyfOAIscptReMVgf7qXuM3Ude+bPebwzwpWvaM8prftX
	 vA+AuasQdtgljFvy96iuk5M8qumwY+OgF2vvTkfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/423] selftests/bpf: Fix freplace_link segfault in tailcalls prog test
Date: Tue,  8 Apr 2025 12:47:36 +0200
Message-ID: <20250408104848.751817440@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tengda Wu <wutengda@huaweicloud.com>

[ Upstream commit a63a631c9b5cb25a1c17dd2cb18c63df91e978b1 ]

There are two bpf_link__destroy(freplace_link) calls in
test_tailcall_bpf2bpf_freplace(). After the first bpf_link__destroy()
is called, if the following bpf_map_{update,delete}_elem() throws an
exception, it will jump to the "out" label and call bpf_link__destroy()
again, causing double free and eventually leading to a segfault.

Fix it by directly resetting freplace_link to NULL after the first
bpf_link__destroy() call.

Fixes: 021611d33e78 ("selftests/bpf: Add test to verify tailcall and freplace restrictions")
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/bpf/20250122022838.1079157-1-wutengda@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/tailcalls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/tailcalls.c b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
index 40f22454cf05b..1f0977742741f 100644
--- a/tools/testing/selftests/bpf/prog_tests/tailcalls.c
+++ b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
@@ -1599,6 +1599,7 @@ static void test_tailcall_bpf2bpf_freplace(void)
 		goto out;
 
 	err = bpf_link__destroy(freplace_link);
+	freplace_link = NULL;
 	if (!ASSERT_OK(err, "destroy link"))
 		goto out;
 
-- 
2.39.5



