Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE5F4C3A0;
	Mon,  8 Jan 2024 15:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0j00k8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBD3C433C9;
	Mon,  8 Jan 2024 15:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728225;
	bh=lexNMwr8Wq8jUWfnKZX4doDiKh08I5AnNGSeC8mmodk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0j00k8XJCfpIaPlwzjb1FVAqcvG8ZSU1mW5iC4+nOZ0xbNEmfLVEavpj409zcIFs
	 K3xmAsfVCgIGl1jVreVEGX24hEGNwLCHW9rpQbwup/46k58LFq99M6yj1qpoc4anX8
	 BKPLZ9Qc10cF2tqg6nAYfwePJvjd7AZFYuAi8o+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 010/150] cifs: do not depend on release_iface for maintaining iface_list
Date: Mon,  8 Jan 2024 16:34:21 +0100
Message-ID: <20240108153511.722254044@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

commit 09eeb0723f219fbd96d8865bf9b935e03ee2ec22 upstream.

parse_server_interfaces should be in complete charge of maintaining
the iface_list linked list. Today, iface entries are removed
from the list only when the last refcount is dropped.
i.e. in release_iface. However, this can result in undercounting
of refcount if the server stops advertising interfaces (which
Azure SMB server does).

This change puts parse_server_interfaces in full charge of
maintaining the iface_list. So if an empty list is returned
by the server, the entries in the list will immediately be
removed. This way, a following call to the same function will
not find entries in the list.

Fixes: aa45dadd34e4 ("cifs: change iface_list from array to sorted linked list")
Cc: stable@vger.kernel.org
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsglob.h |    1 -
 fs/smb/client/smb2ops.c  |   27 +++++++++++++++++----------
 2 files changed, 17 insertions(+), 11 deletions(-)

--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -972,7 +972,6 @@ release_iface(struct kref *ref)
 	struct cifs_server_iface *iface = container_of(ref,
 						       struct cifs_server_iface,
 						       refcount);
-	list_del_init(&iface->iface_head);
 	kfree(iface);
 }
 
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -588,16 +588,12 @@ parse_server_interfaces(struct network_i
 	}
 
 	/*
-	 * Go through iface_list and do kref_put to remove
-	 * any unused ifaces. ifaces in use will be removed
-	 * when the last user calls a kref_put on it
+	 * Go through iface_list and mark them as inactive
 	 */
 	list_for_each_entry_safe(iface, niface, &ses->iface_list,
-				 iface_head) {
+				 iface_head)
 		iface->is_active = 0;
-		kref_put(&iface->refcount, release_iface);
-		ses->iface_count--;
-	}
+
 	spin_unlock(&ses->iface_lock);
 
 	/*
@@ -672,10 +668,7 @@ parse_server_interfaces(struct network_i
 					 iface_head) {
 			ret = iface_cmp(iface, &tmp_iface);
 			if (!ret) {
-				/* just get a ref so that it doesn't get picked/freed */
 				iface->is_active = 1;
-				kref_get(&iface->refcount);
-				ses->iface_count++;
 				spin_unlock(&ses->iface_lock);
 				goto next_iface;
 			} else if (ret < 0) {
@@ -742,6 +735,20 @@ next_iface:
 	}
 
 out:
+	/*
+	 * Go through the list again and put the inactive entries
+	 */
+	spin_lock(&ses->iface_lock);
+	list_for_each_entry_safe(iface, niface, &ses->iface_list,
+				 iface_head) {
+		if (!iface->is_active) {
+			list_del(&iface->iface_head);
+			kref_put(&iface->refcount, release_iface);
+			ses->iface_count--;
+		}
+	}
+	spin_unlock(&ses->iface_lock);
+
 	return rc;
 }
 


