Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9474778B;
	Mon,  1 Apr 2024 16:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987295; cv=none; b=GnRvHwvGjE6zLvyMUaTOG5K+nzP3UQParRQuzIKZZ7kxwWfM9Qrc2dB/+L86wUwSBqCaxtXGVFSaWuNj6Uvu0FL8Y9QtlAhFJE77uZCtv2DEFzpvPrfRtHjNt/rYcGmcI8aiOrCALZvxB98UMgk95mOOgCaumL1FzGWtx6M4Jew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987295; c=relaxed/simple;
	bh=+YmwNC5Uz3ynLjd4RiutVONO5j6gDq7Lgyo2WMBJ0oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bB9lKPxfutwlouKWvbpjCo0C62/rRMPCJXX0kqWnZcKB8+KKfxjjuGidDsR/xvG8MC8xDTYuRf4F50O1GXGEcu+GsGxH/xoc4uA41CvHhFE/DJYR3eC97fUt53HzOwoG02Ln/rm71IEwfvtqXGpOhkGCeUHzjMCQc+e4RQcqLzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeqZvEsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeqZvEsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CF2C433F1;
	Mon,  1 Apr 2024 16:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987295;
	bh=+YmwNC5Uz3ynLjd4RiutVONO5j6gDq7Lgyo2WMBJ0oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeqZvEsPi/2kMSKcHxw2MQ3r3+tEwl4PIbZKQ+bonEq2pND9Wf57CQvH2qv/Yag7p
	 R853v4sEQMUYFy2P5h4fOt2/vxFFlXQpucRH7aCSOWAY0nGQuuIQph42eBnFhYkYK5
	 YXbpKUFAN2xe7/mFby9VEIIHhVMGNJtySyf5pFbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.8 244/399] netfilter: nf_tables: reject constant set with timeout
Date: Mon,  1 Apr 2024 17:43:30 +0200
Message-ID: <20240401152556.457740877@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5008,6 +5008,9 @@ static int nf_tables_newset(struct sk_bu
 		if ((flags & (NFT_SET_CONSTANT | NFT_SET_TIMEOUT)) ==
 			     (NFT_SET_CONSTANT | NFT_SET_TIMEOUT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_CONSTANT | NFT_SET_TIMEOUT)) ==
+			     (NFT_SET_CONSTANT | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	desc.dtype = 0;


