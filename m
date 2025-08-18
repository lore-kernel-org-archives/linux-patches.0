Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F098334713;
	Mon, 18 Aug 2025 14:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526232; cv=none; b=pthBfugstg6jSv3Vh2v0wDQ/Ezb8r07txJEd3fJRW6n3DEOiXNHpaUtBJ6G/6UoZ5fniMrMX6DtDRbbRUX8Y9dDTEtLqt9H1SXUgz6XBxDgTMcaURbRTHdXIWwUXqo1UU24smdlIB1Hw1ZhnG6OKrN85maAAljb5UNs2Cq8iGV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526232; c=relaxed/simple;
	bh=S0rRFw56JLoKkAoVGNfaSFWaaHFZcBKLKoIRCvBXkb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5EZU6uM5UVADu4bS/YnC5lyK0mxUj5hX11g0+Sg0l6PNS9noZVUhJim4Htk17kzk4qhpCOy60HEwUqZexjdSMv+lvsX38sH897TKVBkXEJ0fFAtzlIBReE70oo8mZtY9DO0jQ+BMQMSUpUUVxDhEaNRbVUhIMmDDfonHOFGW4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B34bwLjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B34bwLjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7449BC4CEEB;
	Mon, 18 Aug 2025 14:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526231;
	bh=S0rRFw56JLoKkAoVGNfaSFWaaHFZcBKLKoIRCvBXkb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B34bwLjqlEMKWUGGrPR/G7Dcv03O8CqAZNPGWHHZhc6jbtR8lddQLJibFzh58pW+a
	 qg8MPObsVOHzfktEs9nweU9ZLlAzivjU/glN1tpVkTQDCKYqrqmFWggjAb20h5IV05
	 RJfZjn1CKfIIHVRtO2ezHYfQ3P5c0nnbloZnpagw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.16 496/570] cifs: reset iface weights when we cannot find a candidate
Date: Mon, 18 Aug 2025 14:48:03 +0200
Message-ID: <20250818124524.975838944@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -332,6 +332,7 @@ cifs_chan_update_iface(struct cifs_ses *
 	struct cifs_server_iface *old_iface = NULL;
 	struct cifs_server_iface *last_iface = NULL;
 	struct sockaddr_storage ss;
+	int retry = 0;
 
 	spin_lock(&ses->chan_lock);
 	chan_index = cifs_ses_get_chan_index(ses, server);
@@ -360,6 +361,7 @@ cifs_chan_update_iface(struct cifs_ses *
 		return;
 	}
 
+try_again:
 	last_iface = list_last_entry(&ses->iface_list, struct cifs_server_iface,
 				     iface_head);
 	iface_min_speed = last_iface->speed;
@@ -397,6 +399,13 @@ cifs_chan_update_iface(struct cifs_ses *
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


