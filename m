Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FAD3D9DA7;
	Wed,  8 Apr 2026 18:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672403; cv=none; b=itZQseSN+ryHp63R7rviRE3PhVoZXVLCYP25BLdBqHG7M1xASpVpi+IGKlyqYECah1Q2DIQvFS45dO5dr45s7wCQI3ap0A9KwZ3aYjD5tyXgzhois62gqoToMCZloh0cPy05rZcI5tnXxFpuIdXDGUTLe28hwqmky75oqFuZ2ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672403; c=relaxed/simple;
	bh=uI2vlLrQ0QOXLZmv6fIP68H4puduWcXRcvaNFswxDVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+r44Jmej46q7noDiPjKNKaP/4yKUNmi6elchKq7ZpSbhZumNf6EMQgR13k2YInEqXnbT0I3KqD8vqGfuEevxDHSXwsQkCxeriyUSdC1Gir2n+Y2JKyClJsk1ID3FuSP3t33nouj8r6Sxq1c/DqM59OlLzOMfjDGJfMVDVrE4x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoH5pDaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoH5pDaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477BCC2BCC9;
	Wed,  8 Apr 2026 18:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672403;
	bh=uI2vlLrQ0QOXLZmv6fIP68H4puduWcXRcvaNFswxDVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RoH5pDaJuH4f7r9X8UDLFg/h2ZKPbiHugJIsW4HgiOVuGd4mn7OBVDza9gUKN4uyW
	 CN8XrwMnJUZSf8VcC31s5B2DSYzYkAXcpjAYpHReWiw1xRSW50FBx10mfTwA/cQKaD
	 k/IvR0QqnBDtIq8GYhSCkmFPdReOqCVoEoQlfTbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 307/312] selftests: mptcp: join: check removing signal+subflow endp
Date: Wed,  8 Apr 2026 20:03:44 +0200
Message-ID: <20260408175945.241199916@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

commit 1777f349ff41b62dfe27454b69c27b0bc99ffca5 upstream.

This validates the previous commit: endpoints with both the signal and
subflow flags should always be marked as used even if it was not
possible to create new subflows due to the MPTCP PM limits.

For this test, an extra endpoint is created with both the signal and the
subflow flags, and limits are set not to create extra subflows. In this
case, an ADD_ADDR is sent, but no subflows are created. Still, the local
endpoint is marked as used, and no warning is fired when removing the
endpoint, after having sent a RM_ADDR.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 85df533a787b ("mptcp: pm: do not ignore 'subflow' if 'signal' flag is also set")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260303-net-mptcp-misc-fixes-7-0-rc2-v1-5-4b5462b6f016@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ No conflicts, but in this kernel version 'run_tests' doesn't support
  parameters set via env vars: positional parameters need to be used.
  See commit 595ef566a2ef ("selftests: mptcp: drop addr_nr_ns1/2
  parameters") and commit e571fb09c893 ("selftests: mptcp: add speed env
  var") which are not in this kernel version. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2407,6 +2407,18 @@ remove_tests()
 		chk_rst_nr 0 0
 	fi
 
+	# signal+subflow with limits, remove
+	if reset "remove signal+subflow with limits"; then
+		pm_nl_set_limits $ns1 0 0
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal,subflow
+		pm_nl_set_limits $ns2 0 0
+		run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
+		chk_join_nr 0 0 0
+		chk_add_nr 1 1
+		chk_rm_nr 1 0 invert
+		chk_rst_nr 0 0
+	fi
+
 	# addresses remove
 	if reset "remove addresses"; then
 		pm_nl_set_limits $ns1 3 3


