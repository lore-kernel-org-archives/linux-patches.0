Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD9E1779BD;
	Fri, 27 Sep 2024 12:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440436; cv=none; b=HhyJy9mWk3x2hnogqMqrY1sjMWUt/TwnwitSYm9LlzNYv2t+rm8MsYllkbA2ruzCoHqJb0TLdCguwq4WendKrXkhvJExAD8o6RTnO6O7OEXgA6BP4nqyJdI4+GrO4PO/E888kKbxM/NQFYdSN4Uplj8eTWsF8quoXQ5U0hWlBiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440436; c=relaxed/simple;
	bh=q4MNYH2rBlwdyK9+QYpIeE3vZQei7zS7hy6sSDtwJ1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSYI4loJaZgk1Vm7UkauAK1SbQuRqAdWu0UodJVRdr49EHuFkH9S1NaJWHQ6EfMFL4rRxPNeYBTIRJ5eDuEobVwv4xs3Aghbuc1wcgKOIiM3RkM60Q7rGdMudNQ4YZWk0OQ8R8Ngploq3C3ExW+8xCv5kPPgLqTZWXqaUBpY9rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zanFQVBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zanFQVBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69BDC4CEC4;
	Fri, 27 Sep 2024 12:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440436;
	bh=q4MNYH2rBlwdyK9+QYpIeE3vZQei7zS7hy6sSDtwJ1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zanFQVBv1rnOwE47Po6xxVzpmdK87ome1k7azIPvyuBwJNfTiE0ezHGVc210PuSz8
	 wmXpnRXxD0NXuQsK2Se4cT3d5abJkDGDPanhPuuyl15Oelhz6zFd54geQ61nYpJ3yD
	 I4erzm6nhM5lD72KNVSdeRWmbGC0kZcf/L/TflI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 60/73] netfilter: nft_socket: Fix a NULL vs IS_ERR() bug in nft_socket_cgroup_subtree_level()
Date: Fri, 27 Sep 2024 14:24:11 +0200
Message-ID: <20240927121722.340232574@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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
 


