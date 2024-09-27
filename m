Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C863C3C;
	Fri, 27 Sep 2024 12:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440430; cv=none; b=A+YMnJW0uGbWE6MBKnFnHakkYGKxBuwCiI7Ua4vs6atSRcsl0c1PwLNEqpGmUzGM5riEjihHwJNEwdA7Zhg2hkWkPt/V72Yd4XdrVj5NOaXbvtnHgs96KwVHOgSp2uFXdtGWoPElxI2PTOrKG5eIvOoggenTgMmnoxPEO2AH+dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440430; c=relaxed/simple;
	bh=j6MH+HLc48dDUWoM+ZbACpJ5J36c10M3ag/Zk/rhnL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaUTUQ2+cG6DBWArljz5oC68SwLiiUt7+/o9e1M8dNTmOV7zbHtl35JNRUpMvNw8kAwHUm+reVDq8r6aDsWwFHmjtxHP7gouwIhtNfsOSSb2Dq3+6mDUh29kxV3ZoSvi/MHq28HADr0zESEhcUR87RMN6gqQ/yPK2MJRo+VoH9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRhjW6Rv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRhjW6Rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54403C4CEC4;
	Fri, 27 Sep 2024 12:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440430;
	bh=j6MH+HLc48dDUWoM+ZbACpJ5J36c10M3ag/Zk/rhnL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRhjW6Rv7QeVkfUaFPNDl+8x8Q8tTMEAYjjR1rq9pAYd7iUbgZrRtWXIY9TWTG0TH
	 QgHTOJO52khmDwmkhruaqPzWJD0eG2NK5YDMoD5HG8mu5dKlpqwzNt6KWArjC2WGVt
	 uonfJBT5+HpXtjHhscvIGCUTzn3LChU/2pvEeU5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 68/73] selftests: mptcp: join: restrict fullmesh endp on 1st sf
Date: Fri, 27 Sep 2024 14:24:19 +0200
Message-ID: <20240927121722.597842645@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 49ac6f05ace5bb0070c68a0193aa05d3c25d4c83 upstream.

A new endpoint using the IP of the initial subflow has been recently
added to increase the code coverage. But it breaks the test when using
old kernels not having commit 86e39e04482b ("mptcp: keep track of local
endpoint still available for each msk"), e.g. on v5.15.

Similar to commit d4c81bbb8600 ("selftests: mptcp: join: support local
endpoint being tracked or not"), it is possible to add the new endpoint
conditionally, by checking if "mptcp_pm_subflow_check_next" is present
in kallsyms: this is not directly linked to the commit introducing this
symbol but for the parent one which is linked anyway. So we can know in
advance what will be the expected behaviour, and add the new endpoint
only when it makes sense to do so.

Fixes: 4878f9f8421f ("selftests: mptcp: join: validate fullmesh endp on 1st sf")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240910-net-selftests-mptcp-fix-install-v1-1-8f124aa9156d@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in mptcp_join.sh, because the 'run_tests' helper has been
  modified in multiple commits that are not in this version, e.g. commit
  e571fb09c893 ("selftests: mptcp: add speed env var"). The conflict was
  in the context, the new lines can still be added at the same place. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3048,7 +3048,9 @@ fullmesh_tests()
 		pm_nl_set_limits $ns1 1 3
 		pm_nl_set_limits $ns2 1 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow,fullmesh
+		if mptcp_lib_kallsyms_has "mptcp_pm_subflow_check_next$"; then
+			pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow,fullmesh
+		fi
 		run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_1 slow
 		chk_join_nr 3 3 3
 		chk_add_nr 1 1


