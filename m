Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632AF29A1;
	Tue, 17 Feb 2026 20:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361250; cv=none; b=W7b7vyLt043iJnwSGHFQM4WtRbKQjL+sucKddWfIQaukHKa8RvG5dNPVRw9AWz56pf254I0Na4UPxvfVo7tRZmnqbUMZXQku1JNNhPHt86Sxz+ucDtJDC8I1ORaw55AIDovyM9/h6YGo+6KOfVcrMH1LqYLGIr038Gfqb1AHoOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361250; c=relaxed/simple;
	bh=/b7BXlaSMkbf91LHGJJuTIxOJGtIGs7a/dOrBpK9Pec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ld7f9PROERS76ITMBMxza6BY6Rz5gSSp1rZi59lhqZZS+NyC1kXCmrTlNS1NbNzJuR17lqhgH+QpBfYq+wKP/dFYGgwXMHTi+lyRjQ4/rtr9HunuXbhbRp3pTzOa1y7mX3OtrD6gT5y3SrlUYIoLoVIyciiv3BxCNS43DsxZG0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5pd/T9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5pd/T9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77CCC4CEF7;
	Tue, 17 Feb 2026 20:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361250;
	bh=/b7BXlaSMkbf91LHGJJuTIxOJGtIGs7a/dOrBpK9Pec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5pd/T9VwaLWkOVddHg/aNRGsu7zp2+WjOD/kmvL9i196s1+1/58NEb411I4f7Pg3
	 umvtpaRIy+JNRNyYx+lC93uj5H2k7F3eKR5J4rrU8qT1Is9XN0vSrjbTCA6uZFwA3W
	 jxD4Q4Aa6iaSSdpAliTizlH7PMSgK/AxXXqpYyOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 46/64] selftests: mptcp: join: fix local endp not being tracked
Date: Tue, 17 Feb 2026 21:31:42 +0100
Message-ID: <20260217200009.230644870@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit c5d5ecf21fdd9ce91e6116feb3aa83cee73352cc upstream.

When running this mptcp_join.sh selftest on older kernel versions not
supporting local endpoints tracking, this test fails because 3 MP_JOIN
ACKs have been received, while only 2 were expected.

It is not clear why only 2 MP_JOIN ACKs were expected on old kernel
versions, while 3 MP_JOIN SYN and SYN+ACK were expected. When testing on
the v5.15.197 kernel, 3 MP_JOIN ACKs are seen, which is also what is
expected in the selftests included in this kernel version, see commit
f4480eaad489 ("selftests: mptcp: add missing join check").

Switch the expected MP_JOIN ACKs to 3. While at it, move this
chk_join_nr helper out of the special condition for older kernel
versions as it is now the same as with more recent ones. Also, invert
the condition to be more logical: what's expected on newer kernel
versions having such helper first.

Fixes: d4c81bbb8600 ("selftests: mptcp: join: support local endpoint being tracked or not")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260127-net-mptcp-dup-nl-events-v1-5-7f71e1bc4feb@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in mptcp_join.sh, because commit e571fb09c893 ("selftests:
  mptcp: add speed env var") is not in this version, and caused
  conflicts in the context. The same modification can still be applied
  at the same place. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2181,17 +2181,16 @@ signal_address_tests()
 		# the peer could possibly miss some addr notification, allow retransmission
 		ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=1
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
+		chk_join_nr 3 3 3
 
 		# It is not directly linked to the commit introducing this
 		# symbol but for the parent one which is linked anyway.
-		if ! mptcp_lib_kallsyms_has "mptcp_pm_subflow_check_next$"; then
-			chk_join_nr 3 3 2
-			chk_add_nr 4 4
-		else
-			chk_join_nr 3 3 3
+		if mptcp_lib_kallsyms_has "mptcp_pm_subflow_check_next$"; then
 			# the server will not signal the address terminating
 			# the MPC subflow
 			chk_add_nr 3 3
+		else
+			chk_add_nr 4 4
 		fi
 	fi
 }


