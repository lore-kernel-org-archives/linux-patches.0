Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B1F34D38E;
	Tue, 11 Nov 2025 01:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825092; cv=none; b=WYWKi1qPDyqv4oIf60diZb6eWxdiilTL+H46bSDn+NSQVUozwH1CvJhkCY8mLLbAx0wWzreOQzkBBrrQylUXiHbgAnNcjIFToi81Wru/r2qregY+oVU2dSXYG9GlNDy1kmFJoQGPRztP/9ovffFUP64UF7SIZkwEQqopgIXEOFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825092; c=relaxed/simple;
	bh=A1fROlt49CgNRBdW1Gg6B7Coj00VMte/PlEdbhylYUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGomrlh/04P/3E0Hic6EwVqcmPkxigL0IBqW6yD64rDdy/oJZ9i4jZy6qVklo25Fq9uWnmtQHf0j17m633uS7E8gKwjxF8lCQZXNSdhyCJD4QLhdLJx99GhlPlU70V3JhqITqLZ8KtmnaKFKA0z1XR3ybhaXc2QLVU2Z8F28YvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+kkiJxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+kkiJxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75DAC19422;
	Tue, 11 Nov 2025 01:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825092;
	bh=A1fROlt49CgNRBdW1Gg6B7Coj00VMte/PlEdbhylYUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+kkiJxndLw5CB12hoeVfd7uemSyBHxSdumsgo+h4p/Pd20glmlcSR2F+DAj3v0Mw
	 JBvmu9oTkgnNcM9qW81KEBKljRANVjN+qNxmf2QJqJROSTngQniABiTRtnklP4lmqZ
	 xPJItYWqBeCwGsrkz2TKOF8D3LQWpRXHcXN04ZJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Zanni <alessandro.zanni87@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 656/849] selftest: net: Fix error message if empty variable
Date: Tue, 11 Nov 2025 09:43:46 +0900
Message-ID: <20251111004552.288728731@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Zanni <alessandro.zanni87@gmail.com>

[ Upstream commit 81dcfdd21dbd7067068c7c341ee448c3f0d6f115 ]

Fix to avoid cases where the `res` shell variable is
empty in script comparisons.
The comparison has been modified into string comparison to
handle other possible values the variable could assume.

The issue can be reproduced with the command:
make kselftest TARGETS=net

It solves the error:
./tfo_passive.sh: line 98: [: -eq: unary operator expected

Signed-off-by: Alessandro Zanni <alessandro.zanni87@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250925132832.9828-1-alessandro.zanni87@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tfo_passive.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tfo_passive.sh b/tools/testing/selftests/net/tfo_passive.sh
index 80bf11fdc0462..a4550511830a9 100755
--- a/tools/testing/selftests/net/tfo_passive.sh
+++ b/tools/testing/selftests/net/tfo_passive.sh
@@ -95,7 +95,7 @@ wait
 res=$(cat $out_file)
 rm $out_file
 
-if [ $res -eq 0 ]; then
+if [ "$res" = "0" ]; then
 	echo "got invalid NAPI ID from passive TFO socket"
 	cleanup_ns
 	exit 1
-- 
2.51.0



