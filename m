Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAE39443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77776C433C8;
	Sun, 13 Aug 2023 21:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962316;
	bh=EcSQzErlL59Q03XD4wxQI9c7FRFkORmG1GUJo7pX4Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BS3p3lYxMb38BzoYicMvm6+Fq9LW0zmTO7NsHwQ/0LKO4f0krXpLeYyLFnM4u+i9M
	 tt4ohz81D8audbuw3Y7MWNeJKiIjPj2S+wfxIMqoqLW/Vi2iB/zj6poETqEAqthwAR
	 RIKxA1MiSNYJe/m3zurVZRyhF88bSovQPdtKGXWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.4 162/206] nexthop: Fix infinite nexthop bucket dump when using maximum nexthop ID
Date: Sun, 13 Aug 2023 23:18:52 +0200
Message-ID: <20230813211729.662938498@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ido Schimmel <idosch@nvidia.com>

commit 8743aeff5bc4dcb5b87b43765f48d5ac3ad7dd9f upstream.

A netlink dump callback can return a positive number to signal that more
information needs to be dumped or zero to signal that the dump is
complete. In the second case, the core netlink code will append the
NLMSG_DONE message to the skb in order to indicate to user space that
the dump is complete.

The nexthop bucket dump callback always returns a positive number if
nexthop buckets were filled in the provided skb, even if the dump is
complete. This means that a dump will span at least two recvmsg() calls
as long as nexthop buckets are present. In the last recvmsg() call the
dump callback will not fill in any nexthop buckets because the previous
call indicated that the dump should restart from the last dumped nexthop
ID plus one.

 # ip link add name dummy1 up type dummy
 # ip nexthop add id 1 dev dummy1
 # ip nexthop add id 10 group 1 type resilient buckets 2
 # strace -e sendto,recvmsg -s 5 ip nexthop bucket
 sendto(3, [[{nlmsg_len=24, nlmsg_type=RTM_GETNEXTHOPBUCKET, nlmsg_flags=NLM_F_REQUEST|NLM_F_DUMP, nlmsg_seq=1691396980, nlmsg_pid=0}, {family=AF_UNSPEC, data="\x00\x00\x00\x00\x00"...}], {nlmsg_len=0, nlmsg_type=0 /* NLMSG_??? */, nlmsg_flags=0, nlmsg_seq=0, nlmsg_pid=0}], 152, 0, NULL, 0) = 152
 recvmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base=NULL, iov_len=0}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_TRUNC}, MSG_PEEK|MSG_TRUNC) = 128
 recvmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base=[[{nlmsg_len=64, nlmsg_type=RTM_NEWNEXTHOPBUCKET, nlmsg_flags=NLM_F_MULTI, nlmsg_seq=1691396980, nlmsg_pid=347}, {family=AF_UNSPEC, data="\x00\x00\x00\x00\x00"...}], [{nlmsg_len=64, nlmsg_type=RTM_NEWNEXTHOPBUCKET, nlmsg_flags=NLM_F_MULTI, nlmsg_seq=1691396980, nlmsg_pid=347}, {family=AF_UNSPEC, data="\x00\x00\x00\x00\x00"...}]], iov_len=32768}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 128
 id 10 index 0 idle_time 6.66 nhid 1
 id 10 index 1 idle_time 6.66 nhid 1
 recvmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base=NULL, iov_len=0}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_TRUNC}, MSG_PEEK|MSG_TRUNC) = 20
 recvmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base=[{nlmsg_len=20, nlmsg_type=NLMSG_DONE, nlmsg_flags=NLM_F_MULTI, nlmsg_seq=1691396980, nlmsg_pid=347}, 0], iov_len=32768}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 20
 +++ exited with 0 +++

This behavior is both inefficient and buggy. If the last nexthop to be
dumped had the maximum ID of 0xffffffff, then the dump will restart from
0 (0xffffffff + 1) and never end:

 # ip link add name dummy1 up type dummy
 # ip nexthop add id 1 dev dummy1
 # ip nexthop add id $((2**32-1)) group 1 type resilient buckets 2
 # ip nexthop bucket
 id 4294967295 index 0 idle_time 5.55 nhid 1
 id 4294967295 index 1 idle_time 5.55 nhid 1
 id 4294967295 index 0 idle_time 5.55 nhid 1
 id 4294967295 index 1 idle_time 5.55 nhid 1
 [...]

