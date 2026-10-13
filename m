Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFA435E1A3;
	Tue, 13 Oct 2026 12:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895682; cv=none; b=WqxqhMoxw3kOiChj77DqE5iV2UCUJZI4MWZ6vUbYU10iJ/VDYAcVT58RUb38x57Ln/CbL+avTJbU8y3F4BjLrlsNb+Dc4baKFi5BGHJrlpVKf2ZhbbT8D/1E+kHNzp5ubmbrNE/TX6j+c4h21SnEOH8xt5dycGEDSJCNfZ5r7nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895682; c=relaxed/simple;
	bh=JCKwFa8kJ0w36mp/z/cbUhVvAdZTQEYiaxv2IrLn5e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoqxA7Eof8akPJOElgyobY7/EiWfsVKx9CWVsWJTEITsUHWNAVGV96I4Xk9IioLqTwHdmlaEP2HB0p6VApptpuVjD2/Ry1Cdjy8iEfpxtChAb77ptex2bWisAmL6Z0X/6UYBWQQKOFB76STf3KCSmCnY56QG6OfAUqY7MEHT/Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5IcjcXs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5IcjcXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2305F1F000FF;
	Tue, 13 Oct 2026 12:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895681;
	bh=T5okwa5TaxNYTO60cmny+EeaDUMLWUX1jy2uYulguiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5IcjcXshAe16lIbdcy9Ro3w0rhV8BjWuRZmfhxHLf+6trtuEXLfmSqY075EsHqTa
	 sPzfZTvLyNxKMhVoVLnKo3LmP0AWuygOfp8vT+lENNNvUK7jEjcjv8CCLMx5UMhXVw
	 HfRhky5dCSSFpWur/lG3csuao7rtXOJex8VoTxZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 356/497] ipv4: stop route notification sizing when nexthop group shrinks
Date: Tue, 13 Oct 2026 13:38:43 +0200
Message-ID: <20261013112916.356931168@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit d3daa33c7af92e38f2274bbd2576f58bfbaf89e6 upstream.

Commit 680aea08e78c ("net: ipv4: Emit notification when fib
hardware flags are changed") added an RCU-only fib_nlmsg_size() call
for asynchronous hardware flag notifications.

fib_nlmsg_size() checks fib_info_num_path() before each iteration,
then fib_info_nhc() independently reloads nh->nh_grp. If
RTM_NEWNEXTHOP replaces a group with fewer paths between those loads,
fib_info_nhc() returns NULL and fib_nexthop_nlmsg_size() dereferences
it.

Stop sizing when the indexed path is absent. Nexthop groups are
dense, so the current snapshot has no later path.

Fixes: 680aea08e78c ("net: ipv4: Emit notification when fib hardware flags are changed")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/1054fa46165bba1b473782fa41367804aa908e86.1790915964.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -514,6 +514,9 @@ size_t fib_nlmsg_size(struct fib_info *f
 			struct fib_nh_common *nhc = fib_info_nhc(fi, i);
 			size_t nhsize;
 
+			if (!nhc)
+				break;
+
 			nhsize = fib_nexthop_nlmsg_size(nhc, nhs != 1);
 
 			if (nhs != 1)


