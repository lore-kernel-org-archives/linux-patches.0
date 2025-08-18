Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF8821B199;
	Mon, 18 Aug 2025 13:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522642; cv=none; b=TtZbFR9AqWXywFiieYuFDG0QlY8jSXK74aBQF4TBdUw9nIYlriGqBg5vt7E+zdIO57XBczLw3PDYWJN4EwqO3kBN5bKFOw3sMXpZ799pVKll0gZUVhSWIZe0hSn2q0VWoqn4k0mI3C2tZHeR1YNZzBiohOZNRkv6kiSSD42kLzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522642; c=relaxed/simple;
	bh=oGmlzHwuN/bCiJjsXjI+2k/flfnLl/zTXayGQSqBNTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8qn2gtXpoitFmZBwZYo1D4z7xMZDQbJo9oPII5y6srzg7RP5tpOtho/OHBmeUbFPjdCSsJ5BSOdNTytIjdc7IBvHw+L2FKxo+Zv2VfZNLLFTEn8Grs0Zu/xow2iQ4h+selmCwUDpFVkoSbIFHQyuy5O6aEv/vFSNtcaIK79IdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0zGPAVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0zGPAVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C086FC4CEEB;
	Mon, 18 Aug 2025 13:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522642;
	bh=oGmlzHwuN/bCiJjsXjI+2k/flfnLl/zTXayGQSqBNTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0zGPAVjPqqoobRaAfuVMA916kB+Zs/1RkiQYce2+UNjZNkKbXy1vx1x2q+i7vgP+
	 z/JsDETXp6BXRQeoLgTReqOxc7Z31UQSrNprpLtL5JiogzQMIKRJcFdK6wjmrJuZuo
	 XaiL/2GzW8qe+Lq0fI/ju7/z2xy4pHbYYFv0CiO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 377/444] cifs: reset iface weights when we cannot find a candidate
Date: Mon, 18 Aug 2025 14:46:43 +0200
Message-ID: <20250818124503.024581263@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

commit 9d5eff7821f6d70f7d1b4d8a60680fba4de868a7 upstream.

We now do a weighted selection of server interfaces when allocating
new channels. The weights are decided based on the speed advertised.
The fulfilled weight for an interface is a counter that is used to
track the interface selection. It should be reset back to zero once
all interfaces fulfilling their weight.

In cifs_chan_update_iface, this reset logic was missing. As a result
when the server interface list changes, the client may not be able
to find a new candidate for other channels after all interfaces have
been fulfilled.

Fixes: a6d8fb54a515 ("cifs: distribute channels across interfaces based on speed")
Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -360,6 +360,7 @@ cifs_chan_update_iface(struct cifs_ses *
 	struct cifs_server_iface *old_iface = NULL;
 	struct cifs_server_iface *last_iface = NULL;
 	struct sockaddr_storage ss;
+	int retry = 0;
 
 	spin_lock(&ses->chan_lock);
 	chan_index = cifs_ses_get_chan_index(ses, server);
@@ -388,6 +389,7 @@ cifs_chan_update_iface(struct cifs_ses *
 		return;
 	}
 
+try_again:
 	last_iface = list_last_entry(&ses->iface_list, struct cifs_server_iface,
 				     iface_head);
 	iface_min_speed = last_iface->speed;
@@ -425,6 +427,13 @@ cifs_chan_update_iface(struct cifs_ses *
 	}
 
 	if (list_entry_is_head(iface, &ses->iface_list, iface_head)) {
+		list_for_each_entry(iface, &ses->iface_list, iface_head)
+			iface->weight_fulfilled = 0;
+
+		/* see if it can be satisfied in second attempt */
+		if (!retry++)
+			goto try_again;
+
 		iface = NULL;
 		cifs_dbg(FYI, "unable to find a suitable iface\n");
 	}


