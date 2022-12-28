Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4510F1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B794DC433EF;
	Wed, 28 Dec 2022 15:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240799;
	bh=7VCf0FytvkdTWwX2JiIdKXDlZYw7In5IzXPQ3hcjjMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ME/joJlDy6QiY6D8yHU2swR69Bq28sLFxk9Y26TgEtBlHGw22UGsUfX9iuxNtgA1H
	 BGQwNk60uANtZxR/a/r+r6uv/QIVT+EXtCHoUz/ns8pzu0qjMxCp2Z3yFfR6iPar6a
	 YHKfKZcLxME9slKRL9IGdGxwb7ih00pnJj/Ic2aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0204/1073] selftests/bpf: Fix error failure of case test_xdp_adjust_tail_grow
Date: Wed, 28 Dec 2022 15:29:52 +0100
Message-Id: <20221228144333.559168801@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 4abdb1d5b250df4b5b3afd394d5e2fa516064c04 ]

test_xdp_adjust_tail_grow failed with ipv6:
  test_xdp_adjust_tail_grow:FAIL:ipv6 unexpected error: -28 (errno 28)

The reason is that this test case tests ipv4 before ipv6, and when ipv4
test finished, topts.data_size_out was set to 54, which is smaller than the
ipv6 output data size 114, so ipv6 test fails with NOSPC error.

Fix it by reset topts.data_size_out to sizeof(buf) before testing ipv6.

Fixes: 04fcb5f9a104 ("selftests/bpf: Migrate from bpf_prog_test_run")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/bpf/20221011120108.782373-6-xukuohai@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
index 21ceac24e174..7efee9b047d9 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -63,6 +63,7 @@ static void test_xdp_adjust_tail_grow(void)
 	expect_sz = sizeof(pkt_v6) + 40; /* Test grow with 40 bytes */
 	topts.data_in = &pkt_v6;
 	topts.data_size_in = sizeof(pkt_v6);
+	topts.data_size_out = sizeof(buf);
 	err = bpf_prog_test_run_opts(prog_fd, &topts);
 	ASSERT_OK(err, "ipv6");
 	ASSERT_EQ(topts.retval, XDP_TX, "ipv6 retval");
-- 
2.35.1



