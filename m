Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B3E1ADFFE;
	Tue, 26 Aug 2025 13:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213412; cv=none; b=S53EqEgU5m4R949jgWDGBgTWd89P3b5b/9JJSsKsmW9BS/d3FG6Zhn5e4asgGUmKDSP74L5bAdz1vrzxNXfFnZ/61Xv7ExAqUPAj5UgNuxsOnR5UZ2x1RS7SRNhpXpDxlIdwtumEEu4NtYZV6XSVkCNtVu+FTaYkEgCfpVyMU94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213412; c=relaxed/simple;
	bh=cz3El37PXu5SkIkgmk8r/dcCEpMBlTlqdAjv/g98BqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIobpoj+P+jmqmhSWMsKtwbEYmOZWp1JpOGV3ZoT7pRUUq28mjEgIVCNEgDMbGcfOWLBcU0QHos9nD8RELu2CGPfbRF8QH8tQvJq116MVxjB0Cgsvw6g7vwkEw+zSW0gq2FO8oBogiVoe+6yxLZSR8j64sjb/jaIJ5GYCrEgZjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x56XsJJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x56XsJJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6B2C4CEF4;
	Tue, 26 Aug 2025 13:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213412;
	bh=cz3El37PXu5SkIkgmk8r/dcCEpMBlTlqdAjv/g98BqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x56XsJJmmWgXk0GXDUNQ4tQ7qeUTPUNIIlS7VqpHcbE6Mlfvp+mbAZMAtS2jvjZyZ
	 r78xbHOe8CWb/HeXSRzyGkERAPGO0r7DM2/S4sALa6JnlViiSqrlt+h7FRNKWjhN4m
	 pZ/WdweUB98vyOcXqtIXR4ChK8zHzEjwI1/bE+/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 297/587] cifs: reset iface weights when we cannot find a candidate
Date: Tue, 26 Aug 2025 13:07:26 +0200
Message-ID: <20250826111000.482332644@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -372,6 +372,7 @@ cifs_chan_update_iface(struct cifs_ses *
 	struct cifs_server_iface *old_iface = NULL;
 	struct cifs_server_iface *last_iface = NULL;
 	struct sockaddr_storage ss;
+	int retry = 0;
 
 	spin_lock(&ses->chan_lock);
 	chan_index = cifs_ses_get_chan_index(ses, server);
@@ -400,6 +401,7 @@ cifs_chan_update_iface(struct cifs_ses *
 		return;
 	}
 
+try_again:
 	last_iface = list_last_entry(&ses->iface_list, struct cifs_server_iface,
 				     iface_head);
 	iface_min_speed = last_iface->speed;
@@ -437,6 +439,13 @@ cifs_chan_update_iface(struct cifs_ses *
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


