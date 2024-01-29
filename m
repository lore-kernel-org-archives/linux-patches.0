Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627E17375F;
	Mon, 29 Jan 2024 17:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548554; cv=none; b=hlubwPz8jbsxV6w15YbqyLbv5C8f7k+OVRTnU6X02kSy4pVu37cfwo+x42p/DZUsO6kdCcdez4Vom7BEWRTzm46f+xXa1SsmWMld/uLT5Cjh344t7vvHNXUxDpx7Vm408y09RU7+8srxugPyIVz+qpOE5IshGAR4YLoBHMh1R7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548554; c=relaxed/simple;
	bh=iAi2Z8L3YzHBchvN8Gt3FekIeKC/RucG4yVej5ZjT8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnY2kFExTZNbV5+gOOTpVoV113eIzly8JaTXdOSyqW22s5kOSNOoMQU/iGbyYSayeUDmS44U5NuDgaYhH7iiSHEsyU9rv6IgHBARo+0RxhnzgYZEytSiOjFdJ0iSk45Fo3fRFdn+vxN9jM3flCdRtycUJ4jDAet9n/+GqwrKIgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tlnlQSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tlnlQSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2966EC43394;
	Mon, 29 Jan 2024 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548554;
	bh=iAi2Z8L3YzHBchvN8Gt3FekIeKC/RucG4yVej5ZjT8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0tlnlQSJeiEiGn/J+s6928NSr2gUjNBdo8uPettDhZZxBrugd3/AflR09ltROEn7V
	 tmR5/70W+pVSU4d+lQLNzvDMVuA8Ajx0mOSxfSEGi/yct525J2cIue+rjIzQYa/6Cq
	 HxUt7pIMXJMO9Irp/qvRxNS/XJRyUfhPxOyf1Dq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 164/331] cifs: fix lock ordering while disabling multichannel
Date: Mon, 29 Jan 2024 09:03:48 -0800
Message-ID: <20240129170019.726573280@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

commit 5eef12c4e3230f2025dc46ad8c4a3bc19978e5d7 upstream.

The code to handle the case of server disabling multichannel
was picking iface_lock with chan_lock held. This goes against
the lock ordering rules, as iface_lock is a higher order lock
(even if it isn't so obvious).

This change fixes the lock ordering by doing the following in
that order for each secondary channel:
1. store iface and server pointers in local variable
2. remove references to iface and server in channels
3. unlock chan_lock
4. lock iface_lock
5. dec ref count for iface
6. unlock iface_lock
7. dec ref count for server
8. lock chan_lock again

Since this function can only be called in smb2_reconnect, and
that cannot be called by two parallel processes, we should not
have races due to dropping chan_lock between steps 3 and 8.

Fixes: ee1d21794e55 ("cifs: handle when server stops supporting multichannel")
Reported-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -316,28 +316,32 @@ cifs_disable_secondary_channels(struct c
 		iface = ses->chans[i].iface;
 		server = ses->chans[i].server;
 
+		/*
+		 * remove these references first, since we need to unlock
+		 * the chan_lock here, since iface_lock is a higher lock
+		 */
+		ses->chans[i].iface = NULL;
+		ses->chans[i].server = NULL;
+		spin_unlock(&ses->chan_lock);
+
 		if (iface) {
 			spin_lock(&ses->iface_lock);
 			kref_put(&iface->refcount, release_iface);
-			ses->chans[i].iface = NULL;
 			iface->num_channels--;
 			if (iface->weight_fulfilled)
 				iface->weight_fulfilled--;
 			spin_unlock(&ses->iface_lock);
 		}
 
-		spin_unlock(&ses->chan_lock);
-		if (server && !server->terminate) {
-			server->terminate = true;
-			cifs_signal_cifsd_for_reconnect(server, false);
-		}
-		spin_lock(&ses->chan_lock);
-
 		if (server) {
-			ses->chans[i].server = NULL;
+			if (!server->terminate) {
+				server->terminate = true;
+				cifs_signal_cifsd_for_reconnect(server, false);
+			}
 			cifs_put_tcp_session(server, false);
 		}
 
+		spin_lock(&ses->chan_lock);
 	}
 
 done:


