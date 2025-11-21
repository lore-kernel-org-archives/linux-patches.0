Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53653348477;
	Fri, 21 Nov 2025 13:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733481; cv=none; b=ZeVzXAL6ht5buzp+jYj6rZ10NnscisrG9Z/SVLSdMYrtWTZZ/EhY1nv+0sp6W0YHxJvvFovzZrV4EvTdoSE1QrarCRep/ldPg6FUd49nHgzdwZr0kHNtFOzkx6cSVHiYZBXuJlwwtW/hlF3AJnRtKtiYgDVG5vsnjZyxytqWVwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733481; c=relaxed/simple;
	bh=tDfFMaN8YzZtGGkm99bcCdUtnyi6OlIJnkUK0Lpr4fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4VWXUjJyOPPePckMArFVVppLfBeCueDDx3XmTwNFI3hPYHDwZbTCqvcWite0MvxBRlgS0omDrznIdbgiPdCfXZo6Ls4Xvu86wXC4OR22yX+brJGps2S0HfC/w3mU6bInrQj50cDcjUgyhLTyeGYCMBCZhbyEEZvmir/7twcuKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOPU4LSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOPU4LSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5042C4CEF1;
	Fri, 21 Nov 2025 13:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733480;
	bh=tDfFMaN8YzZtGGkm99bcCdUtnyi6OlIJnkUK0Lpr4fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wOPU4LSdDAIsBdc/ccKkiqWNY5uWrqM8XNL5oupMmE4rZWyRLXlys0mARzRcUIiHW
	 bvHJHIQVfaKanOfGCA8F+jPracNwNs6elBLkkA4Bug+hvANjeQaEv4bzPGYY7q6LDq
	 mad/O0Gkl7U1qLKXV1heCymCV6trYTLjSa3fRHAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>,
	Beau Belgrave <beaub@linux.microsoft.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	sunliming <sunliming@kylinos.cn>,
	Wei Yang <richard.weiyang@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 482/529] selftests/user_events: fix type cast for write_index packed member in perf_test
Date: Fri, 21 Nov 2025 14:13:01 +0100
Message-ID: <20251121130248.158508128@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>

commit 216158f063fe24fb003bd7da0cd92cd6e2c4d48b upstream.

Accessing 'reg.write_index' directly triggers a -Waddress-of-packed-member
warning due to potential unaligned pointer access:

perf_test.c:239:38: warning: taking address of packed member 'write_index'
of class or structure 'user_reg' may result in an unaligned pointer value
[-Waddress-of-packed-member]
  239 |         ASSERT_NE(-1, write(self->data_fd, &reg.write_index,
      |                                             ^~~~~~~~~~~~~~~

Since write(2) works with any alignment. Casting '&reg.write_index'
explicitly to 'void *' to suppress this warning.

Link: https://lkml.kernel.org/r/20251106095532.15185-1-ankitkhushwaha.linux@gmail.com
Fixes: 42187bdc3ca4 ("selftests/user_events: Add perf self-test for empty arguments events")
Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Cc: Beau Belgrave <beaub@linux.microsoft.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: sunliming <sunliming@kylinos.cn>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/user_events/perf_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/user_events/perf_test.c b/tools/testing/selftests/user_events/perf_test.c
index 5288e768b207..68625362add2 100644
--- a/tools/testing/selftests/user_events/perf_test.c
+++ b/tools/testing/selftests/user_events/perf_test.c
@@ -236,7 +236,7 @@ TEST_F(user, perf_empty_events) {
 	ASSERT_EQ(1 << reg.enable_bit, self->check);
 
 	/* Ensure write shows up at correct offset */
-	ASSERT_NE(-1, write(self->data_fd, &reg.write_index,
+	ASSERT_NE(-1, write(self->data_fd, (void *)&reg.write_index,
 					sizeof(reg.write_index)));
 	val = (void *)(((char *)perf_page) + perf_page->data_offset);
 	ASSERT_EQ(PERF_RECORD_SAMPLE, *val);
-- 
2.52.0



