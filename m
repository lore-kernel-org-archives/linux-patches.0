Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09C441F7CC;
	Thu, 16 Jul 2026 14:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211485; cv=none; b=u3VuNI3iv8HyxJbaqG+ALD4MPfmQ9drobDmpPAf4eanBY7JM3PAJSgZNc2uaFGGzjw7Kt6Z99nkdcpjpCdasBmmH92r9SsZ0VuTYvIfTdi4F/+cbYBdy89pnNoM96zV4JXDxJ099sD+BJo70rl66fic0Vp9EavJPopDt+vjwoAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211485; c=relaxed/simple;
	bh=+AV2d+WvO5LyJylKgf7qOMt6FCzjIYzuHBJuu4Zz4hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omSK21HTUrfELMtC0135ZJQRZ0PFtheYzh1L5sn1Os6P50vF91d8FLTMA5ADhBajBlgU5vijKk/X+6EQ2n7cUcte8sd+aZLz5Csi3X3BpM+X4Y/hHqJKEWuSXXc4/KzbY82ZyiuFufxedLBEEWxBHjVp20YCkO5yHev0oKGNQv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMoFIHwd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMoFIHwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E161F000E9;
	Thu, 16 Jul 2026 14:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211482;
	bh=L7ug+/Qs8aF+1sqFMuq9VbMSRsy1pJvXQM5UxTjNkD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZMoFIHwdxGygH+WxtkUuX3vLLI7snygxX3HnzfPJupH/aqnn1S3abYMU3b43ex+YV
	 QHQLknRh/uystlRYWdylgFNl2r5RVTQY2kI+BS+qkZSZz8lbhLvACWeMU6amOgkL6z
	 wbg8z+PxMfV8RChBOrStwQgywAnmfBS9EF4/0qq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Tingmao Wang <m@maowtm.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.18 418/480] landlock: Set audit_net.sk for socket access checks
Date: Thu, 16 Jul 2026 15:32:45 +0200
Message-ID: <20260716133053.857639692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Mickaël Salaün <mic@digikod.net>

commit d936e1a9170f9cadaa5f37586b1dfe6f20f98799 upstream.

Set audit_net.sk in current_check_access_socket() to provide the socket
object to audit_log_lsm_data().  This makes Landlock consistent with
AppArmor, which always sets .sk for socket operations, and with
SELinux's generic socket permission checks.

The socket's local and foreign address information (laddr, lport, faddr,
fport) is logged by the shared lsm_audit.c infrastructure when the
socket has bound or connected state.  Fields with zero values are
suppressed by print_ipv4_addr()/print_ipv6_addr(), so the audit output
is unchanged for the common case of bind denials on unbound sockets.
For connect denials after a prior bind, the bound local address (laddr,
lport) appears before the existing sockaddr fields (daddr, dest).

No existing fields are removed or reordered, and the new field names
(laddr, lport, faddr, fport) are standard audit fields already emitted
by other LSMs through the same lsm_audit.c code path.

Add a connect_tcp_bound audit test that binds to an allowed port and
then connects to a denied one, verifying that the denial record reports
laddr/lport from the bound socket in addition to the connect
destination.

Cc: Günther Noack <gnoack@google.com>
Cc: Tingmao Wang <m@maowtm.org>
Cc: stable@vger.kernel.org
Fixes: 9f74411a40ce ("landlock: Log TCP bind and connect denials")
Link: https://patch.msgid.link/20260612172757.1003481-1-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/net.c                     |    1 
 tools/testing/selftests/landlock/net_test.c |   62 ++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -199,6 +199,7 @@ static int current_check_access_socket(s
 		return 0;
 
 	audit_net.family = address->sa_family;
+	audit_net.sk = sock->sk;
 	landlock_log_denial(subject,
 			    &(struct landlock_request){
 				    .type = LANDLOCK_REQUEST_NET_ACCESS,
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -2014,4 +2014,66 @@ TEST_F(audit, connect)
 	EXPECT_EQ(0, close(sock_fd));
 }
 
+static int matches_log_tcp_bound(int audit_fd, const char *const addr,
+				 __u16 lport, __u16 dport)
+{
+	static const char log_template[] = REGEX_LANDLOCK_PREFIX
+		" blockers=net\\.connect_tcp laddr=%s lport=%u daddr=%s dest=%u$";
+	/* Slack for two addresses and two port numbers. */
+	char log_match[sizeof(log_template) + 40];
+	int log_match_len;
+
+	log_match_len = snprintf(log_match, sizeof(log_match), log_template,
+				 addr, lport, addr, dport);
+	if (log_match_len > sizeof(log_match))
+		return -E2BIG;
+
+	return audit_match_record(audit_fd, AUDIT_LANDLOCK_ACCESS, log_match,
+				  NULL);
+}
+
+/*
+ * After a bind() to an allowed port, a denied connect must report laddr/lport
+ * from the bound socket (made available through audit_net.sk) in addition to
+ * the connect sockaddr's daddr/dest.
+ */
+TEST_F(audit, connect_tcp_bound)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
+				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
+	};
+	const struct landlock_net_port_attr rule_bind = {
+		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+		.port = self->srv0.port,
+	};
+	struct service_fixture srv_remote;
+	struct audit_records records;
+	int ruleset_fd, sock_fd;
+
+	/* Uses a second port as the denied connect target. */
+	ASSERT_EQ(0, set_service(&srv_remote, variant->prot, 1));
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
+				       &rule_bind, 0));
+	enforce_ruleset(_metadata, ruleset_fd);
+	EXPECT_EQ(0, close(ruleset_fd));
+
+	sock_fd = socket_variant(&self->srv0);
+	ASSERT_LE(0, sock_fd);
+	EXPECT_EQ(0, bind_variant(sock_fd, &self->srv0));
+	EXPECT_EQ(-EACCES, connect_variant(sock_fd, &srv_remote));
+	EXPECT_EQ(0, matches_log_tcp_bound(self->audit_fd, variant->addr,
+					   self->srv0.port, srv_remote.port));
+
+	EXPECT_EQ(0, audit_count_records(self->audit_fd, &records));
+	EXPECT_EQ(0, records.access);
+	EXPECT_EQ(1, records.domain);
+
+	EXPECT_EQ(0, close(sock_fd));
+}
+
 TEST_HARNESS_MAIN


