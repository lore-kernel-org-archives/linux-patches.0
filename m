Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823171DFF4;
	Mon,  1 Apr 2024 17:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991072; cv=none; b=NlttyYmTg6tVyuk1tvNTfX/YPF1aFCaqPoJX/AFYNNJdnX1k8kihJmCcsOQYofQ/YUNgXBD9Lreg/IVfslXgsDiQ4HwJRacICF/OVTfK7gNHsra5t5Wcz/8a5bam4oyZWSeRODBWB4DwjIylhA2SUnZBQFmEBInowt+pJ1v7vFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991072; c=relaxed/simple;
	bh=tQG+erPG1tfdWOZF618qcPwT+IvfeamiRGpflMBWDnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j38FO2mNOTUco449aBkA/1JP9EugsgJL7v1KRFCn/8kdpq2d4mkt6MgGXKqJFHRVWFA4TgpGEOI1a0UNhN4P9bwWD5SCUuN9b8e5qPLTJ79mgnuLwQh0/7gkFkJVsBZXUXFTqGu0hbvU8MgylFaByDGAnONYtMvsHncGkZpKkzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulRFuwV+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulRFuwV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3EFC433F1;
	Mon,  1 Apr 2024 17:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991072;
	bh=tQG+erPG1tfdWOZF618qcPwT+IvfeamiRGpflMBWDnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulRFuwV+WgkVHTy4W+FwizU16c17fIlmAQqacKEr3inkTMOWDZChqJLjUim/u4ymC
	 zJt1kmI/zg1noJaTY+Gk+zxaVz6j0I6p05GUw6Iz7/lc2Sfd2U/j+/1xSX5TYza6pV
	 X8Vd02Cw8dR3eNRxx05Vv+VWxbjfOwJ8ix14Of+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 147/272] netfilter: nf_tables: reject constant set with timeout
Date: Mon,  1 Apr 2024 17:45:37 +0200
Message-ID: <20240401152535.295732040@linuxfoundation.org>
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

commit 5f4fc4bd5cddb4770ab120ce44f02695c4505562 upstream.

This set combination is weird: it allows for elements to be
added/deleted, but once bound to the rule it cannot be updated anymore.
Eventually, all elements expire, leading to an empty set which cannot
be updated anymore. Reject this flags combination.

Cc: stable@vger.kernel.org
Fixes: 761da2935d6e ("netfilter: nf_tables: add set timeout API support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4714,6 +4714,9 @@ static int nf_tables_newset(struct sk_bu
 		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
 			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_CONSTANT | NFT_SET_TIMEOUT)) ==
+			     (NFT_SET_CONSTANT | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	desc.dtype = 0;


