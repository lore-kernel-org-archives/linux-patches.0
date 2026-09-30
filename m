Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D7F4C33E6;
	Wed, 30 Sep 2026 15:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782948; cv=none; b=tDUmVo7QOpgD+WwtumptbefPO4DD+IQg89Ny3DuSlICp4M+8jwaboQ4afQBl0PCmxOfw3rewrEL6oZfRcyBcAhowvGROwiDuDqPo4kgyqdcyzSexTpF+krzrAxSVQadlH93CAblt/xxWNg+isvH8OanZI3s8oegUp7HMg1MyJEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782948; c=relaxed/simple;
	bh=bvCTJa19C4MfTKbFdhCEAANt2+AGqMxBIGN54YRr+1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OET74aJVUXQzjpa1yzvyLZAMVD3+esg2mayefkTMM36I0IFoRHaIOr7L1UZIlHxNuie+aprHeiD1hXbvLhO15zWHaM9VsifHuG+7SOCIL1XhFCLNrCVy9OBPOFsDUNQVOeK91gCI4cfnn7iMhsWt9wyFxJsj1sjut51kwD49d78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBe59GD1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBe59GD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77761F00893;
	Wed, 30 Sep 2026 15:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782942;
	bh=pQTq74Pq/waIu6CJKNMEoma6nFTXIXHFGOLe9vcNbrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CBe59GD1DlcJLqVXaQZRqpJvxvUpV288G8WldNYlt2pew603rcb2Pky9CKlY9dSmU
	 cgoTOd/zl+/GWXcnSfMjgxDDG4cvBpjiw28sPTmxflBZFS4YQxBoUP9JuBaIP/AaIc
	 7aeogU8cYV3G7+eeJ+alpSbp8Py6VTIHXqPeZXUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/595] netfilter: nf_conntrack_sip: fix OOB read in sip_skip_whitespace()
Date: Wed, 30 Sep 2026 17:21:58 +0200
Message-ID: <20260930152352.566437375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit e8f8231824b5815f57ce62cba116e511b10196de ]

sip_skip_whitespace() returns dptr unchanged when its own loop
exhausts the buffer (dptr == limit), instead of NULL like its sibling
sip_follow_continuation() returns on its own "no more data" path.

ct_sip_get_header() only checks for NULL after calling it:

  dptr = sip_skip_whitespace(dptr, limit);
  if (dptr == NULL)
          break;
  if (*dptr != ':' || ++dptr >= limit)
          break;

so a recognized header name followed only by spaces/tabs running to
the exact end of the SIP payload, with no colon, makes the very next
statement read one byte past the buffer.

Make both "no more data" outcomes return NULL, matching the
convention sip_follow_continuation() already uses and that both
existing callers already check for.

Fixes: ea45f12a2766d ("[NETFILTER]: nf_conntrack_sip: parse SIP headers properly")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_sip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 7a9c07fff57af..44b21e1802412 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -429,7 +429,7 @@ static const char *sip_skip_whitespace(const char *dptr, const char *limit)
 		dptr = sip_follow_continuation(dptr, limit);
 		break;
 	}
-	return dptr;
+	return dptr < limit ? dptr : NULL;
 }
 
 /* Search within a SIP header value, dealing with continuation lines */
-- 
2.53.0



