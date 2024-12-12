Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82F613CA81;
	Thu, 12 Dec 2024 17:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025261; cv=none; b=jxCNmG+Vj3A6/ug3Ma0WpNdT0VRmTWfA3h5vfSRXCm9eoQ7R5qzhOJOQLCUhoXSg6icbimpZzpZq46UZJGPFI6ufoz3a1g5ThQ7pEmmTs1yIpxhezt9mcdXnpgQXaEm07abhdbUDmPNDRyJvo4+MPH1I6SiqGfeqnRw1dIItpfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025261; c=relaxed/simple;
	bh=bp+k4797OthKoVRrNEQjlsupK0m8Zg9tvVk800+EaKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RF23EAyTr33mNjxxL1noh2f7fmeEg+aiiH0IOJMihjx8I/783vhnJlXzxV6qy4HiPJE7QduwkYxhb/2G1m3y3ijIACCbgqoFmvIPjD6bUFBx9rYqlVmZK2Wb2EG1KTYWQ+DFuk7B1k4MgFchyF5fawIVBeWZyqcjSCPgEG9rT14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZoFeU4b3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZoFeU4b3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1CCC4CED3;
	Thu, 12 Dec 2024 17:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025261;
	bh=bp+k4797OthKoVRrNEQjlsupK0m8Zg9tvVk800+EaKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZoFeU4b3Ee6oODGqtsBrVL4ErCog4/iYKASbJK4zIB7YuaR8KKc4PMtpjsh0IUVNW
	 BGRM5vvfmQabWqWj2Jjz161wN2imhunKt5UBAZ7cjh/bFIs2yxZiVOenbM8dsOIJJg
	 iraw0YbomGW6efwmXWKYcJ2VctaxhmVfw+Ax3OyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/321] selftests: net: really check for bg process completion
Date: Thu, 12 Dec 2024 15:59:58 +0100
Message-ID: <20241212144233.146697678@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a4dc32729749d..f72001008db00 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -1133,7 +1133,7 @@ check_running() {
 	pid=${1}
 	cmd=${2}
 
-	[ "$(cat /proc/${pid}/cmdline 2>/dev/null | tr -d '\0')" = "{cmd}" ]
+	[ "$(cat /proc/${pid}/cmdline 2>/dev/null | tr -d '\0')" = "${cmd}" ]
 }
 
 test_cleanup_vxlanX_exception() {
-- 
2.43.0