Fix by adjusting the dump callback to return zero when the dump is
complete. After the fix only one recvmsg() call is made and the
NLMSG_DONE message is appended to the RTM_NEWNEXTHOPBUCKET responses:

 # ip link add name dummy1 up type dummy
 # ip nexthop add id 1 dev dummy1
 # ip nexthop add id $((2**32-1)) group 1 type resilient buckets 2
 # strace -e sendto,recvmsg -s 5 ip nexthop bucket
 sendto(3, [[{nlmsg_len=24, nlmsg_type=RTM_GETNEXTHOPBUCKET, nlmsg_flags=NLM_F_REQUEST|NLM_F_DUMP, nlmsg_seq=1691396737, nlmsg_pid=0}, {family=AF_UNSPEC, data="\x00\x00\x00\x00\x00"...}], {nlmsg_len=0, nlmsg_type=0 /* NLMSG_??? */, nlmsg_flags=0, nlmsg_seq=0, nlmsg_pid=0}], 152, 0, NULL, 0) = 152
 recvmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base=NULL, iov_len=0}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_TRUNC}, MSG_PEEK|MSG_TRUNC) = 148
 recvmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base=[[{nlmsg_len=64, nlmsg_type=RTM_NEWNEXTHOPBUCKET, nlmsg_flags=NLM_F_MULTI, nlmsg_seq=1691396737, nlmsg_pid=350}, {family=AF_UNSPEC, data="\x00\x00\x00\x00\x00"...}], [{nlmsg_len=64, nlmsg_type=RTM_NEWNEXTHOPBUCKET, nlmsg_flags=NLM_F_MULTI, nlmsg_seq=1691396737, nlmsg_pid=350}, {family=AF_UNSPEC, data="\x00\x00\x00\x00\x00"...}], [{nlmsg_len=20, nlmsg_type=NLMSG_DONE, nlmsg_flags=NLM_F_MULTI, nlmsg_seq=1691396737, nlmsg_pid=350}, 0]], iov_len=32768}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 148
 id 4294967295 index 0 idle_time 6.61 nhid 1
 id 4294967295 index 1 idle_time 6.61 nhid 1
 +++ exited with 0 +++

Note that if the NLMSG_DONE message cannot be appended because of size
limitations, then another recvmsg() will be needed, but the core netlink
code will not invoke the dump callback and simply reply with a
NLMSG_DONE message since it knows that the callback previously returned
zero.

Add a test that fails before the fix:

 # ./fib_nexthops.sh -t basic_res
 [...]
 TEST: Maximum nexthop ID dump                                       [FAIL]
 [...]

And passes after it:

 # ./fib_nexthops.sh -t basic_res
 [...]
 TEST: Maximum nexthop ID dump                                       [ OK ]
 [...]

Fixes: 8a1bbabb034d ("nexthop: Add netlink handlers for bucket dump")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20230808075233.3337922-4-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/nexthop.c                          |    6 +-----
 tools/testing/selftests/net/fib_nexthops.sh |    5 +++++
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -3424,13 +3424,9 @@ static int rtm_dump_nexthop_bucket(struc
 
 	if (err < 0) {
 		if (likely(skb->len))
-			goto out;
-		goto out_err;
+			err = skb->len;
 	}
 
-out:
-	err = skb->len;
-out_err:
 	cb->seq = net->nexthop.seq;
 	nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 	return err;
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -2206,6 +2206,11 @@ basic_res()
 	run_cmd "$IP nexthop bucket list fdb"
 	log_test $? 255 "Dump all nexthop buckets with invalid 'fdb' keyword"
 
+	# Dump should not loop endlessly when maximum nexthop ID is configured.
+	run_cmd "$IP nexthop add id $((2**32-1)) group 1/2 type resilient buckets 4"
+	run_cmd "timeout 5 $IP nexthop bucket"
+	log_test $? 0 "Maximum nexthop ID dump"
+
 	#
 	# resilient nexthop buckets get requests
 	#


