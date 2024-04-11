Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE461474CA;
	Thu, 11 Apr 2024 10:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831768; cv=none; b=eKMXaBiySmTaY65ZqfYEnSmA/gtR6cPEX+Oc9d+KN2vTwB77r2in7HshUfwlgCPQDfKCtKGZ+WOfaGP9VmMvjbioBymF6RJgcE/Wh/czTl4u3orA8j21ICO1Ri6Cwuzzz0dl+5Y4h0d9BSPmsreM0VOyvbMMGcRRt0bUWHquT8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831768; c=relaxed/simple;
	bh=KZPf1wKXeiKemhenhPmub5r4HAau8r8SOSrZzhMxWl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrkbJvH3FcR5wU5TURCCwKU8AQ+jscOXV4QPmRT8AdNdqemt75JDUgOvGRy1A/fuGOmTRF3wK23slUfMM7IwJBC4K3GJpJke5+O0CIe9yw7oWegReWxTXkVtowZVgSyywM9XxUcLV+Uuh0S/Uvt8nWYsabQh5BkILQ6V43i+pos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAL2wSVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAL2wSVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D45C433F1;
	Thu, 11 Apr 2024 10:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831767;
	bh=KZPf1wKXeiKemhenhPmub5r4HAau8r8SOSrZzhMxWl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zAL2wSVesJzQeDbImNKvcHUqSqzeWb57H0aQEHzmkExsn5PDkmH4Ccg3G0VX2nB9n
	 Vhx8qfE/FMz+2Okrxc9+AOKzlZ08WRNy3FWYk3FOANkSuPzPvOsbSED5aRmYQ3QueZ
	 wt6Bxk9+21BSNQQuPcHrui2AaqOK4v20dmZl75iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lonial con <kongln9170@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 120/294] netfilter: nf_tables: disallow anonymous set with timeout flag
Date: Thu, 11 Apr 2024 11:54:43 +0200
Message-ID: <20240411095439.278694178@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4410,6 +4410,9 @@ static int nf_tables_newset(struct net *
 		if ((flags & (NFT_SET_EVAL | NFT_SET_OBJECT)) ==
 			     (NFT_SET_EVAL | NFT_SET_OBJECT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
+			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	dtype = 0;


