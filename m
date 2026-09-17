Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C465B50276C;
	Thu, 17 Sep 2026 17:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666493; cv=none; b=QUqtbyLLduUq+TrQuNnUh07WB/TIHiar28tXHroQlN/56wqYpj+Kz4SZEEjtHziQhOZj4Bv5PJxKiFS39RSqMVJYKU2PnTpOatSfXlS96E8Lax66f7plU4BV705NuwYesfzR3RBCeRKbB19wiZdc2nIq1RR7thPW8wXIALJ+Yyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666493; c=relaxed/simple;
	bh=qazuUqveb0X+65LVkAUtlpoP68qHoe+0M/2mwvqqjy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPrBlfCnkmp11cNvydAjtoNeKZTX624KEuSofj+PGdepBZ4U+BGul4gZh5g8eBUa66JMlpDWlrc2Eom27vkjDFpNH7XS+4YUF8Wf7HkxE8urcmBScL1pbA2FnHDzyHe/LRpi/q3jSE4X4taFPfHLQQYw+jJ6sv3k6M07UJ5KHK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iiuk5Ssr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iiuk5Ssr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243A61F000FF;
	Thu, 17 Sep 2026 17:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666491;
	bh=3O6VLDXLUdm4fxcvkmTeZPKPMLUBsRr5GB+qz0d8UIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iiuk5SsrafuPzCyWbZstebV883URmXooN0gTodsBG5IwpjE11CzElfLAp/StfWSFv
	 d6H7capn76MpoJeurd78dzEIepIyiUOk4IPoT5bJmCDZYU0BpzHnDSqauMCYuGoyUv
	 tWnO6gT2yUE6zDBBzYLEoxPXfrg3ITFCPzWxQtUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 1054/1250] afs: Fix incorrect free in candidate cleanup in afs_lookup_server()
Date: Thu, 17 Sep 2026 16:14:09 +0100
Message-ID: <20260917151620.690712120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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


