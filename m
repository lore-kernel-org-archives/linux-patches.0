Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4422C18BC1D;
	Fri, 27 Sep 2024 12:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439978; cv=none; b=MK0wVC6NoFt1dCvuhpRSDcfhdfF397GSoj8STuLVmeg5hoYORmDOERJtmFK8icSyF+i0ywHJ8pCacl6+VAxi6kIh8FYd1kmenWumgV4ezl22dcBDWkly9qUZEyWNIXtDqMbhjVpQAg51ZSKQSHRPbiBKK16ELwaY2j3g2V6s6B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439978; c=relaxed/simple;
	bh=GDeR6F5rZAzuofEBcDy3FUfmRBYD3XrXsflsIKUNvLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zlgbtm6sZksgIZ+apMqQu8z8spsU7h5AkNt/aSv3JMNZ8aINKOPEnzcV0XclL+YbVKvk+M1Jewm/uzu1j44WOAnqQEX0YcuvrTdpPtysXdmr7GPiwX1SlgsmleQ/C0DA+COchASMoXZjVOvCL6p5IoFIJLcj3+KDIbhYkKBwS18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dwstwC2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwstwC2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D60C4CEC4;
	Fri, 27 Sep 2024 12:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439978;
	bh=GDeR6F5rZAzuofEBcDy3FUfmRBYD3XrXsflsIKUNvLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwstwC2lhQ3FnznYgV52Ar2FZrH/34v4m2Z4kYSKFIgK5tG7cn1n1DVSmdqQx3BtX
	 qj1Kvz/eiOVvMzXDPQ0hJOn27/ZsiFJhU0mv5v9woifjpPWgXu2y+Zy3m7XyRhUdXB
	 wpXzqntKF/9tmE+FfbBolk0C5QKN95Tm6KQHybzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 44/54] netfilter: nft_socket: Fix a NULL vs IS_ERR() bug in nft_socket_cgroup_subtree_level()
Date: Fri, 27 Sep 2024 14:23:36 +0200
Message-ID: <20240927121721.580894857@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 7052622fccb1efb850c6b55de477f65d03525a30 upstream.

The cgroup_get_from_path() function never returns NULL, it returns error
pointers.  Update the error handling to match.

Fixes: 7f3287db6543 ("netfilter: nft_socket: make cgroupsv2 matching work with namespaces")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Florian Westphal <fw@strlen.de>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Link: https://patch.msgid.link/bbc0c4e0-05cc-4f44-8797-2f4b3920a820@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_socket.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -61,8 +61,8 @@ static noinline int nft_socket_cgroup_su
 	struct cgroup *cgrp = cgroup_get_from_path("/");
 	int level;
 
-	if (!cgrp)
-		return -ENOENT;
+	if (IS_ERR(cgrp))
+		return PTR_ERR(cgrp);
 
 	level = cgrp->level;
 


