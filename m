Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585E8355049;
	Fri, 15 May 2026 16:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860831; cv=none; b=ocudoKnAZvFv7gHcUnS9BSgLeQIlD23S4ZZsI6tfZusnZUC/7P9U/hZrhP8RKbE3E6xKRLcXJ6555LgHYAjzwIVFpjfnFpLB3rVJaQwyzhk5ubLUzB8u7xGteK3kMWJTePfYb13wXnN/KSs627svKXb9nTngxTRp3VH08jvwMbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860831; c=relaxed/simple;
	bh=AJLbIUHO1qevL1VGFANpcj7/IYze2HKMmzDW8Fhgs4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsxBndhcNR3JPhDk/A+IPc4vSOEfbwhN0HoFEav0rE6jPI3/kwjQCNfjZVcJCLI4TubOGKrO+156N7iB38OutDUtPiQMtcymX2SxcZaPbWKCNFiao8NtHldX0aa4jfwqS4Im/nKwQIjxhUPRp36Ic/LvkAx7JgewPiJSYCS/u7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPwUfr5g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPwUfr5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD82C2BCB0;
	Fri, 15 May 2026 16:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860831;
	bh=AJLbIUHO1qevL1VGFANpcj7/IYze2HKMmzDW8Fhgs4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPwUfr5gpTSjJxi6Bq3I6lXeG8zj5t0OLUaOO4o3Y2zhFe2Ds+c2hYs52/uRMl3Od
	 4Il4ktZ2920RYrM3SKpardmAh2jiDDuyA81n/HHasSTg8mPISDenqS1BVh8rLkI6bV
	 nLIlEURSHUSVUgxTmIzivVlFWqQDV2Lgtx3rWsjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <cyyzero16@gmail.com>,
	Balbir Singh <bsingharora@gmail.com>,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>,
	Fan Yu <fan.yu9@zte.com.cn>,
	Wang Yaxin <wang.yaxin@zte.com.cn>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 068/474] tools/accounting: handle truncated taskstats netlink messages
Date: Fri, 15 May 2026 17:42:57 +0200
Message-ID: <20260515154716.514274327@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiyang Chen <cyyzero16@gmail.com>

commit cc82b3dcc6a8fa259fbda12ab00d6fc00908a49e upstream.

procacct and getdelays use a fixed receive buffer for taskstats generic
netlink messages.  A multi-threaded process exit can emit a single
PID+TGID notification large enough to exceed that buffer on newer kernels.

Switch to recvmsg() so MSG_TRUNC is detected explicitly, increase the
message buffer size, and report truncated datagrams clearly instead of
misparsing them as fatal netlink errors.

Also print the taskstats version in debug output to make version
mismatches easier to diagnose while inspecting taskstats traffic.

Link: https://lkml.kernel.org/r/520308bb4cbbaf8dc2c7296b5f60f11e12fb30a5.1774810498.git.cyyzero16@gmail.com
Signed-off-by: Yiyang Chen <cyyzero16@gmail.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/accounting/getdelays.c |   41 +++++++++++++++++++++++++++++++++++++----
 tools/accounting/procacct.c  |   40 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 73 insertions(+), 8 deletions(-)

--- a/tools/accounting/getdelays.c
+++ b/tools/accounting/getdelays.c
@@ -59,7 +59,7 @@ int print_task_context_switch_counts;
 	}
 
 /* Maximum size of response requested or message sent */
-#define MAX_MSG_SIZE	1024
+#define MAX_MSG_SIZE	2048
 /* Maximum number of cpus expected to be specified in a cpumask */
 #define MAX_CPUS	32
 
@@ -114,6 +114,32 @@ error:
 	return -1;
 }
 
