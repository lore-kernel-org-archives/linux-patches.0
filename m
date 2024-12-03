Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C82A1EF0AE;
	Tue,  3 Dec 2024 15:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238609; cv=none; b=YUdR7fjKrHSKKsGuw1Y8S9yAyfdjyZ+SS9/Vv+gf4RKWxH02a2GHiUklgGacXM94TnHYNblpoIE/7SAAaIqGs0XWUdM3eI7f71VxppL/+MI2IhEu5lSMqL3F+OX0Z4DwOLtqqE3rLzm3+14cxqKnqpBT7JHc7cRrZ9l3AZiEqB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238609; c=relaxed/simple;
	bh=unMCCYITmU+2foaVoQJhueOjbatJZ+lqSCr3ZBjs2UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJQuA4QSiMIhKZfR/zJdXx0sHRrjUujlN8whPMHQh3qub/iTcGBkH/pxTGZ9VziDCiv90i18aUPmMzu2nZjpK0Gp696rZgFKhpbwrod2Izbs1yqHWgiHk/xSA//B3iRY3rvJJzO6ajCCwdwaIRmbYxDZbNZC0FYIIADnBeLIPbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYUREeJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYUREeJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85DAC4CECF;
	Tue,  3 Dec 2024 15:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238609;
	bh=unMCCYITmU+2foaVoQJhueOjbatJZ+lqSCr3ZBjs2UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYUREeJsq4w9MJBlgObkNwI6IxUyfuZ+iSLqn1hghQKzMwjq8801uUy5heTN3saHt
	 i6wB5hTXtFNVs5p0GgVC8b+KAc+CXsv1qhaPgqHYQ520cnD1E2Iu0MTeNXmDswOZC2
	 U7R1d21wfi4m85OM/8hakaHhHYsl7ENEqZ9Xw0jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 335/817] selftests: net: really check for bg process completion
Date: Tue,  3 Dec 2024 15:38:27 +0100
Message-ID: <20241203144008.895656091@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 52ed077aa6336dbef83a2d6d21c52d1706fb7f16 ]

A recent refactor transformed the check for process completion
in a true statement, due to a typo.

As a result, the relevant test-case is unable to catch the
regression it was supposed to detect.

Restore the correct condition.

Fixes: 691bb4e49c98 ("selftests: net: avoid just another constant wait")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/0e6f213811f8e93a235307e683af8225cc6277ae.1730828007.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/pmtu.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 5175c0c83a238..d5af6099d6477 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -2062,7 +2062,7 @@ check_running() {
 	pid=${1}
 	cmd=${2}
 
-	[ "$(cat /proc/${pid}/cmdline 2>/dev/null | tr -d '\0')" = "{cmd}" ]
+	[ "$(cat /proc/${pid}/cmdline 2>/dev/null | tr -d '\0')" = "${cmd}" ]
 }
 
 test_cleanup_vxlanX_exception() {
-- 
2.43.0



