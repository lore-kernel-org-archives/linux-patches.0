Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026F92737EB;
	Mon, 23 Mar 2026 14:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277826; cv=none; b=tV0FMIQZEtO/Dc5ICF4pC9M6si5U3ZHe0VllY6JuXZmZjEPSjr4DvXNsUDzfweSHadelHftL10tnfFJv7mUtZJjwdbsSHjqVStgpmoEYGb9CqFE031CXlEQolbuDIhE9swKhB07Mm0OI68SFHpOTxCbdEGQMnus2l2hrvTrxyRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277826; c=relaxed/simple;
	bh=/4WtPzgkAQ0xlbgyGc7yMQUzKQfhzBMAC3BOJhcQ4mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfzMMF+UUTAK8xiK5w/7M2cLOUhjjK39gPiq+PzOKX4gM/x2HT7lFzs3Fi9b1Eftqj0ShH2eHs+uzF5L1n4+oe/XmCSSIPNh0mSfG2mA/yvL2DODAjtp78LcqHC4qK/DH72tFtI0KYM9qnJOaho4a84+njGyTlrkMqukDRtSTjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDjG4kwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDjG4kwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B02AC4CEF7;
	Mon, 23 Mar 2026 14:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277825;
	bh=/4WtPzgkAQ0xlbgyGc7yMQUzKQfhzBMAC3BOJhcQ4mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDjG4kwWempWIZl5LhYRhxddipI7+nBXB6I9eX7OJHhgmbE1QmLDgjgZOpehvRoBb
	 sxB8N7csA2oZal4mZYSrRV/8yKao94DbAucKhpkMwAL9ywmrTHofOI70ICzujNUu7g
	 IFCKnsnZcfx9R5J8iBk0az0Fb8dFLiQ7D5XnPnmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 115/567] smb: client: fix cifs_pick_channel when channels are equally loaded
Date: Mon, 23 Mar 2026 14:40:35 +0100
Message-ID: <20260323134536.656170811@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit 663c28469d3274d6456f206a6671c91493d85ff1 upstream.

cifs_pick_channel uses (start % chan_count) when channels are equally
loaded, but that can return a channel that failed the eligibility
checks.

Drop the fallback and return the scan-selected channel instead. If none
is eligible, keep the existing behavior of using the primary channel.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Acked-by: Meetakshi Setiya <msetiya@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/transport.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1022,16 +1022,21 @@ cifs_cancelled_callback(struct mid_q_ent
 }
 
 /*
- * Return a channel (master if none) of @ses that can be used to send
- * regular requests.
+ * cifs_pick_channel - pick an eligible channel for network operations
  *
- * If we are currently binding a new channel (negprot/sess.setup),
- * return the new incomplete channel.
+ * @ses: session reference
+ *
+ * Select an eligible channel (not terminating and not marked as needing
+ * reconnect), preferring the least loaded one. If no eligible channel is
+ * found, fall back to the primary channel (index 0).
+ *
+ * Return: TCP_Server_Info pointer for the chosen channel, or NULL if @ses is
+ * NULL.
  */
 struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 {
 	uint index = 0;
-	unsigned int min_in_flight = UINT_MAX, max_in_flight = 0;
+	unsigned int min_in_flight = UINT_MAX;
 	struct TCP_Server_Info *server = NULL;
 	int i, start, cur;
 
@@ -1061,14 +1066,8 @@ struct TCP_Server_Info *cifs_pick_channe
 			min_in_flight = server->in_flight;
 			index = cur;
 		}
-		if (server->in_flight > max_in_flight)
-			max_in_flight = server->in_flight;
 	}
 
-	/* if all channels are equally loaded, fall back to round-robin */
-	if (min_in_flight == max_in_flight)
-		index = (uint)start % ses->chan_count;
-
 	server = ses->chans[index].server;
 	spin_unlock(&ses->chan_lock);
 