+static int recv_taskstats_msg(int sd, struct msgtemplate *msg)
+{
+	struct sockaddr_nl nladdr;
+	struct iovec iov = {
+		.iov_base = msg,
+		.iov_len = sizeof(*msg),
+	};
+	struct msghdr hdr = {
+		.msg_name = &nladdr,
+		.msg_namelen = sizeof(nladdr),
+		.msg_iov = &iov,
+		.msg_iovlen = 1,
+	};
+	int ret;
+
+	ret = recvmsg(sd, &hdr, 0);
+	if (ret < 0)
+		return -1;
+	if (hdr.msg_flags & MSG_TRUNC) {
+		errno = EMSGSIZE;
+		return -1;
+	}
+
+	return ret;
+}
+
 
 static int send_cmd(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 	     __u8 genl_cmd, __u16 nla_type,
@@ -465,12 +491,16 @@ int main(int argc, char *argv[])
 	}
 
 	do {
-		rep_len = recv(nl_sd, &msg, sizeof(msg), 0);
+		rep_len = recv_taskstats_msg(nl_sd, &msg);
 		PRINTF("received %d bytes\n", rep_len);
 
 		if (rep_len < 0) {
-			fprintf(stderr, "nonfatal reply error: errno %d\n",
-				errno);
+			if (errno == EMSGSIZE)
+				fprintf(stderr,
+					"dropped truncated taskstats netlink message, please increase MAX_MSG_SIZE\n");
+			else
+				fprintf(stderr, "nonfatal reply error: errno %d\n",
+					errno);
 			continue;
 		}
 		if (msg.n.nlmsg_type == NLMSG_ERROR ||
@@ -512,6 +542,9 @@ int main(int argc, char *argv[])
 							printf("TGID\t%d\n", rtid);
 						break;
 					case TASKSTATS_TYPE_STATS:
+						PRINTF("version %u\n",
+						       ((struct taskstats *)
+							NLA_DATA(na))->version);
 						if (print_delays)
 							print_delayacct((struct taskstats *) NLA_DATA(na));
 						if (print_io_accounting)
--- a/tools/accounting/procacct.c
+++ b/tools/accounting/procacct.c
@@ -71,7 +71,7 @@ int print_task_context_switch_counts;
 	}
 
 /* Maximum size of response requested or message sent */
-#define MAX_MSG_SIZE	1024
+#define MAX_MSG_SIZE	2048
 /* Maximum number of cpus expected to be specified in a cpumask */
 #define MAX_CPUS	32
 
@@ -121,6 +121,32 @@ error:
 	return -1;
 }
 
+static int recv_taskstats_msg(int sd, struct msgtemplate *msg)
+{
+	struct sockaddr_nl nladdr;
+	struct iovec iov = {
+		.iov_base = msg,
+		.iov_len = sizeof(*msg),
+	};
+	struct msghdr hdr = {
+		.msg_name = &nladdr,
+		.msg_namelen = sizeof(nladdr),
+		.msg_iov = &iov,
+		.msg_iovlen = 1,
+	};
+	int ret;
+
+	ret = recvmsg(sd, &hdr, 0);
+	if (ret < 0)
+		return -1;
+	if (hdr.msg_flags & MSG_TRUNC) {
+		errno = EMSGSIZE;
+		return -1;
+	}
+
+	return ret;
+}
+
 
 static int send_cmd(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 	     __u8 genl_cmd, __u16 nla_type,
@@ -239,6 +265,8 @@ void handle_aggr(int mother, struct nlat
 			PRINTF("TGID\t%d\n", rtid);
 			break;
 		case TASKSTATS_TYPE_STATS:
+			PRINTF("version %u\n",
+			       ((struct taskstats *)NLA_DATA(na))->version);
 			if (mother == TASKSTATS_TYPE_AGGR_PID)
 				print_procacct((struct taskstats *) NLA_DATA(na));
 			if (fd) {
@@ -348,12 +376,16 @@ int main(int argc, char *argv[])
 	}
 
 	do {
-		rep_len = recv(nl_sd, &msg, sizeof(msg), 0);
+		rep_len = recv_taskstats_msg(nl_sd, &msg);
 		PRINTF("received %d bytes\n", rep_len);
 
 		if (rep_len < 0) {
-			fprintf(stderr, "nonfatal reply error: errno %d\n",
-				errno);
+			if (errno == EMSGSIZE)
+				fprintf(stderr,
+					"dropped truncated taskstats netlink message, please increase MAX_MSG_SIZE\n");
+			else
+				fprintf(stderr, "nonfatal reply error: errno %d\n",
+					errno);
 			continue;
 		}
 		if (msg.n.nlmsg_type == NLMSG_ERROR ||


