Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C810C350A39;
	Tue, 21 Oct 2025 19:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076549; cv=none; b=kM/DNBHSW2f25MrhIcynEdDLCAXfH+pDSGSNBz8eN1VFhn/eCsdFl1DA0R5OuktypWfBXi4guQb7eQNreOC2iEBT1+gQEHEEPOW8I/4FRvecLD77eiwYGBL8xGGen7bJ5X/Vb5+K7KmUc5k5cDCIALp7UJD25ZSqikI2EHgHQHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076549; c=relaxed/simple;
	bh=LXsEFORcaMoseHLv3Yaz+qolnAk0GXJK+ITtBjqe+7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xk2JnF4CiYDVWqo1xWwDM31mrxndH5pAcjcrZVWg1GX4LqCSVUgaRPmNNVIJO7zaPwfaOeEjX/ZK24a21tkLvT25/Ldfq3Ay+5WwUP/32i3YQzNKHMuoHghankzPcSa/YJ6cBxIwRN+XWGuSdXadda4ip81R/VVJOW4vYINQrqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1QLmbFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1QLmbFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5B5C4CEF1;
	Tue, 21 Oct 2025 19:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076549;
	bh=LXsEFORcaMoseHLv3Yaz+qolnAk0GXJK+ITtBjqe+7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1QLmbFG2E+ZL0AiT4hEbXGGZzy2O5xbotYhPg2fRMkckVQNjmyPY/RguG3MyU46a
	 d+okXTPqQzDlZHjPmhN1w/eRRB+tESFC3GnoxJbm2Hv6zv1CbM+LDx+NGbFXBgSgJa
	 LkvRjbHODV9229NZr9/AUY139p57FFgPWMZuz3qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xing Guo <higuoxing@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/105] selftests: arg_parsing: Ensure data is flushed to disk before reading.
Date: Tue, 21 Oct 2025 21:51:19 +0200
Message-ID: <20251021195023.324951801@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



