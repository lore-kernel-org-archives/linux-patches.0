Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252BA212B3B;
	Tue, 17 Jun 2025 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175271; cv=none; b=sHqPkB9m9QM8n1qW04NdSQrr6IP41U2wHovyMS+h6+UptI3Te7kqSKaVdPnSVDQ+X9NpA1Q1XizAHs1NNJwF3ltuqg2KgJnHER4kR7fBZet8cRUM7Nias5mO4NX7bHoNducvNbomMAXKRJoEpQ89VDz6/BENiafZr+wwlCbxLiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175271; c=relaxed/simple;
	bh=9rOow5YR01XEgjE7sYd/KU1U0PLZfqcgcSomdvBG8tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKSjoXnHlZCq7XUXA8yq9ZPp7hSJ4Wzplo1gGKHrKqTJ8UIZxMu5k3zGUOqNT/A4+D0SgriP3tBDS1d14lSVjsRMnpDq6kuDJNoWQfZBsLW/Ko4+wbbh0CBJV86deyNRLz0JiWdTpEVZrTQt3UKrVrIpYHAASbcn234ECqFry2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqAUbWv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqAUbWv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84482C4CEE3;
	Tue, 17 Jun 2025 15:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175271;
	bh=9rOow5YR01XEgjE7sYd/KU1U0PLZfqcgcSomdvBG8tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqAUbWv3IT9W6XnulSLMsL1Qos3ZExGcwsQbwa6KDamaDksOCg6YDIAEIZun8UnGc
	 w1KRY3nB72cuJtP4ftud0USOP/vQtFrLkzqPCt1BJ/LRevsepFEBEfQf/S4PFNzvcK
	 aXLNgfESfI2l7JIBVjOf83y81Hy750bknNNbohTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Kumar Bhaskar <skb99@linux.ibm.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/512] selftests/bpf: Fix bpf_nf selftest failure
Date: Tue, 17 Jun 2025 17:21:16 +0200
Message-ID: <20250617152424.048315608@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Saket Kumar Bhaskar <skb99@linux.ibm.com>

[ Upstream commit 967e8def1100cb4b08c28a54d27ce69563fdf281 ]

For systems with missing iptables-legacy tool this selftest fails.

Add check to find if iptables-legacy tool is available and skip the
test if the tool is missing.

Fixes: de9c8d848d90 ("selftests/bpf: S/iptables/iptables-legacy/ in the bpf_nf and xdp_synproxy test")
Signed-off-by: Saket Kumar Bhaskar <skb99@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250409095633.33653-1-skb99@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index a4a1f93878d40..fad98f01e2c06 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -63,6 +63,12 @@ static void test_bpf_nf_ct(int mode)
 		.repeat = 1,
 	);
 
+	if (SYS_NOFAIL("iptables-legacy --version")) {
+		fprintf(stdout, "Missing required iptables-legacy tool\n");
+		test__skip();
+		return;
+	}
+
 	skel = test_bpf_nf__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "test_bpf_nf__open_and_load"))
 		return;
-- 
2.39.5



