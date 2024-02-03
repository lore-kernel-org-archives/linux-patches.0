Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAB263B1;
	Sat,  3 Feb 2024 04:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933722; cv=none; b=CLH/kN+gLOwi2nCD5YHhyTRRktjhYppKXnzYJZLVsjvXJFxnKuWPPepesZG7Tmv055v7PE/JGx6jEZ8gSpk0kspYz5N3LZaEc/w0zSSgDcPCZpN8bSbFqtkwlk/plbikzCIchAGfHIPhTQ8FnI9BodeLuZ6v5tilWnyDvkGrbUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933722; c=relaxed/simple;
	bh=1l+XPyTyBqLpcZHMfu+Ai7w2tkqUglCJNQZD1WS9Ra8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQFsLw+qrvAIVN57HONIdpJlAo6srHHWllcRaHVtFlwvuVZXM94Wqz5Zo3HdCUnmJNbcs6ydn5Od9Nu0k5ysXkTz7u6lo16zfvsxMB9CR3OmqcTXADnGHLpxJ2w+jyKDoUAMXKUYLzifPiC4Kz5E7bpWBgbPKlTcecYbQLQn0Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldF3/fIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldF3/fIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C3AC43399;
	Sat,  3 Feb 2024 04:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933721;
	bh=1l+XPyTyBqLpcZHMfu+Ai7w2tkqUglCJNQZD1WS9Ra8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldF3/fIThM1PMu+LZb6Ry2cNSt/QfOYMReGW/Y86TN46t3Nd+lKFSf9DPAVrXZheb
	 5yNH7MJ3RsNXIvN+xuv2pjmWmC+7bWQM+lWrV8c31DPyWnLS7oak375L5V85ArLQ8n
	 6WV5QPXN6rX2LxXjF3+LQDUnVLOWwbYwX6cjZovI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Subject: [PATCH 6.6 321/322] selftests/bpf: Remove flaky test_btf_id test
Date: Fri,  2 Feb 2024 20:06:58 -0800
Message-ID: <20240203035409.407061189@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

commit 56925f389e152dcb8d093435d43b78a310539c23 upstream.

With previous patch, one of subtests in test_btf_id becomes
flaky and may fail. The following is a failing example:

  Error: #26 btf
  Error: #26/174 btf/BTF ID
    Error: #26/174 btf/BTF ID
    btf_raw_create:PASS:check 0 nsec
    btf_raw_create:PASS:check 0 nsec
    test_btf_id:PASS:check 0 nsec
    ...
    test_btf_id:PASS:check 0 nsec
    test_btf_id:FAIL:check BTF lingersdo_test_get_info:FAIL:check failed: -1

The test tries to prove a btf_id not available after the map is closed.
But btf_id is freed only after workqueue and a rcu grace period, compared
to previous case just after a rcu grade period.
Depending on system workload, workqueue could take quite some time
to execute function bpf_map_free_deferred() which may cause the test failure.
Instead of adding arbitrary delays, let us remove the logic to
check btf_id availability after map is closed.

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20231214203820.1469402-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/btf.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -4630,11 +4630,6 @@ static int test_btf_id(unsigned int test
 	/* The map holds the last ref to BTF and its btf_id */
 	close(map_fd);
 	map_fd = -1;
-	btf_fd[0] = bpf_btf_get_fd_by_id(map_info.btf_id);
-	if (CHECK(btf_fd[0] >= 0, "BTF lingers")) {
-		err = -1;
-		goto done;
-	}
 
 	fprintf(stderr, "OK");
 


