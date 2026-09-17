Received: from smtp-42ac.mail.infomaniak.ch (smtp-42ac.mail.infomaniak.ch [84.16.66.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9890B4C10CB
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 15:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659222; cv=none; b=lTlD5gLisgtqvP78OiBpwcTsFM4UTaV4cFoIOdsx5HUt+Ym2oYBescJXNg/Cv3FigKLgsumxxe47ld++I/HHNIICRTqs4qKS2/0hQ67wUGDqotxTwUnP+T37yXyeyYJWt5Q/xBcnZ+rgCzyqbPo4bPBQkdWT2BVsbempOmQPpSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659222; c=relaxed/simple;
	bh=KFJQ/uSjcShOXNscotvt139qGqZQpZcaqH6lfk/Xgjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U/yEVMkjy7WVYlXCdwdG8QhQvb2yNhIvcOgZapVSg92f50J+Xz9TalhjlWoRTcehQ5qaFE8Kfev8a2/yFbN2e3MsEGwAQLtM9Zky145yvRhNvgRIYxDYxP1pk51pdPdutThhvCHmkiblVV7mbQBwbBD55sCKqVu3NEx4XXN3+e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=sFNBsd0D; arc=none smtp.client-ip=84.16.66.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="sFNBsd0D"
Received: from smtp-4-0001.mail.infomaniak.ch (unknown [IPv6:2001:1600:7:10::a6c])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4hm0CJ6SfszTqr;
	Thu, 17 Sep 2026 17:33:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1789659212;
	bh=tBQJawIEBEoBC+wUXarC7WW0FY8TT7tUAKKJiGJTm2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFNBsd0D2LWOKi3a+SmzvWSuGpovVUt+2Ens+x++Fq1X0u6khDNcZexM5OogvePOg
	 tSTBQGcpRrqD0B7Yb5LfFFI8Li36YbP1sQ6uQ/hBCH9AZIOTHapRc1IVf9pxRIH3/W
	 vgm9cxw/H85W9sMVmuxGhyJnfo19IGTu5R4pK8aU=
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4hm0CJ00yjzqBB;
	Thu, 17 Sep 2026 17:33:31 +0200 (CEST)
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: stable@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	Maximilian Heyne <mheyne@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12.y] selftests/landlock: Add missing connect(minimal AF_UNSPEC) test
Date: Thu, 17 Sep 2026 17:33:29 +0200
Message-ID: <d8432a4caf806783199dc5cde1dae2751719dda9.1789655724.git.mic@digikod.net>
In-Reply-To: <20260528194636.686963779@linuxfoundation.org>
References: <20260528194636.686963779@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

From: Matthieu Buffet <matthieu@buffet.re>

[ Upstream commit 6685201ebfacff0c889bcd569181fa6e8af5575e ]

connect_variant(unspec_any0) is called twice. Both calls end
up in connect_variant_addrlen() with an address length of
get_addrlen(minimal=false).
However, the connect() syscall and its variants (e.g.
iouring/compat) accept much shorter addresses of 4 bytes
and that behaviour was not tested.

Replace one of these calls with one using a minimal address
length (just a bare sa_family=AF_UNSPEC field with no actual
address). Also add a call using a truncated address for good
measure.

Signed-off-by: Matthieu Buffet <matthieu@buffet.re>
Link: https://lore.kernel.org/r/20251027190726.626244-3-matthieu@buffet.re
Signed-off-by: Mickaël Salaün <mic@digikod.net>
---
 tools/testing/selftests/landlock/net_test.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 897131bc8a13..d3cb27e24a16 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -905,7 +905,19 @@ TEST_F(protocol, connect_unspec)
 			EXPECT_EQ(0, close(ruleset_fd));
 		}
 
-		ret = connect_variant(connect_fd, &self->unspec_any0);
+		/* Try to re-disconnect with a truncated address struct. */
+		EXPECT_EQ(-EINVAL,
+			  connect_variant_addrlen(
+				  connect_fd, &self->unspec_any0,
+				  get_addrlen(&self->unspec_any0, true) - 1));
+
+		/*
+		 * Re-disconnect, with a minimal sockaddr struct (just a
+		 * bare af_family=AF_UNSPEC field).
+		 */
+		ret = connect_variant_addrlen(connect_fd, &self->unspec_any0,
+					      get_addrlen(&self->unspec_any0,
+							  true));
 		if (self->srv0.protocol.domain == AF_UNIX &&
 		    self->srv0.protocol.type == SOCK_STREAM) {
 			EXPECT_EQ(-EINVAL, ret);
