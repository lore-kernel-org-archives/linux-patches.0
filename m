Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D293D2D879A;
	Tue, 11 Nov 2025 01:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823193; cv=none; b=b3zq8MID3CIwtTkG5oXU2EBXw77fnyYj2F9dOSFFjSu2NrCgQbKV8sT3k+g7zCF6EWSNCylQhEmPP1zSKCHDlZ02eXM85+qTT86zUkVc6u/t5jCVDFrMmCuUKoCw0Ja9pSiV5xm5ty82uOQJgIRqcXF7n+xGum1HviITjw5v5zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823193; c=relaxed/simple;
	bh=voQhRfFPXt3SsmLXIqXB5IqEs34bHpvuf/8HNvAR7eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODWGozUXjYMHzbZVKd1M+prJ7+Wjq0cFMlxMmHd07lEYmM1yVSFEYnH+OemspoW22kck8gmnv5RvyuzeKmKLnz0g4rdciRvN5YT9CCA2oN5ehczQj4S5M8xQoM/jIEHTpmMtBG5gbaKsBn/twZcFlwpN6ji1MpDkeYyW1+AuNUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlqxx9YO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlqxx9YO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688CDC2BC87;
	Tue, 11 Nov 2025 01:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823193;
	bh=voQhRfFPXt3SsmLXIqXB5IqEs34bHpvuf/8HNvAR7eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlqxx9YOwBdhKj2simEqAvi3iftkrBFIZHc/MYn3ypCH0UcN3qK27jAnP5u5I5lDQ
	 eERSyQGZgx4+eGx37HCh8oObYsWT8gLIgwtSbhdQu3paONktDDC5ECyhJbHgWHfcFl
	 B9YLcfvhyuYAQzmKVYWDvuPEVroCRf9Xn/AXc/Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wake Liu <wakel@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/565] selftests/net: Ensure assert() triggers in psock_tpacket.c
Date: Tue, 11 Nov 2025 09:40:50 +0900
Message-ID: <20251111004531.292873529@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wake Liu <wakel@google.com>

[ Upstream commit bc4c0a48bdad7f225740b8e750fdc1da6d85e1eb ]

The get_next_frame() function in psock_tpacket.c was missing a return
statement in its default switch case, leading to a compiler warning.

This was caused by a `bug_on(1)` call, which is defined as an
`assert()`, being compiled out because NDEBUG is defined during the
build.

Instead of adding a `return NULL;` which would silently hide the error
and could lead to crashes later, this change restores the original
author's intent. By adding `#undef NDEBUG` before including <assert.h>,
we ensure the assertion is active and will cause the test to abort if
this unreachable code is ever executed.

Signed-off-by: Wake Liu <wakel@google.com>
Link: https://patch.msgid.link/20250809062013.2407822-1-wakel@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/psock_tpacket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/psock_tpacket.c b/tools/testing/selftests/net/psock_tpacket.c
index 93092d13b3c59..ca0d9a5a9e08c 100644
--- a/tools/testing/selftests/net/psock_tpacket.c
+++ b/tools/testing/selftests/net/psock_tpacket.c
@@ -22,6 +22,7 @@
  *   - TPACKET_V3: RX_RING
  */
 
+#undef NDEBUG
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/types.h>
-- 
2.51.0



