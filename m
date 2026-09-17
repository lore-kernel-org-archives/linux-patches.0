Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B247E259C80;
	Thu, 17 Sep 2026 15:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660423; cv=none; b=hau8hUB/XbszrzvuE6WGltNSsu5yQ0NTQhTNwPijlfFsTrIcJ3KZ2sP0Ey0Zx3mLWlvAwondo/NyV0ahJkPIXokb3Yj4f635ccRkBf8mcgXkvCU2wvkAzZudlpwVnp02Uo02NahGERWaWhYF3IPTatPhqbGdvs3aqwl4CV462Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660423; c=relaxed/simple;
	bh=aMeittNL5is+YMZgx4ad3Fce02gfCDMIo9y7WI/O73s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmBJFRgipvpNLDs6DfkqiCK4BqHo8t9RKJECiMMFjoxKEL4SGhnhtm5T0Byz+zlkVIovNpQZxlKu2tZHcTaL3D6TZlNEIwxfhr7rl1tzRIl0KH4GiCPi5WK+v9vfFHODVkHDMuZksOZSxk/uV4u2RKCqYNe/X342TJ+uUB9r7mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiU0LCEt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiU0LCEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125AA1F000FF;
	Thu, 17 Sep 2026 15:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660422;
	bh=O31hYpD06XyVQuDrRV/7J6Tn40RqAr+WrKvWAJ37MVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZiU0LCEtKyeT8sa9TG59saing5eyYKrSwlvT+H6KQafFvMu3Duymd5iVwK9iAm8NZ
	 qJgZ24aJm1T8Bgu7mROXSx5d/uwB7bfEjsAxFVWefTe/y+VzltsHpyiOOKOjJwC34K
	 RYBBqEdvdozpWts8KFsCnk2u0RcMlJdHsVgGzrcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 588/733] afs: Fix incorrect free in candidate cleanup in afs_lookup_server()
Date: Thu, 17 Sep 2026 16:14:56 +0100
Message-ID: <20260917151407.075035749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 044d596094af4b769fb8e1173dff0d08bd68db6c upstream.

Fix afs_lookup_server() to not free an existing server's endpoint state
when cleaning up a candidate server.  The candidate record doesn't have an
endpoint state yet at this point, so the free for that can just be removed.

Fixes: 4882ba78574e ("afs: Fix afs_server ref accounting")
Link: https://sashiko.dev/#/patchset/20260729160108.2031453-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260902121024.3328255-4-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/server.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -242,7 +242,6 @@ struct afs_server *afs_lookup_server(str
 out:
 	afs_put_addrlist(alist, afs_alist_trace_put_server_create);
 	if (candidate) {
-		kfree(rcu_access_pointer(server->endpoint_state));
 		kfree(candidate);
 		afs_dec_servers_outstanding(cell->net);
 	}


