Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAD765192;
	Wed, 30 Sep 2026 17:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788130; cv=none; b=sS034GjKR8DnVbUJbIcKh31Os/K0vp/3fqW7O4XXCZ1YYRJypq1w1U+pOIjARCY4xFkMfXd0nYNK8IcoqrTRM7CkMPntp8PFWU20DbielsrwU4y2DLDiAxVdWJ2KTWXkW3cIxsh7NPDwt5TDhE1EgD5FT7CfqqA4U/mYQ9KQMSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788130; c=relaxed/simple;
	bh=FPAwjdSMnIRdsjgltACNCAJ0LMzNJmZ70X3wadOmWek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZN6B+DRnBvr9dxItmYkHrxT+h2kglY5RKfeu8gU1Q5R9Sr17AKVSjVthnZsh7YRQQOlr6yM6P7OC9wDpFuywXMWtSBefMtmzY8N7Gw3VCaQ6AvJu90rKaA7dFA9DFoJ5bF5n7jmQFfd2NgkvTKZvedJ17vcKovEEU1J2EixL+8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GymxPYW8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GymxPYW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F911F000FF;
	Wed, 30 Sep 2026 17:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788128;
	bh=vmjabj4ciJXJTDwLs0dd/yZADKF/gNhqK5j2xhKdYtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GymxPYW8xXiha58osR024MVko3LivSFjMuR1SlE4W/N9wuUzazzf1k/Vy3Cj3uXYL
	 nwyWn9b1ME6AJvfxqvV3qUGx9aIsaf52YpfmS+kPEFcr7D7MO3pGAtiNmvfmD2hLtW
	 dz1uBORGdMGdhR86eqKR+dlFXkAaBZt0HalDJBTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/877] selftests/landlock: Add missing connect(minimal AF_UNSPEC) test
Date: Wed, 30 Sep 2026 17:15:16 +0200
Message-ID: <20260930152414.863061212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/net_test.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 63b1e655afb25..0be69fcc4efbe 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -963,7 +963,19 @@ TEST_F(protocol, connect_unspec)
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
-- 
2.53.0



