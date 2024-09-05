Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795B919538A;
	Thu,  5 Sep 2024 09:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530144; cv=none; b=eneqZRXT3jpg8ax0Tbe9mBclsL+a4uF849DI/nHQOZUA05KKldhhpJbqOBpQLBJlXvQ8SqOBW7vgQGPhwiHUAGaCs0zzvhLornjLH1hjYTm6t2XGWv49s/fFUxpHppEmtVDhD0BAIPG/TKAmrK3x786ZnhtBUg4fyy0r4kQny7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530144; c=relaxed/simple;
	bh=3djIWIBkZZsDqF/uaHa2Uy2uqb2ayR3UHWt+N1r6qAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/DJLvK7bYsX+9ncvZ/Z+cIMN1rmSefnbfW2/oXQoNGahsQR5pYFAySfkHh/YhMcjfqqX55xPCHgVUjIzRs7JMfnUw67JbHrsHC3vpcaOtkoWDp5aCSiC9WXTQSQp+l/HdsxyR3MGNSAzxqr+aEm95W2RBhi/eV9pFQ5DbjaE/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywVLORL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywVLORL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6F8C4CEC3;
	Thu,  5 Sep 2024 09:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530144;
	bh=3djIWIBkZZsDqF/uaHa2Uy2uqb2ayR3UHWt+N1r6qAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywVLORL5TVwZn0lGVpt68QuRcc8ZpZkxTWpmUlpxb26AqwgAoco+TkkyAcoqARLkk
	 +6rw3HWUD2absOD3TnP/oXdNpyAu6nbqPy56DhwezBC1RqqGSruEd2gRLwY9LPnliv
	 Edk7akXhnfDtg+JhPcFI1+mCwc+kev2i4TKMWSz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/132] selftests: mptcp: userspace pm get addr tests
Date: Thu,  5 Sep 2024 11:40:13 +0200
Message-ID: <20240905093723.253866229@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 4cc5cc7ca052c816e20ed0cbc160299b454cbb75 ]

This patch adds a new helper userspace_pm_get_addr() in mptcp_join.sh.
In it, parse the token value from the output of 'pm_nl_ctl events', then
pass it to pm_nl_ctl get_addr command. Use this helper in userspace pm
dump tests.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e93681afcb96 ("selftests: mptcp: join: cannot rm sf if closed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index df071b8c675fb..f03df10947c15 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3454,6 +3454,18 @@ userspace_pm_dump()
 	ip netns exec $1 ./pm_nl_ctl dump token $tk
 }
 
+# $1: ns ; $2: id
+userspace_pm_get_addr()
+{
+	local evts=$evts_ns1
+	local tk
+
+	[ "$1" == "$ns2" ] && evts=$evts_ns2
+	tk=$(mptcp_lib_evts_get_info token "$evts")
+
+	ip netns exec $1 ./pm_nl_ctl get $2 token $tk
+}
+
 userspace_pm_chk_dump_addr()
 {
 	local ns="${1}"
@@ -3469,6 +3481,21 @@ userspace_pm_chk_dump_addr()
 	fi
 }
 
+userspace_pm_chk_get_addr()
+{
+	local ns="${1}"
+	local id="${2}"
+	local exp="${3}"
+
+	print_check "get id ${id} addr"
+
+	if mptcp_lib_kallsyms_has "mptcp_userspace_pm_get_addr$"; then
+		check_output "userspace_pm_get_addr ${ns} ${id}" "${exp}"
+	else
+		print_skip
+	fi
+}
+
 userspace_tests()
 {
 	# userspace pm type prevents add_addr
@@ -3563,6 +3590,8 @@ userspace_tests()
 		userspace_pm_chk_dump_addr "${ns1}" \
 			$'id 10 flags signal 10.0.2.1\nid 20 flags signal 10.0.3.1' \
 			"signal"
+		userspace_pm_chk_get_addr "${ns1}" "10" "id 10 flags signal 10.0.2.1"
+		userspace_pm_chk_get_addr "${ns1}" "20" "id 20 flags signal 10.0.3.1"
 		userspace_pm_rm_addr $ns1 10
 		userspace_pm_rm_sf $ns1 "::ffff:10.0.2.1" $SUB_ESTABLISHED
 		userspace_pm_chk_dump_addr "${ns1}" \
@@ -3593,6 +3622,7 @@ userspace_tests()
 		userspace_pm_chk_dump_addr "${ns2}" \
 			"id 20 flags subflow 10.0.3.2" \
 			"subflow"
+		userspace_pm_chk_get_addr "${ns2}" "20" "id 20 flags subflow 10.0.3.2"
 		userspace_pm_rm_addr $ns2 20
 		userspace_pm_rm_sf $ns2 10.0.3.2 $SUB_ESTABLISHED
 		userspace_pm_chk_dump_addr "${ns2}" \
-- 
2.43.0



