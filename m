Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D29418A34;
	Fri,  4 Sep 2026 06:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502049; cv=none; b=G1mBT+1FCYr6pmkqas7R7baFUOx89//uXJb+YHqtGXYzTt1OxTl9mt6rAi8B7kRLOeXL0fbCkrVa/PlIKRjg6EU3plY4yxeKQsHzEmbKSuoCHpVRWAHdWL9hocf4V/O0nCPRCL+YLvaT8YlY5vek70ZhBHzMPOOQHndZRXse97M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502049; c=relaxed/simple;
	bh=/t4dyjBJAuysfLosFDDUIEGqkKLlc5rFgHcJB9BP+XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezH9ptK3u2DL6GQ3wToHvt2NBw9fICmZ491abgJp88zKFQmSVwDLLHXBECdAnUXC7tZdN4Y1MgJQEJfLqJT1diUzX5skyYv3GK6zeqDfgS27F5/CK0OWRSLa4Huhkaf6/cA/GSqTXO7xzu+NWQYU/VuzRHOERIpUSJkqgZ7bnxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcgLMnWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcgLMnWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B401F00A3D;
	Fri,  4 Sep 2026 06:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502048;
	bh=z5auiss/0yiyJVTL92C0FSF4jruKecGKh9dgIiz2ghE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcgLMnWqLtge6vEKV3ocKKbdKuaY9HZEvaU334kG7MkggGKgof0l3FbtEvUem65jB
	 VI/BYMkGSh+jbgh4WJdbMQdSg0bLOwxiHMBNkwbQLnchsXgzJMjg+e1KAaqA+Va3cR
	 RHUimz72o/E6hNMneiXGNmADTPLsJkAJCGdrBcQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 070/403] NFSD: Fix off-by-one in DRC bucket pruning limit
Date: Fri,  4 Sep 2026 06:57:53 +0200
Message-ID: <20260904045736.430093497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

commit d0728723c80dcb3432effd67c7e919b596004b1d upstream.

nfsd_prune_bucket_locked() evicts an entry before checking
the freed count against @max. The check uses "++freed > max",
which does not break until freed exceeds max, resulting in
max + 1 evictions. Use ">=" so the limit stated in the
function comment is honored.

Fixes: a9507f6af145 ("NFSD: Replace nfsd_prune_bucket()")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Link: https://patch.msgid.link/20260717001232.438792-2-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfscache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -286,7 +286,7 @@ nfsd_prune_bucket_locked(struct nfsd_net
 		nfsd_cacherep_unlink_locked(nn, b, rp);
 		list_add(&rp->c_lru, dispose);
 
-		if (max && ++freed > max)
+		if (max && ++freed >= max)
 			break;
 	}
 }


