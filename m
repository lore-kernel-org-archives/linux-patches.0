Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAD02D0292;
	Wed,  4 Feb 2026 15:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219150; cv=none; b=RG7b1NPz2PPKukGlmQodBBOpS6oAc5uMGTBFLJJIwFd6R3OvtKG+JimdCEbh73BSc7FwKYAIis/LbsTnUu511PWPFqWNyuwjbpAkeWOj15D0rVMTSZXxG04bcSyhQ7PXqEbA3xcQE6d2KC9Z+JhpJ6aEbXoOELQQ5yc3C01u0fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219150; c=relaxed/simple;
	bh=K+2tthHPKYXkPy5CM7yl46Tcoq0OM5NhgmavIoGrl5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqEHb8IhN5zFLWQGPNc/+uiSCEC4RioK7FWjZu3Nea5n7MJ7RVbi9FaP0a7QvkqhMY0t9LMxu1h5UzlcqZZ2lMOBUCa0w6sHl6t/SicfoSDUHPTxduNItJbK0LmeYpGhIFQb6yoyt5VLVYx9SxmLL4FUFzZ7VLtPV/R+Eah0/ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TB5Xp8wY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TB5Xp8wY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F448C19423;
	Wed,  4 Feb 2026 15:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219150;
	bh=K+2tthHPKYXkPy5CM7yl46Tcoq0OM5NhgmavIoGrl5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TB5Xp8wYXwfr6dntpPZWiZBWpEaK394aALtKdMfQrQzzsRnB/cP1UYkoPXghcbfsM
	 ysfBcKpseywG7OisODRPmHy9++CCZUp5a4kBW2fS9qEk3jrHPpi206uEr2DvKRRbv6
	 UJhsxIpFpntNpIcqyUCbZVoBDLc1bFFAXq5aTq94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 082/122] selftests: mptcp: join: fix local endp not being tracked
Date: Wed,  4 Feb 2026 15:41:04 +0100
Message-ID: <20260204143854.802503472@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2305,17 +2305,16 @@ signal_address_tests()
 		ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=1
 		speed=slow \
 			run_tests $ns1 $ns2 10.0.1.1
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


