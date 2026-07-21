Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7C7431A5C;
	Tue, 21 Jul 2026 19:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661904; cv=none; b=h/TLzDShtOPQQweufvBMY29RqThyK+xrnqO+Mk/zwpYSJyAZYIiBW56SsMaLdlGBkhN+8KKfr8fNjRRDeGMEKOC4w3jhs5k2B5crbhZ9iWySASVzj3XclE5EthsQviOJaJja5noi0JabBwez9QB9RgCvNgQipzOIdF4OyLtWG6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661904; c=relaxed/simple;
	bh=i4oKB0onpHsxIHPqT2JhTBVM21HRs3M+aIPlkIuWaKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDORW61ZWQhMbTBEnmJGVz0U3e1LQ3hYRqPbNp9cAdd9OoBjJdkIPHTr52fBpWr73w4gDCHPp3BJ7Fh5VOj8AboEr3qY3O2mTDMBMpDRurAHucGp0VrEvApskPwh0ynFvfbGKkSSQthlzUjfMUxKyq9TT87uRrTis026MADp6Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdTvBIf3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdTvBIf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681DD1F000E9;
	Tue, 21 Jul 2026 19:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661902;
	bh=EnZVXLx8qDuNAhWyAen1Oq3u/c5yw6g6zfW5sSgOCLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdTvBIf3/87X0yLogp6pUznsy6nFDRc586+VqfMltSJDXMiM/g7/+CwL8DQjrxutF
	 XLRbPVJ/mJbZRanDvNaBp+GtlJPiJbXVGeNW4ubV9O8/9wsui8XGe3Xp5S38raPvHo
	 K5jU8dfYyhdr1ZYC8ekWUWC7nRglSnWe4FZKJy3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0243/1276] netfilter: synproxy: adjust duplicate timestamp options
Date: Tue, 21 Jul 2026 17:11:26 +0200
Message-ID: <20260721152451.527804282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 22bb132cfb9b94847d52d73614284b8c5ea8d36e ]

RFC 9293 does not mention anything about duplicated options and each
networking stack handles it in their own way. Currently, Linux kernel is
processing options sequentially and in case of duplicated timestamp
options, the value from the latest one overrides the others.

As SYNPROXY is modifying only the first timestamp option found, a packet
can reach the backend server and it might parse the wrong timestamp
value. Let's just continue parsing the following options and in case a
duplicated timestamp is found, adjust it too.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_synproxy_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index a90511238ec378..3c021fdec2b574 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -232,7 +232,6 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 				}
 				inet_proto_csum_replace4(&th->check, skb,
 							 old, *ptr, false);
-				return true;
 			}
 			optoff += op[1];
 		}
-- 
2.53.0



