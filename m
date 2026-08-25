Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A17A312831;
	Tue, 25 Aug 2026 14:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666415; cv=none; b=KCtqqpVdxHzYyt3/V8J06cuL062+o0AJ2ra5Lebpb+aDIZ7Mg/jBXE3VtqdxowGfS61S18K3KOeTTEVppOl2FttCed6N+qnix/pmClw57m5TyxJg3s9ufzxhCZZ1qh6Qij1xNUxVf8eNNBxu1FohsVbrXtpqZHJ0ehGTkQKB6fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666415; c=relaxed/simple;
	bh=0bblSkwd0BFw9HsTSRS5KKCp0r4g21zJQJU8NWODG+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUUegA231+1vHdmBuDOBLVNGA2HMpd85qJw1srh3DBiuqKxKicBBkuqLhghQeq07jZwFWmGA8We5VK2jdO6hSKBFA9Qobho/FRlWL3LLeLITY3VoZBO23K3kdgwKndI69csWuAJp2kGCZe7sJ/qoXJJfytJZsxze5QaohSKj6UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXPWfj/E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXPWfj/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE9C1F000E9;
	Tue, 25 Aug 2026 14:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666414;
	bh=HqJ7S7mZmsC6BZDG0qNzEnsEVzIwz0/+JUZCCOLnKXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lXPWfj/Eq5S0fA9rHPgnN80/8qtXKrE+f+Oumo7yJaaJcKYGigr1Ex1qmaqiObCSV
	 jZcHVK6aB6WNxUuOJsDpyZHtddjQ4tyMuHvINAVvdFB1badSUXLn8rjT9njqGXcltL
	 CxvviZos87TtxO69ttwM0QffeYA37qzfcwnbAlc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 5.10 35/57] nfc: pn533: purge fragmented skbs during cleanup
Date: Tue, 25 Aug 2026 15:26:57 +0200
Message-ID: <20260825132542.694335102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2860,6 +2860,7 @@ void pn53x_common_clean(struct pn533 *pr
 	destroy_workqueue(priv->wq);
 
 	skb_queue_purge(&priv->resp_q);
+	skb_queue_purge(&priv->fragment_skb);
 
 	list_for_each_entry_safe(cmd, n, &priv->cmd_queue, queue) {
 		list_del(&cmd->queue);


