Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48407BB0C;
	Mon,  8 Apr 2024 13:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582197; cv=none; b=TfGts4Lo4eAgSu/21LEbG/j3xurSs60TMOoAYrF9RiD3vzPf93aWfAsPOiifPlQ4IhLH27Nhy+xAyzfC7dY8g8kWZATLaVmzHa6Ng+y3j/CPL8oemb7arYnyQjDPB18MmOxurCTgjwjI4GCgRDrCYr65cU+pTdc4zuTtkQBdmtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582197; c=relaxed/simple;
	bh=R53H/n4fI4G1TdhtXLRUPSmpSr7hLl1YLVIitmjPtrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxx84yxw5JOH9MGI3ypZiab1g4anSyNSn4CNHXVchpO70aoMJoF+BnCUsVchApMUqsfYskyOWtiJIkyEWQBr/lbKBqjkpXoiWbfEkcOL3xBe5YuWG1OnV6Z+bt2k9DwQLUHw68836e3rKx7BW5pOjMxCXnbPH+4uC5FyhnrkXOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3QHQIyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3QHQIyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03165C433F1;
	Mon,  8 Apr 2024 13:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582197;
	bh=R53H/n4fI4G1TdhtXLRUPSmpSr7hLl1YLVIitmjPtrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3QHQIyBJtK2MXdAiN9qXuHaHN0LwDykrDBk6Udw6tcrtgsUPJFOOzjLONpYMKfEl
	 8kDTzIDNi11fDvrhqtWI8jNvlLyusaSpoSM+z7mNfAhlZQUdox1GRbNDL2QYMk7+m/
	 SdggJ3f1qCVcZ01qfGR+tFby3Y1XN15JSbSwaI8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lonial con <kongln9170@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 119/690] netfilter: nf_tables: disallow anonymous set with timeout flag
Date: Mon,  8 Apr 2024 14:49:45 +0200
Message-ID: <20240408125403.853776157@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4641,6 +4641,9 @@ static int nf_tables_newset(struct sk_bu
 		if ((flags & (NFT_SET_EVAL | NFT_SET_OBJECT)) ==
 			     (NFT_SET_EVAL | NFT_SET_OBJECT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
+			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	desc.dtype = 0;


