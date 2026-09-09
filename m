Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2905908B9;
	Wed,  9 Sep 2026 14:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964443; cv=none; b=WE3ASI5MR6k99XNwaZr/3E/QWpyerlAyUm0DHKxWpCfYIuirtLw1P/UGuKGvi7hekUmMbmUne3Hcrn4a7bavMFBRPxgzhoPKfDkx9rZMOSiY3NT7zcX9UmI3qZBftK3PdN78Gb/Lfgvz+Gb8JmDcWz101JlmaEtX/PGGUTIu9Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964443; c=relaxed/simple;
	bh=qWW4NYKpDEGijhef5dyE+H5kf1z5lIGIGiuwTsH3HJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sT8p8eevtCwbKalwEfzoHN9U3X5PEo+EPMiPU28MF9FC5S9InkT+SzH04SPv5p7P8TM/5+mNSCU8H1n3Un02yAaiXeL+ibjyyMGTYLJixI0uLnhqKRMm/cCaTF6YNqnaroMmZhoDNzUTGuvWmR7sWCQxbl1K/FehOIJ47MtyUHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=juf7WFI6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="juf7WFI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70A21F00A3F;
	Wed,  9 Sep 2026 14:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964442;
	bh=yI9KRM8ITqhFUcAbFA5ahFcckpUtKLlHqCy8fVei6ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=juf7WFI6q466cs45MZT9fbC8tznMrRZwXzKuopdLsUUA3PKemnw8Xeo/+Ltzv3z6j
	 ccMO4o/kHcfFZOJzPUyFUi2gs9L/4TzHtz+NmWWuO69lLRej7DJyY0gXxrsIlfFDyR
	 z0r7ZHp9kDBod98dFilxLoSQuw4wnou11eGzpY/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Deepakkumar Karn <dkarn@redhat.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>
Subject: [PATCH 6.18 423/583] afs: Fix leak of ungot volume
Date: Wed,  9 Sep 2026 15:41:48 +0200
Message-ID: <20260909134252.633790003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit d672c276f685a540ed2b2a8bafaed4650a89022c upstream.

Fix afs_lookup_volume_rcu() so that it doesn't leak a dying volume if
afs_try_get_volume() fails.

Fixes: 32222f09782f ("afs: Apply server breaks to mmap'd files in the call processor")
Closes: https://sashiko.dev/#/patchset/20260609081738.770127-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-17-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Deepakkumar Karn <dkarn@redhat.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/callback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -138,6 +138,7 @@ static struct afs_volume *afs_lookup_vol
 
 		if (volume && afs_try_get_volume(volume, afs_volume_trace_get_callback))
 			break;
+		volume = NULL;
 		if (!need_seqretry(&cell->volume_lock, seq))
 			break;
 	}


