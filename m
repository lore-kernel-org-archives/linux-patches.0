Received: from smtp-8fa8.mail.infomaniak.ch (smtp-8fa8.mail.infomaniak.ch [83.166.143.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE6E517BCD
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660224; cv=none; b=seN89PJWoTjiIqs0WNC+ljhWQplWvcgwJTU2Yvx1dh6kWLKYIShX2bmlfMYhqUwvZJ8LcjNi0EJ61soMW9ZWF47IqAxdrLPSFEMzrWjsBP5PV/zbh6zmXLcTbRq6b4bipHpM8DBghgJ1QFyjjtQL6T59+2rdOrXK0rURRqUI52E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660224; c=relaxed/simple;
	bh=0xGBgAF7BCIlD0KdYkSVJyx8OisPzZzEoS/Q+xLb0GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=INV4YhWWMaU8Rq2SFqbsouRdHEbeNWQRCdQpu/JvrKxCDSmfFQDelREQuDTiKyVZ8jORAR97vpxJo4/eq7TlZdrC/TT7QfDWksi7BeGyL/8lpCLnnEofzbZSlkJETmFFDa7njf9dFMwPAHC7zYv3ULyBnZZBHWKZHX1raw48OCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=peRrMds1; arc=none smtp.client-ip=83.166.143.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="peRrMds1"
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4hm0N15y00zc4q;
	Thu, 17 Sep 2026 17:41:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1789659665;
	bh=5YwWrkoKljLgmIUyiKEg05p/vyQZJKURnyXkEje3oZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peRrMds1u1JoQaB41k+NB92VsFTlNgfcWe3LRhxj0mDio0yZTnDZa5y7Z4Vt7pAea
	 1/shiMjRxyQq4grYgUqK/PC0Z5HOnG68pDsoziEkG3aEUGtMJiWl3DgxLLF8Ff+gWE
	 +ZCBVR5l7X31vq90wsbfJCpd33ZnnQ1+A4b3duIU=
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4hm0N11r2vzCtr;
	Thu, 17 Sep 2026 17:41:05 +0200 (CEST)
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: stable@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18.y] selftests/landlock: Add missing connect(minimal AF_UNSPEC) test
Date: Thu, 17 Sep 2026 17:41:02 +0200
Message-ID: <a641bc74a52c6298aad01b5a57349a9a5a772016.1789655724.git.mic@digikod.net>
In-Reply-To: <20260121181421.332562395@linuxfoundation.org>
References: <20260121181421.332562395@linuxfoundation.org>
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
index 6fecd36f74c6..0c256e7c8675 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -906,7 +906,19 @@ TEST_F(protocol, connect_unspec)
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
