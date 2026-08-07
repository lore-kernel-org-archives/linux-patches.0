Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBAB2D12ED;
	Fri,  7 Aug 2026 15:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117246; cv=none; b=pu4/eaACKTNckl3WHWCBb/bLL2kx+xrPOuQN85vu1IsMQ7KOFLVzKdewR/kh9AfcABR2ympMCmH6Gmcm969n1RJmd6W3PbRkaJWJWDweU+NXFwrfcBRK2pXoXvsyoNQrc/peYyrTPkbsYfL+uzvFr/4qLJ1tA7RmxMy1aQ8dYUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117246; c=relaxed/simple;
	bh=JREAQt2HEhpb66bDyI9sXBmek0w990b8P0zwoDYe+Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogVOBQl5qIPi7MvdCj/CII8Uf/1l55qgRnZZvt/N7Nh20ZUUEr59T9ztm6+YMRdHdK1wnpvA/ryrjajjEdyfmhXjOKEqdFcyx8wrGoSAAySLl/Nv9dL5BWCNnpvBKetgKhRV7rsDJtwHY0OMnQdOB24k++zhonwpBPA2Eck3vT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4PAxolU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4PAxolU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53581F000E9;
	Fri,  7 Aug 2026 15:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117245;
	bh=2AYixdn70Uz9ru7FCem7ERxgWon3U5s0ptHjMxTymuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4PAxolUp3sS6hgqv23KC4rxIEPIe0O9uzkEEPbrpIR096MWSX4L85VAqI3LvbKS7
	 ecTU0mS+z6igvDpQHn/8lSvWqdfYNYq03mTwmqKzq6rXysFUJpc8PMSi2zQ1xl5/y6
	 9cLZCATtVYV76DgodcBCCVJ+kBj5dgXltdslXq8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.1 249/438] afs: Fix afs_fs_fetch_data() to set call->async
Date: Fri,  7 Aug 2026 16:37:25 +0200
Message-ID: <20260807143433.307219717@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit d568a43f6dbba3ba006304d95fd09862bd482a2f upstream.

Fix afs_fs_fetch_data() to set call->async on an async operation as does
afs_fs_fetch_data64().

Fixes: eddf51f2bb2c ("afs: Make {Y,}FS.FetchData an asynchronous operation")
Link: https://sashiko.dev/#/patchset/20260702144919.172295-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260723113452.566619-2-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/fsclient.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -477,6 +477,9 @@ void afs_fs_fetch_data(struct afs_operat
 	if (!call)
 		return afs_op_nomem(op);
 
+	if (op->flags & AFS_OPERATION_ASYNC)
+		call->async = true;
+
 	/* marshall the parameters */
 	bp = call->request;
 	bp[0] = htonl(FSFETCHDATA);


