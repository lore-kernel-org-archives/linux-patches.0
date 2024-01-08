Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881D353E00;
	Mon,  8 Jan 2024 15:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFHXdiLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2397C433CD;
	Mon,  8 Jan 2024 15:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728582;
	bh=UxYa3PMB6cRle4GJ4yXDOEh194TXK92qLYoMjyWV0u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFHXdiLJQBFgUinJoPboOv2oToUPwoNtRGjVQbT0EoPju2HcGSkYQCRBb87raNlw8
	 f9TyADEtRKWRLL55GsCy/jYDRPEmIxCRZ9/nw+KACLOlhdslEC8uK0s5PdIyjdoHHK
	 YFRCkKQo9swkCGoyzq/Plcdr6DwbbM71DTTWQTSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiumei Mu <xmu@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/150] selftests: mptcp: fix fastclose with csum failure
Date: Mon,  8 Jan 2024 16:35:45 +0100
Message-ID: <20240108153515.543418133@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 7cefbe5e1dacc7236caa77e9d072423f21422fe2 ]

Running the mp_join selftest manually with the following command line:

  ./mptcp_join.sh -z -C

leads to some failures:

  002 fastclose server test
  # ...
  rtx                                 [fail] got 1 MP_RST[s] TX expected 0
  # ...
  rstrx                               [fail] got 1 MP_RST[s] RX expected 0

The problem is really in the wrong expectations for the RST checks
implied by the csum validation. Note that the same check is repeated
explicitly in the same test-case, with the correct expectation and
pass successfully.

Address the issue explicitly setting the correct expectation for
the failing checks.

Reported-by: Xiumei Mu <xmu@redhat.com>
Fixes: 6bf41020b72b ("selftests: mptcp: update and extend fastclose test-cases")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20231114-upstream-net-20231113-mptcp-misc-fixes-6-7-rc2-v1-5-7b9cd6a7b7f4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index e52d513009fb0..9d8dde3b5c332 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3041,7 +3041,7 @@ fastclose_tests()
 
 	if reset_check_counter "fastclose server test" "MPTcpExtMPFastcloseRx"; then
 		run_tests $ns1 $ns2 10.0.1.1 1024 0 fastclose_server
-		chk_join_nr 0 0 0
+		chk_join_nr 0 0 0 0 0 0 1
 		chk_fclose_nr 1 1 invert
 		chk_rst_nr 1 1
 	fi
-- 
2.43.0



