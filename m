Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7DF38DE5;
	Mon,  1 Apr 2024 17:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991172; cv=none; b=LwsfkITRNIT9j3nrjh9vWpEZ9SckxsEbU1WKTo824JhAUkmnHA1eSnxv29vyv9NpT4tJuIxdVzTBFgxkprvDUKqAlkrN1P+IawEdVQxaUtCWNRyU3tPgIjX0wfzueTM8LrPPNr77TAL1giiTZZUU4+EI6agZqAQAr9rxTSQtSjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991172; c=relaxed/simple;
	bh=QwFlYzAdXAaUOmTtR1BI0EG2fmzJdmGbpaA/8kW7b9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVOAcutUHp3TYt6jhLf84AFpSUGmoJPK70MYGd7yAnXWFrHtZcSSCXVeCai/n5wZx+yV2YSVn+hg/jyiG0lhLCqAk+axJ/pCMrLFVymMTQ98rEUQvORM/y2SgfDm2ZC2JC6Wz1ehDwel8w0oVVAUADaKis+tMQrRf48ONUZe9FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRrKvkMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRrKvkMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6ABC433F1;
	Mon,  1 Apr 2024 17:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991171;
	bh=QwFlYzAdXAaUOmTtR1BI0EG2fmzJdmGbpaA/8kW7b9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRrKvkMhtDSvlu/7TlE8N/Ogi3Uz55SGSTCC715ecawWRybugaCFdmX3HwRmPnJCE
	 OxRAYBiV3KK0NQ08jcdsnzH5QdiCwtCpA6op6utaXYn9gdy64xobGIE5MAy1ACfOrA
	 rRp+B8mveqeI9yXVaHqjUM8X/HmASkwFX2l+whls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lonial con <kongln9170@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 146/272] netfilter: nf_tables: disallow anonymous set with timeout flag
Date: Mon,  1 Apr 2024 17:45:36 +0200
Message-ID: <20240401152535.256656155@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 16603605b667b70da974bea8216c93e7db043bf1 upstream.

Anonymous sets are never used with timeout from userspace, reject this.
Exception to this rule is NFT_SET_EVAL to ensure legacy meters still work.

Cc: stable@vger.kernel.org
Fixes: 761da2935d6e ("netfilter: nf_tables: add set timeout API support")
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4711,6 +4711,9 @@ static int nf_tables_newset(struct sk_bu
 		if ((flags & (NFT_SET_EVAL | NFT_SET_OBJECT)) ==
 			     (NFT_SET_EVAL | NFT_SET_OBJECT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
+			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	desc.dtype = 0;


