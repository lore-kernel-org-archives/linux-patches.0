Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BD52EB5D6;
	Tue, 15 Jul 2025 13:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587092; cv=none; b=SO+EPWKhep930fT01LAjrStEP57Gt4+WxuawCAWQ/F3NjIKUeuqXLEQKVSGtlLB670sC+N1/M2JQiVodmge3Ud/BdyOYm06bfaHpt+LSrD4Bh8oa7RE5wOe4AXUazmoMCb20iPHB/e48ALNvBd7sXeIKcVEx8y0AZAggR/gxvcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587092; c=relaxed/simple;
	bh=zwb74O2s/s18J3co5Cpr7nJmmMxnACo16gtiprh1Vb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcXEBfyZpU17eibVivv0wRdMZMUSmebm7UDHg67DBGqvmTCCrLC1erXHBdA1ei8T/usgs4OfzkGuyy2P9ChMKt/30guO0znPRfW9KFjzF45sO6mutpih0pJRmCRlJ0wbqp4haTPQlMtW3kXMD8mwREbWzgshwofj9HKPwPw55zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ra8vVEcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ra8vVEcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C13C4CEE3;
	Tue, 15 Jul 2025 13:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587092;
	bh=zwb74O2s/s18J3co5Cpr7nJmmMxnACo16gtiprh1Vb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ra8vVEcFPZQGvRfafBSv+n8ISVy2pU3pj7eTl9EGXEb1rzbV9eYVaFQjCzOPvwiUa
	 ssmczo+sO2SbKlqTUMzwFkEoub6/W7ATYl85G5JZTjfW12CTXAJqBzQQ488yDtlWLs
	 8t3/xzrqAbURpU2dXqhb8tqLmoPsFoZzOv2YmiWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 156/192] selftests: net: lib: fix shift count out of range
Date: Tue, 15 Jul 2025 15:14:11 +0200
Message-ID: <20250715130821.178055882@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 47c84997c686b4d43b225521b732492552b84758 ]

I got the following warning when writing other tests:

  + handle_test_result_pass 'bond 802.3ad' '(lacp_active off)'
  + local 'test_name=bond 802.3ad'
  + shift
  + local 'opt_str=(lacp_active off)'
  + shift
  + log_test_result 'bond 802.3ad' '(lacp_active off)' ' OK '
  + local 'test_name=bond 802.3ad'
  + shift
  + local 'opt_str=(lacp_active off)'
  + shift
  + local 'result= OK '
  + shift
  + local retmsg=
  + shift
  /net/tools/testing/selftests/net/forwarding/../lib.sh: line 315: shift: shift count out of range

This happens because an extra shift is executed even after all arguments
have been consumed. Remove the last shift in log_test_result() to avoid
this warning.

Fixes: a923af1ceee7 ("selftests: forwarding: Convert log_test() to recognize RET values")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20250709091244.88395-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/lib.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/lib.sh b/tools/testing/selftests/net/lib.sh
index 701905eeff66d..f380f30425945 100644
--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -286,7 +286,7 @@ log_test_result()
 	local test_name=$1; shift
 	local opt_str=$1; shift
 	local result=$1; shift
-	local retmsg=$1; shift
+	local retmsg=$1
 
 	printf "TEST: %-60s  [%s]\n" "$test_name $opt_str" "$result"
 	if [[ $retmsg ]]; then
-- 
2.39.5



