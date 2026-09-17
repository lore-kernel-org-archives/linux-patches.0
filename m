Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A844B44A3;
	Thu, 17 Sep 2026 15:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659293; cv=none; b=uD3UoKE+rsUeXn2Hz4kIQjnk5LFDDcjnh5M2ipcThDB9cRtss4KxQ5M+0sJR656GatquakLVvnZkPKHI8VWTw4qHO59nTVJEqoAZWGOUVV58tsZIJOcn9QYSWqSREfGJ1pIHn1+BjOJ5vC57SX/Sl92JJaEUogj244X/s8rAKLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659293; c=relaxed/simple;
	bh=5vsUMp57d3nqPzVM8wdV8Yzcmi+b0+hoTtxQPQfSFJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxIrUPq/K62RzBk4eu6jd3gcir3CHZU+lCKnYGxcC1QisTxseY8MWU1SwY/uJcE1cPVJXvdcojNi4yGB1CqZCl0w4trLlbHrNgDfPYFWdSI56g2IlgjiAGV7FwA98N+qx8EG6wIPvNDDGcuizR8+LCFrk5lhK0NOOcAOX1KhhMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0DNfGTHU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0DNfGTHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179FE1F000FF;
	Thu, 17 Sep 2026 15:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659279;
	bh=RSdxzPuCNHo/jqcqAAcAv/R4b6LtyDgFkElUaDUvbmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0DNfGTHU/TPuMMkwrRFbNs7fzdyMi1eSWD60LsvPDvRRt45revmNGtlu3tlW3laNA
	 bDsu6FP8KyRYVaWFA8rTKAZ7LU9q/MHhHNgUj5hdlORaIJEznDGPHLEXZvCPsgQ8uh
	 4+Kuxex9YacKQqakp+zfm592m6Yf2k3lQ/36NouM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 201/733] netfilter: nf_conntrack_sip: fix OOB read in sip_skip_whitespace()
Date: Thu, 17 Sep 2026 16:08:29 +0100
Message-ID: <20260917151356.179070439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index e4a70d1d77b0b..4fb33b5e9a85a 100644
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



