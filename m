Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061DA24A05D;
	Wed, 25 Feb 2026 01:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983531; cv=none; b=leYGJN3pd2N4KjLKlt9qIQo6Gzt6JaFFgWSKWCtQ4fvheOHDlsGIpq5YZNu2cqKJp1lGS5S6vGxILnqxQ5huk7Ok3O1Yv479JsjKMZIIrDbFnS0Q5IZAbjvIZooO8fqL4q3V5eGsgqH2ghThYVmPFkuZ7+OLbCcFL6+O26g5T+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983531; c=relaxed/simple;
	bh=hBxQC8DR8c8H8U4as7BjO8mS1KKrk+H8Z0P/FX3tR38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJgmNvgAXXJjo1RDP4Vs/8S7eVyzsqFOrbGg1TkMvyomXg4DGMl7SLFTERmvLKTSa+Jb8+vya5aagkBhBxMmuYayFLX5QKtCiZy337XRvVdl9vOjAHApD/WzjppMl4VzbOL7mb3u9w3poGNPA/iHq/I2zDvkAZlbDZkkddvMTNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXXJb6A2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXXJb6A2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F45C116D0;
	Wed, 25 Feb 2026 01:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983530;
	bh=hBxQC8DR8c8H8U4as7BjO8mS1KKrk+H8Z0P/FX3tR38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXXJb6A2duJjCvCwDb6SenVzMntpFlDYIAtWFsXDXA1lQuoLFyjuJkcTfLNGk4SOz
	 6EWIIOlWM9pR1zNX2qWSbLzVuKM6Fy5DTHm0PM2IpXOC5lNMhsyFFHQn9TZCHP2Lrw
	 YiE+t10EBB2JkE1vwNdP9M2KHJOGIHvuUTOaRGxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 637/781] selftests: net: lib: Fix jq parsing error
Date: Tue, 24 Feb 2026 17:22:26 -0800
Message-ID: <20260225012415.429783591@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 0ec131b339bc4..b40694573f4c7 100644
--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -577,7 +577,7 @@ ip_link_has_flag()
 	local flag=$1; shift
 
 	local state=$(ip -j link show "$name" |
-		      jq --arg flag "$flag" 'any(.[].flags.[]; . == $flag)')
+		      jq --arg flag "$flag" 'any(.[].flags[]; . == $flag)')
 	[[ $state == true ]]
 }
 
-- 
2.51.0



