Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBBE2BCF7F;
	Tue, 25 Aug 2026 13:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664730; cv=none; b=qIF/53KpZ/FNLueCijYcJwStm7F+fQi3pCya6/HOh0GsAIgHKPLaOfqdedObYIDlmY7NUpSMSS11ny8dJ2EJC6l+jJ2BiffYm1Qb8mWKtC5ty+FetMNV11ZO0PeaXQSbOcxq2h6U4xxK9a6by4SyP5aD/b4JJUcj2SB8K9XtDi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664730; c=relaxed/simple;
	bh=tTpPNDeXi/yjspnncTRWFwwpkh+WPDEB3Q696M/CWLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qp8OsEWVRnlaOdrT7uZHjEhTIfJr3MyMaVq0G0I4Tpv7kkc9I4UJBIbjpBSET9Ivaa9zE3DkoDgIjUkkBy4SfqhjhstFv4Hts2pIMKpsGhi5+mLH3d0FqUlvMKIk0VbLwNZcYZ4HuaVKCoRQPMUcGEsCim1nxtd8Ci/eyFHvGxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JACsZw0b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JACsZw0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F2E1F000E9;
	Tue, 25 Aug 2026 13:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664728;
	bh=zsyYNxy7jLYrqtGYe+ZHbJ1sPoKS0A2OzHQSshl/7Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JACsZw0bBSLSlLgDF/UKBkkULN2er5Se+KAf1a0wL1vZTEz7ziVZZ90/+x3UoPP3l
	 WfL+qBhKZJ6a+0gZf8+LPqnaO/PBABNdzPSPtO3RPqVqRvpJUu7Tg+RQub9xeH2TlC
	 I8IjcW2tfo58awUbXOMdH4BtCT0uSZ3s05uZWP3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 7.2 40/82] nfc: pn533: purge fragmented skbs during cleanup
Date: Tue, 25 Aug 2026 15:25:27 +0200
Message-ID: <20260825132543.083762783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit 5718fc62198c38c2de5316020a90506f9e75e0bb upstream.

pn53x_common_clean() purges resp_q before freeing the common PN533 state,
but it leaves fragment_skb untouched.  The fragmentation helpers queue
transmit fragments there while sending large initiator or target-mode
frames, and those skbs remain owned by the driver until they are sent or
discarded.

If the device is removed while fragments are still queued, the common
cleanup path frees the PN533 state without releasing the queued fragment
skbs, leaking them.

Purge fragment_skb during cleanup alongside resp_q.

Fixes: 963a82e07d4e ("NFC: pn533: Split large Tx frames in chunks")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/2D896607CAE4408E+20260720021444.3362044-1-raoxu@uniontech.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/pn533/pn533.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2799,6 +2799,7 @@ void pn53x_common_clean(struct pn533 *pr
 	destroy_workqueue(priv->wq);
 
 	skb_queue_purge(&priv->resp_q);
+	skb_queue_purge(&priv->fragment_skb);
 
 	list_for_each_entry_safe(cmd, n, &priv->cmd_queue, queue) {
 		list_del(&cmd->queue);


