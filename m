Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5026F268FDD;
	Tue,  8 Apr 2025 12:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114586; cv=none; b=qGlYBPe1bwLX3PUK3zipWkL2tdHSgrGb2AGl+twZthTKe7EgcAhkYBpB7KiOjad/aZK51GcuxlqFdZdcecBYSE+S6hPs8tEWLXgTESpPyu9e1ywJ1LBgKzzU88Y2PMAdq9IqnHggdvKSK/dAxHlfd2Fnm9vCdmTXLwB7bPHVGvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114586; c=relaxed/simple;
	bh=IVUggruZ6A1nLkWdztjrwASHxFmBzp5Nr8ycy0jEmBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJ7n29nZ0VsAJ2NeCqBxyIpj6+6XkBxMdFv3KnU1G9cMQEbceESLtPt41NGvvzYUGd49lOTbYpauonnOVMs4649bR+kU0WqouXLTMtoJB7kbLpGz1+dbgx+CF+63LtTL4VWXZQ84gdidf123P9zeiYqcRGg0YEXdy6Okj8N2mV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPN48hX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPN48hX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E6FC4CEE5;
	Tue,  8 Apr 2025 12:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114586;
	bh=IVUggruZ6A1nLkWdztjrwASHxFmBzp5Nr8ycy0jEmBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPN48hX9FpvoIG7mHqhB1TA+0yx9n+jJOKxnuYU0s4N5/y0hqlWo2S+s8ntXs8/8E
	 m3n0Hg6kvacsF4gfOVfQQ1LGsa1mT8M0VcPVvIbFC7Qj1k7myHGZoopeSNLcny2jWc
	 SfmXiNRy094yBLZN4JS+Ibj6cRfxRVF1T9ibp1YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 160/499] selftests/bpf: Fix freplace_link segfault in tailcalls prog test
Date: Tue,  8 Apr 2025 12:46:12 +0200
Message-ID: <20250408104855.172276404@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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
index 544144620ca61..66a900327f912 100644
--- a/tools/testing/selftests/bpf/prog_tests/tailcalls.c
+++ b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
@@ -1600,6 +1600,7 @@ static void test_tailcall_bpf2bpf_freplace(void)
 		goto out;
 
 	err = bpf_link__destroy(freplace_link);
+	freplace_link = NULL;
 	if (!ASSERT_OK(err, "destroy link"))
 		goto out;
 
-- 
2.39.5



