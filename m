Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7684338BDC7;
	Wed, 21 Jan 2026 18:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020162; cv=none; b=Nx4QfgsqWWEoqGi0g9NOCu3mbm9/HLC/HlLb1cvbAoQO9urfM4UoKbqUEBl7L5EpdwdE+TfOjP/wmqcYR6NeaTP0TFS7Nt9+jlPv5Lz3yRpFGxPcXGTc5X3irokiOtSZpgtjA6KEGEjCjezVNVdLqJi+jBXcnOLV0+MCTyPdGGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020162; c=relaxed/simple;
	bh=7FbIQme6q6ScOtzodtsgcMDHw6aI/lg/oM9zd+ZPT9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E3rXTyBX8CX+CzuYmSlXSl/JNNr9edR8CCtPxAoz8/pWFF30MoOzLM2EJXteC0fTXBvjchJNacyX8bHR7gfwgj/P22oFzA3khouathosjycwNUrorDnt3K0AwYbW1ui0WQr2jVAQYRmwIEStW5pUOYqm/Nfmo4ylYipFLifHVxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7LnGto1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7LnGto1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C679CC4CEF1;
	Wed, 21 Jan 2026 18:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020162;
	bh=7FbIQme6q6ScOtzodtsgcMDHw6aI/lg/oM9zd+ZPT9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7LnGto10EUy6HbePhxeHFnVJW5Si5cngIOCpYQFhY0q8NYGWZkEf2+X8jQxou0Be
	 Bm0+IhcUasGyllEVNwyWOC7G9uTm1Ol+FLXTJi+fPHpNhUeum/f7xLH+5i1GTzyoEL
	 gWxns7NL4UH9fKHjxuJFMD1hIAAEyYYl3oJ6Qnnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/198] selftests/landlock: Fix TCP bind(AF_UNSPEC) test case
Date: Wed, 21 Jan 2026 19:15:06 +0100
Message-ID: <20260121181421.368283851@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Buffet <matthieu@buffet.re>

[ Upstream commit bd09d9a05cf04028f639e209b416bacaeffd4909 ]

The nominal error code for bind(AF_UNSPEC) on an IPv6 socket
is -EAFNOSUPPORT, not -EINVAL. -EINVAL is only returned when
the supplied address struct is too short, which happens to be
the case in current selftests because they treat AF_UNSPEC
like IPv4 sockets do: as an alias for AF_INET (which is a
16-byte struct instead of the 24 bytes required by IPv6
sockets).

Make the union large enough for any address (by adding struct
sockaddr_storage to the union), and make AF_UNSPEC addresses
large enough for any family.

Test for -EAFNOSUPPORT instead, and add a dedicated test case
for truncated inputs with -EINVAL.

Fixes: a549d055a22e ("selftests/landlock: Add network tests")
Signed-off-by: Matthieu Buffet <matthieu@buffet.re>
Link: https://lore.kernel.org/r/20251027190726.626244-2-matthieu@buffet.re
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/common.h   |  1 +
 tools/testing/selftests/landlock/net_test.c | 16 +++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
index 9acecae36f51b..98c2362954e21 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -237,6 +237,7 @@ struct service_fixture {
 			struct sockaddr_un unix_addr;
 			socklen_t unix_addr_len;
 		};
+		struct sockaddr_storage _largest;
 	};
 };
 
diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 2a45208551e61..3bbc0508420b1 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -121,6 +121,10 @@ static socklen_t get_addrlen(const struct service_fixture *const srv,
 {
 	switch (srv->protocol.domain) {
 	case AF_UNSPEC:
+		if (minimal)
+			return sizeof(sa_family_t);
+		return sizeof(struct sockaddr_storage);
+
 	case AF_INET:
 		return sizeof(srv->ipv4_addr);
 
@@ -758,6 +762,11 @@ TEST_F(protocol, bind_unspec)
 	bind_fd = socket_variant(&self->srv0);
 	ASSERT_LE(0, bind_fd);
 
+	/* Tries to bind with too small addrlen. */
+	EXPECT_EQ(-EINVAL, bind_variant_addrlen(
+				   bind_fd, &self->unspec_any0,
+				   get_addrlen(&self->unspec_any0, true) - 1));
+
 	/* Allowed bind on AF_UNSPEC/INADDR_ANY. */
 	ret = bind_variant(bind_fd, &self->unspec_any0);
 	if (variant->prot.domain == AF_INET) {
@@ -766,6 +775,8 @@ TEST_F(protocol, bind_unspec)
 			TH_LOG("Failed to bind to unspec/any socket: %s",
 			       strerror(errno));
 		}
+	} else if (variant->prot.domain == AF_INET6) {
+		EXPECT_EQ(-EAFNOSUPPORT, ret);
 	} else {
 		EXPECT_EQ(-EINVAL, ret);
 	}
@@ -792,6 +803,8 @@ TEST_F(protocol, bind_unspec)
 		} else {
 			EXPECT_EQ(0, ret);
 		}
+	} else if (variant->prot.domain == AF_INET6) {
+		EXPECT_EQ(-EAFNOSUPPORT, ret);
 	} else {
 		EXPECT_EQ(-EINVAL, ret);
 	}
@@ -801,7 +814,8 @@ TEST_F(protocol, bind_unspec)
 	bind_fd = socket_variant(&self->srv0);
 	ASSERT_LE(0, bind_fd);
 	ret = bind_variant(bind_fd, &self->unspec_srv0);
-	if (variant->prot.domain == AF_INET) {
+	if (variant->prot.domain == AF_INET ||
+	    variant->prot.domain == AF_INET6) {
 		EXPECT_EQ(-EAFNOSUPPORT, ret);
 	} else {
 		EXPECT_EQ(-EINVAL, ret)
-- 
2.51.0



