Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F19D190664;
	Wed, 21 Jan 2026 18:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019608; cv=none; b=e4cBNrqku8EzzHXATYb8Ov8IDaRPYx2YwKX6pkD4mQ/m6DvxUm8osQ/jCgmodcISObVT4xLzjYMpbQeMK8f/zpXgcHxyfnMVzNwsUl0GiI4C4efl4PjODiIdlplWH9vxjv3d6sAfxgqLQcB03EHTDXFfe5JurLKB31PvE/5f3Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019608; c=relaxed/simple;
	bh=dgBVP81jMspHJfW3V/gKCWJNQ9cTIpdYeSAX70vTtCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t5Lty9MzNtHxrjoS/2JWhQ6SoZKnU4WH2K2ivyjpIkrWaNtUzN2PrSwaCYGO8jsvk8xd/In5SVGyNuMfwAdytSG5TmJLocTn1o5Qpk+nI58KuJ1n8Op9UoJR9EXpY4HW2GReHDh7kg9y7NT7fmV6t0wVSGbHfKn2N8kEKktQqBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqNsOykf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqNsOykf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CF0C16AAE;
	Wed, 21 Jan 2026 18:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019605;
	bh=dgBVP81jMspHJfW3V/gKCWJNQ9cTIpdYeSAX70vTtCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqNsOykfvTNk6UCr5x+czfB/wbpugVE32bDUG8xir6tcx5dRji0HR3Fy8b4flRDqt
	 qHDiTC9WWiWy7y01D95nNLQX47AYFtr8B8RzLaZzsdZOG9S3CtwO44aQBd1gBhLmwe
	 /FKU5JlbunuPu2T/D+VNxk/D2s/PEC5NfxZtfSNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/139] selftests/landlock: Fix TCP bind(AF_UNSPEC) test case
Date: Wed, 21 Jan 2026 19:15:01 +0100
Message-ID: <20260121181413.364648947@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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
index 60afc1ce11bcd..8be801c45f9b9 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -249,6 +249,7 @@ struct service_fixture {
 			struct sockaddr_un unix_addr;
 			socklen_t unix_addr_len;
 		};
+		struct sockaddr_storage _largest;
 	};
 };
 
diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 376079d70d3fc..c3642c17b251d 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -120,6 +120,10 @@ static socklen_t get_addrlen(const struct service_fixture *const srv,
 {
 	switch (srv->protocol.domain) {
 	case AF_UNSPEC:
+		if (minimal)
+			return sizeof(sa_family_t);
+		return sizeof(struct sockaddr_storage);
+
 	case AF_INET:
 		return sizeof(srv->ipv4_addr);
 
@@ -757,6 +761,11 @@ TEST_F(protocol, bind_unspec)
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
@@ -765,6 +774,8 @@ TEST_F(protocol, bind_unspec)
 			TH_LOG("Failed to bind to unspec/any socket: %s",
 			       strerror(errno));
 		}
+	} else if (variant->prot.domain == AF_INET6) {
+		EXPECT_EQ(-EAFNOSUPPORT, ret);
 	} else {
 		EXPECT_EQ(-EINVAL, ret);
 	}
@@ -791,6 +802,8 @@ TEST_F(protocol, bind_unspec)
 		} else {
 			EXPECT_EQ(0, ret);
 		}
+	} else if (variant->prot.domain == AF_INET6) {
+		EXPECT_EQ(-EAFNOSUPPORT, ret);
 	} else {
 		EXPECT_EQ(-EINVAL, ret);
 	}
@@ -800,7 +813,8 @@ TEST_F(protocol, bind_unspec)
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



