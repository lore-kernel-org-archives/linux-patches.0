Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0723E2D3EEE;
	Wed, 25 Feb 2026 06:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002735; cv=none; b=rX+FeuS01tBzFpLjgn2w1rkIZ3dvSlcqzot7Vm2Jtwitv/7QOZR9tKJlH3M3S3BRumpLyJu4erVT52XEUiVT3cIlnmWdg5DA8llUyZC99hejPjv6BTblwzRnbbUJnKE1mjBgTd7bRATd2pBEjP5RXhkjluYCaGxeQfAN02LJ/SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002735; c=relaxed/simple;
	bh=Cw/RSrTtaux8XoLkV85y1P7p8poENNHHHV/fAKApC0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0oef2KzIotFuveomjWF1Dms/XtpV0kEiX5XIqgBKDgbmNIqihUureMs/8CdJZ7viU+riiRn1A7HNfXzLmuI6FXQTyuZSlsMHQsH4a7U20kN5ETRydU4OgfJtoQLmtBa+YZv6xDMG4rZNQ5zTFTyawemTddWExZ60UnRG5bcctc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpwHj3y/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpwHj3y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88DDC116D0;
	Wed, 25 Feb 2026 06:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002734;
	bh=Cw/RSrTtaux8XoLkV85y1P7p8poENNHHHV/fAKApC0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HpwHj3y/9qAEbruzWsvMxPj5itLXbvUxDbpNtlO9yVArhqIGd7KNJTbnKqMn7CEl2
	 SyzTlz5iKdzEAKNodDnPIXTwgXhBh/3JK6XFCjlcUKUNZXk8ZLMPyMpSHIjwLlVFIX
	 V+q/npkg4r1bQgEpjd8j6gi4L2irFeFnAf0UHJfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 514/641] selftests: net: lib: Fix jq parsing error
Date: Tue, 24 Feb 2026 17:24:00 -0800
Message-ID: <20260225012400.976438907@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit 10ec0fc0ccc525abc807b0ca8ad5a26a0bd56361 ]

The testcase failed as below:
$./vlan_bridge_binding.sh
...
+ adf_ip_link_set_up d1
+ local name=d1
+ shift
+ ip_link_is_up d1
+ ip_link_has_flag d1 UP
+ local name=d1
+ shift
+ local flag=UP
+ shift
++ ip -j link show d1
++ jq --arg flag UP 'any(.[].flags.[]; . == $flag)'
jq: error: syntax error, unexpected '[', expecting FORMAT or QQSTRING_START
 (Unix shell quoting issues?) at <top-level>, line 1:
any(.[].flags.[]; . == $flag)
jq: 1 compile error

Remove the extra dot (.) after flags array to fix this.

Fixes: 4baa1d3a5080 ("selftests: net: lib: Add ip_link_has_flag()")
Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/20260211022146.190948-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/lib.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/lib.sh b/tools/testing/selftests/net/lib.sh
index f448bafb3f208..d0306b27fe95e 100644
--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -576,7 +576,7 @@ ip_link_has_flag()
 	local flag=$1; shift
 
 	local state=$(ip -j link show "$name" |
-		      jq --arg flag "$flag" 'any(.[].flags.[]; . == $flag)')
+		      jq --arg flag "$flag" 'any(.[].flags[]; . == $flag)')
 	[[ $state == true ]]
 }
 
-- 
2.51.0



