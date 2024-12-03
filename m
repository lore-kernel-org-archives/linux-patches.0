Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6191F8AEF;
	Tue,  3 Dec 2024 15:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240738; cv=none; b=DmJuYUUTSmqQAA1/SivhedVEzrDXeIUk11zlrBPvPJ0YiOSY5tXRy4Ao0cIXSauljCqwrAT3aw9cMzt1y5e4EsN1KowfVk1VnIOQVAodZZmis4Ch0Uc82U+7IC3mWyRslVx7Q7NX8I3l2xMR4Dwken90MFj6YJ5vObYb2P+1FIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240738; c=relaxed/simple;
	bh=sibBjDl2k/e07GGTXMAHkkKVjgAVVSiFhzOskMSD6WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UCOlI6R/Ps5kKqi+w7W3/Slqo2AUwx+SLr0fi0BNF+JHZE1ZvRmP8dYxVqi5m6mcKqeWUMXojW42IlS0YL/6AS+zMFAv5dP98ka9eUgmnc+4GeTPUOxi6cV9V/XMxuyRatPsmGzN7JJoKRa14iBA67/dtUAXLTlngNQrHqdaQxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJIveJ2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJIveJ2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AC3C4CECF;
	Tue,  3 Dec 2024 15:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240738;
	bh=sibBjDl2k/e07GGTXMAHkkKVjgAVVSiFhzOskMSD6WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJIveJ2pUA6Ory2mXb2KRlT3/jd+DHjY2Sc+abSF4ap6NUf8IbgjtM05hTlUiwRQM
	 r7LBGO3TghOoc0MhIUyzCFLSrgRUAaF8hrfoQjy/eTVg1lQFHEoQ7UXaRw1qtXIE1O
	 5eKUHAwPB0OY3qAStE6HkD3+avYmb0JdaWkXp2YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <alan.maguire@oracle.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 221/826] selftests/bpf: Fix uprobe_multi compilation error
Date: Tue,  3 Dec 2024 15:39:08 +0100
Message-ID: <20241203144752.362144939@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit c27d8235ba97139d7a085367ff57773902eb3fc5 ]

When building selftests, the following was seen:

uprobe_multi.c: In function ‘trigger_uprobe’:
uprobe_multi.c:108:40: error: ‘MADV_PAGEOUT’ undeclared (first use in this function)
  108 |                 madvise(addr, page_sz, MADV_PAGEOUT);
      |                                        ^~~~~~~~~~~~
uprobe_multi.c:108:40: note: each undeclared identifier is reported only once for each function it appears in
make: *** [Makefile:850: bpf-next/tools/testing/selftests/bpf/uprobe_multi] Error 1

...even with updated UAPI headers. It seems the above value is
defined in UAPI <linux/mman.h> but including that file triggers
other redefinition errors.  Simplest solution is to add a
guarded definition, as was done for MADV_POPULATE_READ.

Fixes: 3c217a182018 ("selftests/bpf: add build ID tests")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20240926144948.172090-1-alan.maguire@oracle.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/uprobe_multi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/uprobe_multi.c b/tools/testing/selftests/bpf/uprobe_multi.c
index c7828b13e5ffd..dd38dc68f6359 100644
--- a/tools/testing/selftests/bpf/uprobe_multi.c
+++ b/tools/testing/selftests/bpf/uprobe_multi.c
@@ -12,6 +12,10 @@
 #define MADV_POPULATE_READ 22
 #endif
 
+#ifndef MADV_PAGEOUT
+#define MADV_PAGEOUT 21
+#endif
+
 int __attribute__((weak)) uprobe(void)
 {
 	return 0;
-- 
2.43.0



