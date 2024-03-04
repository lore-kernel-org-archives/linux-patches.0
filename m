Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEAC1C6AB;
	Mon,  4 Mar 2024 21:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588738; cv=none; b=ic6PLmYFuPg0Y5lD87Kw4CRBnvJW3q9yznXlxAJbJiC+8LKdHXBZ+hC5MFGdUSES1ZUqY5Lwd8pL1ZkvrWAvlwmfCGVIs5l54b21JZWOUWVAMgepSY/41kG4BRjBe3LVOVidYdaE7mEfJFDYB6m0RHspClNUhs2PzyZvVb93llA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588738; c=relaxed/simple;
	bh=E0ei835/19lXr7J/XjNBFvErOnG9KwKJkQ6tbsw0DVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xgn4gJBWe8CCSarcg2Cl8DeSkkIrsIIKdh9GmcdJ6SJlxqmFTBHk0NT4tkUGgI8rDTglbIUSlNXifc6yzy2pZQhXyD3X3yNvbt91E6Oo2bo//kSa9vw1pEJ+uSZA8iG2twCgLGqJhVRs5wx5ecvkFhqaexJTF+G1q6R34Bpw3As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QO9oOYNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QO9oOYNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A752FC433C7;
	Mon,  4 Mar 2024 21:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588738;
	bh=E0ei835/19lXr7J/XjNBFvErOnG9KwKJkQ6tbsw0DVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QO9oOYNOCkil6MnuIC6faq8QdejT7/sxUCAHM4eH4yeiR9HWkdvNJsOurDBCsDLhT
	 NdxHQb8vW1YoOtjxXSAFV2Co5fXpcXOFs0UNbfIpTew68KfFfeR/5zWy+QlRHOpzKc
	 vNUWVXDhJ8Ug0PiU+v77DwBJG74yW3gMkaC8HUA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+dd4779978217b1973180@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 078/215] wifi: nl80211: reject iftype change with mesh ID change
Date: Mon,  4 Mar 2024 21:22:21 +0000
Message-ID: <20240304211559.455882776@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit f78c1375339a291cba492a70eaf12ec501d28a8e upstream.

It's currently possible to change the mesh ID when the
interface isn't yet in mesh mode, at the same time as
changing it into mesh mode. This leads to an overwrite
of data in the wdev->u union for the interface type it
currently has, causing cfg80211_change_iface() to do
wrong things when switching.

We could probably allow setting an interface to mesh
while setting the mesh ID at the same time by doing a
different order of operations here, but realistically
there's no userspace that's going to do this, so just
disallow changes in iftype when setting mesh ID.

Cc: stable@vger.kernel.org
Fixes: 29cbe68c516a ("cfg80211/mac80211: add mesh join/leave commands")
Reported-by: syzbot+dd4779978217b1973180@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4137,6 +4137,8 @@ static int nl80211_set_interface(struct
 
 		if (ntype != NL80211_IFTYPE_MESH_POINT)
 			return -EINVAL;
+		if (otype != NL80211_IFTYPE_MESH_POINT)
+			return -EINVAL;
 		if (netif_running(dev))
 			return -EBUSY;
 


