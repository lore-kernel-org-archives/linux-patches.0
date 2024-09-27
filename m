Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B9018A95D;
	Fri, 27 Sep 2024 12:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440184; cv=none; b=djt0IFaBs6sKEpP+97njJbB4Y8g4YsVJ/mbDIBylZnMZ8SbDyUdF1avGsi4pdWXkYfwjMGfIQDo0UfXGXOC3Fa1VEjKZKG+FUxDmODNErMaLBPn3DbJW2S7+IPIErzY4/UZG+Ws3CHcY7jP6Mi2GdUqBLNynrm/69SosgfmcC4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440184; c=relaxed/simple;
	bh=Ok5/FAiZoR0VEQ7q6Vhp9Q83Mnykclf49bYV2aCWZKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9FwpcsjUYjbXKEnk7A7Gj9vUmyRIcnfAR1f9roY7wnhsxl4lcDZKnl5pK7jUoh4A/CFfio2IGoo5gflPXm7jWAXi0cuWrMpS9uIY8AwgXhjHwUEgegNorx75n8BmMYHOEZSyQJIHe7O9vz33VSsyNMOa/OPRBwjiBp8ThEFloM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dzm0moc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dzm0moc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8DEC4CEC4;
	Fri, 27 Sep 2024 12:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440183;
	bh=Ok5/FAiZoR0VEQ7q6Vhp9Q83Mnykclf49bYV2aCWZKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dzm0moc9Q+EN2Wwb/eoaQQn25GlT9TyqAT4FVNlyvM6JqtJF8kIeiHDuFbI2IPld3
	 6+wYcucpfEky5wcHY94eAINnHqmhfxlHOH48zUz7sjYLB3iwasxaw8H5NvqwGndzBi
	 QMrq4YJ5onvZJqae0DnHpjt0MPauMs66DeYM45ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 52/58] netfilter: nft_socket: Fix a NULL vs IS_ERR() bug in nft_socket_cgroup_subtree_level()
Date: Fri, 27 Sep 2024 14:23:54 +0200
Message-ID: <20240927121720.949712124@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 


