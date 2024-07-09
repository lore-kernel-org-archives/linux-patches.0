Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE02157A72;
	Tue,  9 Jul 2024 11:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523620; cv=none; b=OuRhR/ZN2m0IVjhraoqrAH+qiWazXFKdRW+sdhmR1Q/u1ubPRxh/gxpbccbVrLthnW35Ob4ecADYNXnceVCFEziyOUJ/XJGFy71/3EYouaMxzLxe4Rf3Tz+qTstoc9aekxmZDe4Wj42KOrxiOBRIxtCJ4rd2n9qve0dLhI8etHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523620; c=relaxed/simple;
	bh=ubDpJNJDlCKp66vZwKvhZl3l/UOq/E3GWl138kw8Xm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOoz1LUPf2A6zjlqep43kyvmC/mbEgHEaowdKQSep0fJ9hYJeXSJbdC+0+dEhS2J3L50FBoDTZAwFIoOSdBTLtde0PlC0NFrxZo6HQLvn3AhRMC/2ewFbhoUYAnerZ9EgHgUXpoEmHmQAKdclHLIu/QB5Snc7NS2ONyXnTXwoc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTUH/u6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTUH/u6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6367AC3277B;
	Tue,  9 Jul 2024 11:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523619;
	bh=ubDpJNJDlCKp66vZwKvhZl3l/UOq/E3GWl138kw8Xm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTUH/u6O01wyGwRcx1Rsr20mfBm6aZRfGvqYOhwex4SwDoyDAVzTv1lwtw35olUcg
	 UGHjPFKVY259Q3+UGoWgZIacxCujMg/61N94S9GIWco6HlIXhkYnN9npmBrp6Zou3c
	 541gTRsUCt8YZ/vlLOuWYcJRyjhZCmfKMvWGs5kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hubbard <jhubbard@nvidia.com>,
	Willem de Bruijn <willemb@google.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/139] selftests/net: fix uninitialized variables
Date: Tue,  9 Jul 2024 13:09:06 +0200
Message-ID: <20240709110659.948165869@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: John Hubbard <jhubbard@nvidia.com>

[ Upstream commit eb709b5f6536636dfb87b85ded0b2af9bb6cd9e6 ]

When building with clang, via:

    make LLVM=1 -C tools/testing/selftest

...clang warns about three variables that are not initialized in all
cases:

1) The opt_ipproto_off variable is used uninitialized if "testname" is
not "ip". Willem de Bruijn pointed out that this is an actual bug, and
suggested the fix that I'm using here (thanks!).

2) The addr_len is used uninitialized, but only in the assert case,
   which bails out, so this is harmless.

3) The family variable in add_listener() is only used uninitialized in
   the error case (neither IPv4 nor IPv6 is specified), so it's also
   harmless.

Fix by initializing each variable.

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20240506190204.28497-1-jhubbard@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/gro.c                 | 3 +++
 tools/testing/selftests/net/ip_local_port_range.c | 2 +-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c     | 2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/gro.c b/tools/testing/selftests/net/gro.c
index 30024d0ed3739..b204df4f33322 100644
--- a/tools/testing/selftests/net/gro.c
+++ b/tools/testing/selftests/net/gro.c
@@ -113,6 +113,9 @@ static void setup_sock_filter(int fd)
 		next_off = offsetof(struct ipv6hdr, nexthdr);
 	ipproto_off = ETH_HLEN + next_off;
 
+	/* Overridden later if exthdrs are used: */
+	opt_ipproto_off = ipproto_off;
+
 	if (strcmp(testname, "ip") == 0) {
 		if (proto == PF_INET)
 			optlen = sizeof(struct ip_timestamp);
diff --git a/tools/testing/selftests/net/ip_local_port_range.c b/tools/testing/selftests/net/ip_local_port_range.c
index 75e3fdacdf735..2465ff5bb3a8e 100644
--- a/tools/testing/selftests/net/ip_local_port_range.c
+++ b/tools/testing/selftests/net/ip_local_port_range.c
@@ -343,7 +343,7 @@ TEST_F(ip_local_port_range, late_bind)
 		struct sockaddr_in v4;
 		struct sockaddr_in6 v6;
 	} addr;
-	socklen_t addr_len;
+	socklen_t addr_len = 0;
 	const int one = 1;
 	int fd, err;
 	__u32 range;
diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
index 49369c4a5f261..763402dd17742 100644
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -1239,7 +1239,7 @@ int add_listener(int argc, char *argv[])
 	struct sockaddr_storage addr;
 	struct sockaddr_in6 *a6;
 	struct sockaddr_in *a4;
-	u_int16_t family;
+	u_int16_t family = AF_UNSPEC;
 	int enable = 1;
 	int sock;
 	int err;
-- 
2.43.0



