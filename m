Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE34370D47;
	Sat, 12 Sep 2026 10:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208364; cv=none; b=nuU1FlMc+4/d/pRUn33UcHsCTx+2WME25r2ej5DppVgyN9+ZzrCpknsIAejBPDMIzICXXgWAQcgud8pegIDgWrjY/j+nekZ9ZtW5t7+zHtHZ8JjEp5/SsOLFbfAWt1wB8qsFJrP3AaR60GV5C8bUCsv0/MYevfdrdlGGh3kKzW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208364; c=relaxed/simple;
	bh=jCSL0i1k9FsezifNz5LaAxajcKjx5qFsAtLg+j6A4Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cN8r17iFrp2bQDNReydPHvLQt25eqSWF11osxKKTIGRr3ro9FeTWFHnQv2ty0S7BXEPKDFEy3QxGuV+77Dtbq03lDuHUw9yU4tYLhT6A41hMFHmQUsx2ZKBFMhUseTfb/zlorF5EblIV8yZxhfDWKprBjX4NLKvvT8bsuzTr2k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2s2vDq3h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2s2vDq3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367091F000FF;
	Sat, 12 Sep 2026 10:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208363;
	bh=07IkdugGf4HLG+qoQvuX8fxrnHRmaYIZsfCQICFs6VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2s2vDq3h/VgTIso24vh/R8MU4D9pvrmi00pi6I4HquSSkzv7TcP9aZCHvkk1T1PV5
	 d5AOoJpGvbNiB36J0YnhY1t1WvN4jTuTCZKHoI9xjnT8LxMdjZpm0kEOu6SYaN8/mm
	 1CK5hQmTnZGhed/0ESc6wGGhAOjatqJSwiuobncQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0558/1518] xfrm: Fix skb double-free in xfrm_dev_direct_output()
Date: Sat, 12 Sep 2026 08:45:27 +0200
Message-ID: <20260912065636.059172207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Sanghyun Park <sanghyun.park.cnu@gmail.com>

[ Upstream commit 2aed51fc58d9ce450e2c116efb956160fd06fa02 ]

A return value other than 1 from local_out() means that the skb has been
consumed or its ownership was transferred. xfrm_dev_direct_output()
nevertheless frees the skb on this path, causing a double-free when
netfilter drops the packet and invalidating any other owner.

Return the local_out() result directly, matching the ownership handling
in xfrm_output_resume().

Fixes: 5eddd76ec2fd ("xfrm: fix tunnel mode TX datapath in packet offload mode")
Signed-off-by: Sanghyun Park <sanghyun.park.cnu@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_output.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 54222fcbd7fd8..b152edf50feca 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -629,10 +629,8 @@ static int xfrm_dev_direct_output(struct sock *sk, struct xfrm_state *x,
 	nf_reset_ct(skb);
 
 	err = skb_dst(skb)->ops->local_out(net, sk, skb);
-	if (unlikely(err != 1)) {
-		kfree_skb(skb);
+	if (unlikely(err != 1))
 		return err;
-	}
 
 	/* In transport mode, network destination is
 	 * directly reachable, while in tunnel mode,
-- 
2.53.0



