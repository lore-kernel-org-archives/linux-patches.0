Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A813345752;
	Tue, 26 Aug 2025 13:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215104; cv=none; b=lqF8A5uGYU9GEHXUPRXO6UV3gCT39hm8XI0tJiFNnr4XuIkZnpppXr/qx94z/7eXc3jYJaU0kgSkRQ9S6W8E+M32KhthR7p1+k/Bcm0AvmD1ptB+QMUVbO6rwvy93P5/BtxAvdoOaY5S3VZbOWBD+7ZGRndVIgMGUElDYtOhMCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215104; c=relaxed/simple;
	bh=mKXnRxMlu90vQV0e+XdS2AURI19LzlfyZ1nfXYYDuAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cf3v79LRFkALTjCR7kbxkcfjv8VHEpzBrnaBuxeBvfLXDR19QqqCxy2qe04qZ83D6jCjQTKF9qFHPtiX62DFPKwojjyChbaTD4pwigLJm873x/Htl9tcuUCnrCTczqScW13HnfpP0U6CeMqK31FUmHKFOU9lor94S19QJwdlMk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9KCxaLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9KCxaLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E3AC4CEF1;
	Tue, 26 Aug 2025 13:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215104;
	bh=mKXnRxMlu90vQV0e+XdS2AURI19LzlfyZ1nfXYYDuAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9KCxaLLHHGcnOK1Ov6QeYs70zsMJyrJ1LjVyNJTP8z4SXfwu1t5WlRM8+NXCKTz1
	 QCTlwZ1aTdbAuPmnS0+Reas4vbIdYj8qB02dP3H+qfn7sJz1QX3NKOSv7yxIbyaaXM
	 bOH5Aw16l0U7+52ePWMjWUz8TlSnixmb/zczWdo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 358/482] cifs: reset iface weights when we cannot find a candidate
Date: Tue, 26 Aug 2025 13:10:11 +0200
Message-ID: <20250826110939.680025599@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 9d5eff7821f6d70f7d1b4d8a60680fba4de868a7 ]

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
[ Kept both int rc and int retry variables ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -292,6 +292,7 @@ cifs_chan_update_iface(struct cifs_ses *
 	struct cifs_server_iface *last_iface = NULL;
 	struct sockaddr_storage ss;
 	int rc = 0;
+	int retry = 0;
 
 	spin_lock(&ses->chan_lock);
 	chan_index = cifs_ses_get_chan_index(ses, server);
@@ -320,6 +321,7 @@ cifs_chan_update_iface(struct cifs_ses *
 		return 0;
 	}
 
+try_again:
 	last_iface = list_last_entry(&ses->iface_list, struct cifs_server_iface,
 				     iface_head);
 	iface_min_speed = last_iface->speed;
@@ -358,6 +360,13 @@ cifs_chan_update_iface(struct cifs_ses *
 
 	if (list_entry_is_head(iface, &ses->iface_list, iface_head)) {
 		rc = 1;
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


