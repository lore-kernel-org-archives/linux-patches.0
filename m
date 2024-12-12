Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F462210E2;
	Thu, 12 Dec 2024 16:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022277; cv=none; b=j94ervY3URC+5Vk6EjVYnofXE+dxzmDKpUgJlTGvbZyrYzk9kV8Y/t00j2izttXRCvApyNeHxpDgXOUYkjSfq9SL1mQqNVymyBVurp/wNywhkI52EephwAESvr56YK1CURljZDv4foRQb8l6Ei0k0a7GRMqX07aVFWCVCzVo5Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022277; c=relaxed/simple;
	bh=MAYYOnI+WIlV+eiteJnWevrswNY7rt6GJ/+8VXq5wsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZ9nTklPeegkNwxyazSu21yBWtdsg3yVcsBLZjg6PnWw3G141j82KmOD12LEz7oyvsqMyIEj3YuE393VPNJMIahsnosvlTRovrVhX5hXcHflkLcdgVcrGG/4uhZfMAjTHxKf5tbYYo+1ZAK7MBNYbU+nf+W2lZDMqhcGTANOzsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnPxV1Th; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnPxV1Th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFD4C4CECE;
	Thu, 12 Dec 2024 16:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022277;
	bh=MAYYOnI+WIlV+eiteJnWevrswNY7rt6GJ/+8VXq5wsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnPxV1ThnUEk2p7Mh6Jzthr4o/JxMd391SxO+z943/DgYNqehkGD3S82M8E/V0SSo
	 IM/QP1IjvS1rctBFuJqwhP/rPWjQD+2+K9E0hrjfzxqj5arjwe6doZ8mTljcn/xeA6
	 WaVL9uHM/Avo9poyGEvTSjbWdMKWeQHbaXFxubIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 197/565] selftests: net: really check for bg process completion
Date: Thu, 12 Dec 2024 15:56:32 +0100
Message-ID: <20241212144319.274481686@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 31e3d0db7a12e..84c05e533056d 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -1799,7 +1799,7 @@ check_running() {
 	pid=${1}
 	cmd=${2}
 
-	[ "$(cat /proc/${pid}/cmdline 2>/dev/null | tr -d '\0')" = "{cmd}" ]
+	[ "$(cat /proc/${pid}/cmdline 2>/dev/null | tr -d '\0')" = "${cmd}" ]
 }
 
 test_cleanup_vxlanX_exception() {
-- 
2.43.0



