Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635C64B44C4;
	Thu, 17 Sep 2026 18:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671106; cv=none; b=uenHcuFEW+riS7bc4gH4zsfIS5HK4SPpZOM8wFLxa/MHu5PwdsahPSIiX7a4lJ7XlxdMSrzx6MxvcAwbjGgrO7no66uSqMqy4qDcfku06sg/2j6KPZB9xxSwR100CjYBMDem8xt3AZzhME5D8qVQpWB3Hwhhwk1DyivQAAoIsJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671106; c=relaxed/simple;
	bh=/U6tYkqyTy1GhCAYUmvTT6ATpz6cRT5ZgtsoflMiZCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZivbQbD22lh91XHzPt6dq4+fBeEFrIDPcd0V/kWVpCGKWyD8+DI476Mth9VGDgCcYfnSLBjV907dveUUWQdyzmDhXQwRUn7QZasauxsWTYJySKjbDkPEOxmWhW8Knioe1UMeeh1moDtgcnvGsKqHELFvEprK4xUhQOu0J+mJLDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VofvtApo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VofvtApo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63451F000FF;
	Thu, 17 Sep 2026 18:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671105;
	bh=Lj0LMgTtt+osem8mNMcd2tUw8wBDK0PxZPwdgNixz5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VofvtApoodJcnpBUg8gKMSP1kTo8JKmrdxfkH8RLpf4qK0iGn37r2DZCBqHo80k2S
	 WNZOR9Xcr/0iuTDmJpgr3NFpxiL/jRNOEfTQj/QeSK2ri2BFOAOXctxi5HR9r8t03G
	 iUGUbso8muxwH6MnuHC9hkgJ4g69NiFz8yeSYqiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 0868/1102] afs: Fix incorrect free in candidate cleanup in afs_lookup_server()
Date: Thu, 17 Sep 2026 16:13:31 +0100
Message-ID: <20260917151602.348171222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -241,7 +241,6 @@ struct afs_server *afs_lookup_server(str
 out:
 	afs_put_addrlist(alist, afs_alist_trace_put_server_create);
 	if (candidate) {
-		kfree(rcu_access_pointer(server->endpoint_state));
 		kfree(candidate);
 		afs_dec_servers_outstanding(cell->net);
 	}


