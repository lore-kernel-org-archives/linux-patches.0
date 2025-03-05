Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BF5250C1A;
	Wed,  5 Mar 2025 18:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198533; cv=none; b=u/40QYlCMw2V/33trImCZ7u4ndnxDyHqezsLtQ8hxUpss9996gEKgCBop+dJZjNdqEqAfeGXRAX8gaxglxOWTrirClrAR5cukVU4vpQNUzBkrbxGAG9bu6OgoU+wYGT4evOb2M5HgeD24yjx+THVE6h46hka6pP9TxVX5G0qvoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198533; c=relaxed/simple;
	bh=kAsz5/EkcuRLwcmkMomTYeKaLIyByt79DrvoUWAV2VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3vFNW7cNSo5gTN2t1Hu2AtSKV2dqX2BLJyM4BlDQZaxxkGLUVGJehwgZzB42XcLOr3Gho/LlEFATLyQCERqABoa40jtjxdEkgg16EgEyZpA77WFgATa7fraDfaKuIhi6r06NA0+qNWvPo09WBUbU7ccv5uiZAKeJq3UL/nMgOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xji524+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xji524+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9A1C4CED1;
	Wed,  5 Mar 2025 18:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198533;
	bh=kAsz5/EkcuRLwcmkMomTYeKaLIyByt79DrvoUWAV2VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xji524+bOABYkDqMlIutMTYVKZQYPKoldX0oU+2j3UXF5triW1gCu6m3Eo6ck8SBT
	 DNwlgmE40OgvWmy2ghmdQQe3RWjGHqgnyujm3graT11OVxh85Vs7G54P7GL9CifdqD
	 uOm1xYqgcOkI6YI7DsNIbb+9WSoBDIdnhnXcbTxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 028/157] afs: Fix the server_list to unuse a displaced server rather than putting it
Date: Wed,  5 Mar 2025 18:47:44 +0100
Message-ID: <20250305174506.423854582@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit add117e48df4788a86a21bd0515833c0a6db1ad1 ]

When allocating and building an afs_server_list struct object from a VLDB
record, we look up each server address to get the server record for it -
but a server may have more than one entry in the record and we discard the
duplicate pointers.  Currently, however, when we discard, we only put a
server record, not unuse it - but the lookup got as an active-user count.

The active-user count on an afs_server_list object determines its lifetime
whereas the refcount keeps the memory backing it around.  Failing to reduce
the active-user counter prevents the record from being cleaned up and can
lead to multiple copied being seen - and pointing to deleted afs_cell
objects and other such things.

Fix this by switching the incorrect 'put' to an 'unuse' instead.

Without this, occasionally, a dead server record can be seen in
/proc/net/afs/servers and list corruption may be observed:

    list_del corruption. prev->next should be ffff888102423e40, but was 0000000000000000. (prev=ffff88810140cd38)

Fixes: 977e5f8ed0ab ("afs: Split the usage count on struct afs_server")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250218192250.296870-5-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/server_list.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/server_list.c b/fs/afs/server_list.c
index 7e7e567a7f8a2..d20cd902ef949 100644
--- a/fs/afs/server_list.c
+++ b/fs/afs/server_list.c
@@ -97,8 +97,8 @@ struct afs_server_list *afs_alloc_server_list(struct afs_volume *volume,
 				break;
 		if (j < slist->nr_servers) {
 			if (slist->servers[j].server == server) {
-				afs_put_server(volume->cell->net, server,
-					       afs_server_trace_put_slist_isort);
+				afs_unuse_server(volume->cell->net, server,
+						 afs_server_trace_put_slist_isort);
 				continue;
 			}
 
-- 
2.39.5



