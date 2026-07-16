Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BEE425868;
	Thu, 16 Jul 2026 13:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209762; cv=none; b=VyEXNkDfT0UbCPMiDpVzgxrENsz9DcDGjvJ5raZ8rLLTvHI9bUQgSqEHAhUY1gnxBe156lleH0TyUmdyyPpnTxYMaaROalGC3Q5Dtc0SfNx2J7sZA67m6XHtn9YzNT2Q5oKXiPexuzlCrDlDQXgeropa2vNo3bH/96vqaw/lWbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209762; c=relaxed/simple;
	bh=xrl9r5Olj/Njtcu54mFx2A7rai0HojM0FtYBmaNs42A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRRNAuTnXCUNuEuYtxDWTwAINYyfx5+paJQbLjhQs82VL8HodN5qXCzvNacTtkSJ0rVp3auhrQIF95zS1PdPkKGfyM7Knbd/pdl9q0/XFYWzQeWUn9bWBJXiy6BJVS7dW8kHCZUO0JMpKFLQT5XX5wAwnbFCuG4AzooHbn1BRFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iG8ax+b2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iG8ax+b2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0151F00A3D;
	Thu, 16 Jul 2026 13:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209757;
	bh=IBVy9Uith7otCEwC5BZW8xEeGgBOCCmDq0JXoGnbBgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iG8ax+b2puSNgjv1eDDU/ZAemK3rbtB9s0kQGi2pSv5v5m6MOOxXNU1kON9fnSLLi
	 Z5x8cjtbHI4LbLHGK1+2g43PNE6d3Jl9zbPkbb8/tXoABFajdZok0r/nMgdhb2GiEX
	 aelvdr8vYXroetwRxRLoOj6SMhsb0ermlWTDocN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Xuewen Wang <wangxuewen@kylinos.cn>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.1 263/518] tools/mm/slabinfo: Fix trace disable logic inversion
Date: Thu, 16 Jul 2026 15:28:51 +0200
Message-ID: <20260716133053.574239479@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuewen Wang <wangxuewen@kylinos.cn>

commit 235ab68d67eadbef1fdbfb771f21f5bacc77a2ae upstream.

The disable trace path in slab_debug() had a logic error where it would
set trace=1 instead of trace=0. This made trace functionality permanently
enabled once turned on for any slab cache.

Fixes: a87615b8f9e2 ("SLUB: slabinfo upgrade")
Cc: stable@vger.kernel.org
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
WARNING: From:/Signed-off-by: email address mismatch: 'From: wangxuewen <18810879172@163.com>' != 'Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>'
Link: https://patch.msgid.link/20260518062159.80664-2-wangxuewen@kylinos.cn
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/mm/slabinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -798,7 +798,7 @@ static void slab_debug(struct slabinfo *
 			fprintf(stderr, "%s can only enable trace for one slab at a time\n", s->name);
 	}
 	if (!tracing && s->trace)
-		set_obj(s, "trace", 1);
+		set_obj(s, "trace", 0);
 }
 
 static void totals(void)


