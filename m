Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5699E2D5426;
	Tue, 15 Jul 2025 13:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585675; cv=none; b=eiwqCWYVEoRRRGx0FsWgpm/y4UmvaQid4H7U13O9elaFiGyg1bvPfrC/HTC50aIitSnPngBfPDjMXS7Br0AjfSRJLldgvBzV/4UmXvN9kGhkO+Gn6q74POcs6tol5He711Wb0I9L6O8Ak+khaTVTEIvQF8IjCb8RX17FdHGWA7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585675; c=relaxed/simple;
	bh=x7A8TgAmtP+WOo8ZJJK82P3p4wdw4HiaIeWFZ3JsMkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnYsj3/EihRwIgpf1SLZ3xsg0hm/ZFIvVpNxVrQfJraxo8Czon4IYe/sizvk9zWLhIVFN1JpHq6WgBhNpLTU+E7HQFPCMzaYOflcP88z4LQrzQwedZgPpAErt+kRehlPakiRpWDsArdJqHYIGspsaPfClxSj4HDouAm+jhgjtZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=073/GfHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="073/GfHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D8EC4CEE3;
	Tue, 15 Jul 2025 13:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585675;
	bh=x7A8TgAmtP+WOo8ZJJK82P3p4wdw4HiaIeWFZ3JsMkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=073/GfHYvAYZTF2pwPM9AEgJ5Y390TiMcrBB+mSpqX6JoAPUGldCB/Q+Q/g/U9eOZ
	 S3ZYBt1utz49/Qa4V8cjL1CDJkosb5NImJvp38zbRLumtpHpBj+FFR4QAlDvde5Je9
	 MQjJw2Bf53Y8741xr5aMEoMb8PLpM1+M/pXDmbg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/163] selftests: net: lib: fix shift count out of range
Date: Tue, 15 Jul 2025 15:13:18 +0200
Message-ID: <20250715130814.056187259@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6839514a176d3..bb4d2f8d50d67 100644
--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -258,7 +258,7 @@ log_test_result()
 	local test_name=$1; shift
 	local opt_str=$1; shift
 	local result=$1; shift
-	local retmsg=$1; shift
+	local retmsg=$1
 
 	printf "TEST: %-60s  [%s]\n" "$test_name $opt_str" "$result"
 	if [[ $retmsg ]]; then
-- 
2.39.5



