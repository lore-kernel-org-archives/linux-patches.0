Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF72145B04;
	Thu, 11 Apr 2024 10:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829688; cv=none; b=Qk9jwTGwIPKtFze25+clS3u8c/wE/zHzjQ85hAERjaM/mydnvZdUE9lH998oR6x/1cwgiWTrZEa8sIEgDeG+5JuFcJyEiblFMu21R3eNUVgK6tP9R3mkRGh5VaMPR4C/Pbr2ydMBLFc/5jpA2r+4SlqiwBDJA8Q2EAbDSqWmJvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829688; c=relaxed/simple;
	bh=jFwLcx3x4A+zRQbraawYb0h6Jp0XCku5aKe7B47klQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+u9UUAxnXFHPDWAPdKME51RehH6a8lZd4u3Kc8CasT91HazfL93iPJfzSuHt8DHhxxcx3qvnoWuKmPGXxDlq743Mvd0/uRxJF9YXsvFgyEv3zte0xgzKqEs8Krl6xBTz2o0Ps4UgP5X6Vy7hgYPR7fmjLZQ4IUkH78Qc/D54Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxgni2fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxgni2fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E0CC433F1;
	Thu, 11 Apr 2024 10:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829687;
	bh=jFwLcx3x4A+zRQbraawYb0h6Jp0XCku5aKe7B47klQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxgni2fwRq5tEhvOndReIsMGDz067OomfzysnbQanwcmVS/Du2bgoEg6BWT4YjQsv
	 ROpxIRdV5ONGN6AH+57XLzfMOKMZqLXotBnb62VSsX7osgmOcrjrtjXVvUXDDPiGFj
	 +sOUdnzXs9DrOSWjG1rOhhZDn88mcM7dmAEFMzz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lonial con <kongln9170@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 070/175] netfilter: nf_tables: disallow anonymous set with timeout flag
Date: Thu, 11 Apr 2024 11:54:53 +0200
Message-ID: <20240411095421.672564016@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3560,6 +3560,9 @@ static int nf_tables_newset(struct net *
 		if ((flags & (NFT_SET_EVAL | NFT_SET_OBJECT)) ==
 			     (NFT_SET_EVAL | NFT_SET_OBJECT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
+			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	dtype = 0;


