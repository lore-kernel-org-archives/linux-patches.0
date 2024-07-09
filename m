Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746EC15884A;
	Tue,  9 Jul 2024 11:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524178; cv=none; b=Km2c+qDl73Xkh+jVwjaK7/nQUArLvH5XGo2ZCRVelaJ/lK8kszNr6QtnZoaRPZShNFAoVMO2kgSm812ADSmmGAk/FxIq6Gw6NNnOVX5ZVwFI2jrAAZmBUJVAUcwfW+6FaYwBv+x0IVvU8XdHIGDzxeiv7/YvMlhk+2/BaOm54j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524178; c=relaxed/simple;
	bh=UtM16NeeFWvbbzecZYB1jEwqO4lo/A7Eh28aUwyBuo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPcR8u9BWRw7DlMDMXAfCtFKUZi4B7aQr/rhXcEyUlVnvgaJ2HzN40bjF6jDd/C+qzPU4bRwbx5OMqemkIC2BZT4H2LJ0mdJ6olcgB25IOFIeEHrQJ5YHuVtV9dlceySgT/QK02KORUym32lhWGXzJ6S3CztI5uY+C30doJAqYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJySObbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJySObbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00EFC3277B;
	Tue,  9 Jul 2024 11:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524178;
	bh=UtM16NeeFWvbbzecZYB1jEwqO4lo/A7Eh28aUwyBuo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJySObbTgNbaJxLmAOsilPMRhxH383MEksBFNfFNMblppIVhM5ytF34bZq/Culmnr
	 2zHhUid49J3OjxkjQD5FmVmq/zsrAgwUXEmLje9lPuQIOwjIZJDcJ2YsICovzsIGMu
	 mofg0ZQoLo9YWFjiaQI97tD+ALvZl9aTdBTYoANs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hubbard <jhubbard@nvidia.com>,
	Willem de Bruijn <willemb@google.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 065/197] selftests/net: fix uninitialized variables
Date: Tue,  9 Jul 2024 13:08:39 +0200
Message-ID: <20240709110711.478255285@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 353e1e867fbb2..6038b96ecee88 100644
--- a/tools/testing/selftests/net/gro.c
+++ b/tools/testing/selftests/net/gro.c
@@ -119,6 +119,9 @@ static void setup_sock_filter(int fd)
 		next_off = offsetof(struct ipv6hdr, nexthdr);
 	ipproto_off = ETH_HLEN + next_off;
 
+	/* Overridden later if exthdrs are used: */
+	opt_ipproto_off = ipproto_off;
+
 	if (strcmp(testname, "ip") == 0) {
 		if (proto == PF_INET)
 			optlen = sizeof(struct ip_timestamp);
diff --git a/tools/testing/selftests/net/ip_local_port_range.c b/tools/testing/selftests/net/ip_local_port_range.c
index 193b82745fd87..29451d2244b75 100644
--- a/tools/testing/selftests/net/ip_local_port_range.c
+++ b/tools/testing/selftests/net/ip_local_port_range.c
@@ -359,7 +359,7 @@ TEST_F(ip_local_port_range, late_bind)
 		struct sockaddr_in v4;
 		struct sockaddr_in6 v6;
 	} addr;
-	socklen_t addr_len;
+	socklen_t addr_len = 0;
 	const int one = 1;
 	int fd, err;
 	__u32 range;
diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
index 7426a2cbd4a03..7ad5a59adff2b 100644
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -1276,7 +1276,7 @@ int add_listener(int argc, char *argv[])
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



