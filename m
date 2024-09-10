Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BFC18C33D;
	Tue, 10 Sep 2024 09:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961246; cv=none; b=u61hTKYZS+6EfCa+Ky1PvoKojcgm6t186WsQAfUXQ/PL2/Tkjq3B19ETu7XF/iEIGNkfZ6xPpAAqic4jwXvQwjKiySAoYt5r//iJDRUGbVSx3G9cdToisl1y9S8MxeFS/LJJzE05yd9bdsYUJOyrtcbymcYn0gScG2xMstLp83E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961246; c=relaxed/simple;
	bh=wWgp9fi5HVJHQjwlOorlnJSSZhKIlUvbI7fkRwT0pyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZUsZjOoJ5PrrP7C4QFBJ9ewnqKoZvyJEGyM/LieVeC76Xxxnm1IpHl5pRZSyDj09no/wtDokZRwbD2ZP+UPcFWS367dhD6+R+I51c02+qiR0btnLXwQBjWYdt2up7dEpHJHoAUggfndeRX/EOWWVaRqaZjpK0Vg8RpDUwnuYSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyjcQEvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyjcQEvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5277C4CEC3;
	Tue, 10 Sep 2024 09:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961246;
	bh=wWgp9fi5HVJHQjwlOorlnJSSZhKIlUvbI7fkRwT0pyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyjcQEvdyy5XsNlplNyVAqwMTtp6FHHg7dzUHwIOV2dA84mU9xNQIGqXdOXzxDLOs
	 qNTQJ+1oAyP6w3Kz5C5i/irF4IqaYNv2NsV8iNpjdY5ZW/AkUj4KfWxcgNOatyXj4y
	 elqjZkl6XQWuBRbGgNi2GW46qyF2uugmLsaFLaBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 95/96] net: bridge: explicitly zero is_sticky in fdb_create
Date: Tue, 10 Sep 2024 11:32:37 +0200
Message-ID: <20240910092545.712352624@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

commit 1288aa7af20cfa25cb00cf0d77f94d1891644c83 upstream.

We need to explicitly zero is_sticky when creating a new fdb, otherwise
we might get a stale value for a new entry.

Fixes: 435f2e7cc0b7 ("net: bridge: add support for sticky fdb entries")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_fdb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -512,6 +512,7 @@ static struct net_bridge_fdb_entry *fdb_
 		if (is_static)
 			set_bit(BR_FDB_STATIC, &fdb->flags);
 		fdb->offloaded = 0;
+		fdb->is_sticky = 0;
 		fdb->updated = fdb->used = jiffies;
 		if (rhashtable_lookup_insert_fast(&br->fdb_hash_tbl,
 						  &fdb->rhnode,


