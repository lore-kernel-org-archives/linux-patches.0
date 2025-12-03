Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3595035CBAE;
	Wed,  3 Dec 2025 16:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779211; cv=none; b=DSsEaPEzYVWJXYKGBHRgOJOj7y5Nipt+TFWvodkVp5L8TVgYxCYVCWBjmk0wZ6Fx7JC5crSBtzIl6BfyshQ0+kTYHFDwamWIvDmEmsdv3NsuAM9AVbshoDYy8Fu9N6a0xTZEiMrB0azI3Zj2RizIUsY/8aC8bP0jEEKosQqGrJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779211; c=relaxed/simple;
	bh=zdUYkC5tzxrVZPku2DPVqY6OK/LN3HEoR13u7sBpXw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1C7DcnqPdbtcQTQnhd6arvabVEI15NEUZAcS1iebHDdt+28Dbh1B7zThSUkMMCjs6S9g0krJjOUn5b7f0mJBSFxQAY0xowJAIt+mXZo4GfcvPKl5fNHAWnfuMgpD9pMDEJnA7rDjXzxUuCkKNGUD3dlX9fZRpVtBxzQiNtxSeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZ6bEWgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZ6bEWgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8956CC4CEF5;
	Wed,  3 Dec 2025 16:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779211;
	bh=zdUYkC5tzxrVZPku2DPVqY6OK/LN3HEoR13u7sBpXw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZ6bEWgHqVdYscg+5JiaOkeaqRqA8kOqW3I9lrX9WQBJyDYcDPC2/WRAoIGSF0+zB
	 sqqM0whhIStpfenqWRBOd8kvHQyeK3MZSdzJEaLjpCLsots9eysIArx40PC1SIFyDx
	 +GH15UzqicWcbBjIk50XvSLnorJnNfKgDpKGKVjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 189/568] ipv6: Add sanity checks on ipv6_devconf.rpl_seg_enabled
Date: Wed,  3 Dec 2025 16:23:11 +0100
Message-ID: <20251203152447.648606782@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit 3d95261eeb74958cd496e1875684827dc5d028cc ]

In ipv6_rpl_srh_rcv() we use min(net->ipv6.devconf_all->rpl_seg_enabled,
idev->cnf.rpl_seg_enabled) is intended to return 0 when either value is
zero, but if one of the values is negative it will in fact return non-zero.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Link: https://patch.msgid.link/20250901123726.1972881-3-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index cbdb510b40ea2..03961f8080757 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7070,7 +7070,9 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.data		= &ipv6_devconf.rpl_seg_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
 	},
 	{
 		.procname	= "ioam6_enabled",
-- 
2.51.0



