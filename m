Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72D72505BD;
	Wed,  5 Mar 2025 18:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198752; cv=none; b=EML9ti/CsvpNpPgbQqVALqIYhSfwxp3FlTcwRFIkQ8P52RUVlYl89WHr3X89lt0menOR7mFU94wg7IgPvz8m6fpCUE+zzkjKb+0byKUqHoCQMlzFC5is1oMIUv6kjM/6udKR50Ju85rcmnEh2pKebhnD6FVYAdp4X45eQH3mSRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198752; c=relaxed/simple;
	bh=VUNx+0OUbIWmj5XqMxKYByKyn2ZBTYRXILPJ2PewlSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2NUVQ2mi4c+wQMuZN+XIgjHMFnNyaVkQQHneKdleS30voR7S4TGyO5w3NRNmclacmUiCtECWqREPODHViNePthwVQpw5vdUlKVBb3ki3r8em7shRFbWsYg/2OVB7p0NDBuD42w943WwTLHFI+soSRpaDqsEeO9/lORqkk3TDIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6B8wBrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6B8wBrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B1BC4CED1;
	Wed,  5 Mar 2025 18:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198751;
	bh=VUNx+0OUbIWmj5XqMxKYByKyn2ZBTYRXILPJ2PewlSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6B8wBrwSOa2OqGcE+eAeI+XfMJpBrUXgqchiVJNUIjICcs+MsXSAiYAF59imiHlY
	 4bby4GqxkMSP6vyr9hi4iqLOvftojrPemj7l538XH8rW8biPNqKYGFYg1ksV+eSiti
	 phQHTNbU+jBjmbP4hjo93CTcjpxvvh1eDwaX+FDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.13 136/157] selftests/landlock: Test TCP accesses with protocol=IPPROTO_TCP
Date: Wed,  5 Mar 2025 18:49:32 +0100
Message-ID: <20250305174510.767293715@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>

commit f5534d511bcd273720f168386de74af76e148a9b upstream.

Extend protocol_variant structure with protocol field (Cf. socket(2)).

Extend protocol fixture with TCP test suits with protocol=IPPROTO_TCP
which can be used as an alias for IPPROTO_IP (=0) in socket(2).

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Link: https://lore.kernel.org/r/20250205093651.1424339-3-ivanov.mikhail1@huawei-partners.com
Cc: <stable@vger.kernel.org> # 6.7.x
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/common.h   |    1 
 tools/testing/selftests/landlock/net_test.c |   80 +++++++++++++++++++++++-----
 2 files changed, 67 insertions(+), 14 deletions(-)

--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -234,6 +234,7 @@ enforce_ruleset(struct __test_metadata *
 struct protocol_variant {
 	int domain;
 	int type;
+	int protocol;
 };
 
 struct service_fixture {
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -85,18 +85,18 @@ static void setup_loopback(struct __test
 	clear_ambient_cap(_metadata, CAP_NET_ADMIN);
 }
 
+static bool prot_is_tcp(const struct protocol_variant *const prot)
+{
+	return (prot->domain == AF_INET || prot->domain == AF_INET6) &&
+	       prot->type == SOCK_STREAM &&
+	       (prot->protocol == IPPROTO_TCP || prot->protocol == IPPROTO_IP);
+}
+
 static bool is_restricted(const struct protocol_variant *const prot,
 			  const enum sandbox_type sandbox)
 {
-	switch (prot->domain) {
-	case AF_INET:
-	case AF_INET6:
-		switch (prot->type) {
-		case SOCK_STREAM:
-			return sandbox == TCP_SANDBOX;
-		}
-		break;
-	}
+	if (sandbox == TCP_SANDBOX)
+		return prot_is_tcp(prot);
 	return false;
 }
 
@@ -105,7 +105,7 @@ static int socket_variant(const struct s
 	int ret;
 
 	ret = socket(srv->protocol.domain, srv->protocol.type | SOCK_CLOEXEC,
-		     0);
+		     srv->protocol.protocol);
 	if (ret < 0)
 		return -errno;
 	return ret;
@@ -290,22 +290,48 @@ FIXTURE_TEARDOWN(protocol)
 }
 
 /* clang-format off */
-FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_tcp) {
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_tcp1) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		/* IPPROTO_IP == 0 */
+		.protocol = IPPROTO_IP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_tcp2) {
 	/* clang-format on */
 	.sandbox = NO_SANDBOX,
 	.prot = {
 		.domain = AF_INET,
 		.type = SOCK_STREAM,
+		.protocol = IPPROTO_TCP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp1) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		/* IPPROTO_IP == 0 */
+		.protocol = IPPROTO_IP,
 	},
 };
 
 /* clang-format off */
-FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp) {
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp2) {
 	/* clang-format on */
 	.sandbox = NO_SANDBOX,
 	.prot = {
 		.domain = AF_INET6,
 		.type = SOCK_STREAM,
+		.protocol = IPPROTO_TCP,
 	},
 };
 
@@ -372,22 +398,48 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox
 };
 
 /* clang-format off */
-FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_tcp) {
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_tcp1) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		/* IPPROTO_IP == 0 */
+		.protocol = IPPROTO_IP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_tcp2) {
 	/* clang-format on */
 	.sandbox = TCP_SANDBOX,
 	.prot = {
 		.domain = AF_INET,
 		.type = SOCK_STREAM,
+		.protocol = IPPROTO_TCP,
+	},
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp1) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		/* IPPROTO_IP == 0 */
+		.protocol = IPPROTO_IP,
 	},
 };
 
 /* clang-format off */
-FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp) {
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp2) {
 	/* clang-format on */
 	.sandbox = TCP_SANDBOX,
 	.prot = {
 		.domain = AF_INET6,
 		.type = SOCK_STREAM,
+		.protocol = IPPROTO_TCP,
 	},
 };
 


