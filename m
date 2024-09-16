Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C125155393;
	Mon, 16 Sep 2024 12:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488245; cv=none; b=IJUPTIPcgyqr6bKBF5T9Oka7+38XWcbuSFCXrN27kplHWLDwvQXFZsbf9YMqB3KhoVjHYhEvurMFtwQLo35Kay2zZz+KRHuFtVHivoGkw83e3fO2dDE0tny+/lL0EHWT2XahT4jHy3hvaAdowo5LFRLVebwb/L8bLL+OiP9Ya6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488245; c=relaxed/simple;
	bh=RCyeJsIaX2rTqyD4nAG9SmOa9Pz9C7NSbTC9QoXpjxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o34yJlV2Q0VibVscaabsD/KQlX+pdTK2p7mdHIyfJK700LlXWNCMQFMxLpZJX5qJlzEpXM7C2hp35AguCFfU2c8uRJwbnwmQj34CUez2nsEJ/6N3K0ojk2lA7dDBXQdLNKQqpN2oYATo/KE62nTH/At9BrBIDbH36NP7K8gXbAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UG5jmkdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UG5jmkdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BD0C4CEC4;
	Mon, 16 Sep 2024 12:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488245;
	bh=RCyeJsIaX2rTqyD4nAG9SmOa9Pz9C7NSbTC9QoXpjxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UG5jmkdHffN07H1UEolUOZ64Y7INtHMsbeiedRqrTIScLVnalTpjArUiU6qwtugjk
	 c/R0MRw4nc88ms7avRLgLqEvbEp6C/1T+6iny2EPXTeyC6Ut8yXZGIE8tn18PRsdx9
	 tPC/g49rprEGG4RTQXCsKdROMEwK5m0glxoUaNU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 046/121] selftests: mptcp: join: restrict fullmesh endp on 1st sf
Date: Mon, 16 Sep 2024 13:43:40 +0200
Message-ID: <20240916114230.643742423@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3064,7 +3064,9 @@ fullmesh_tests()
 		pm_nl_set_limits $ns1 1 3
 		pm_nl_set_limits $ns2 1 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow,fullmesh
+		if mptcp_lib_kallsyms_has "mptcp_pm_subflow_check_next$"; then
+			pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow,fullmesh
+		fi
 		fullmesh=1 speed=slow \
 			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 3 3 3


