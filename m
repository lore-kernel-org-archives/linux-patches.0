Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147B635AC23;
	Tue, 10 Mar 2026 11:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141154; cv=none; b=e/C8y7eTuy9Il6S+YNunaSd+PGHhTHG60ReJD9y218eJV6x0Lope4FhA8q6IOoENweJ3DJwmj/csVbWk9Up6QFurF7DflO+HkMawGUD1yRs0oea64Fg3eSEIT8Hg5FvYaMEGiqCYe55Gk9n5shVBVLe10VI93Cbbm9sxyhL/Cfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141154; c=relaxed/simple;
	bh=GwgNXECudpB/tlaQNh5JdhkYey9cmB7CsD5obxOpLUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxM+qmbj2AP/r4c/RGZCBkF2RwlgbjDM1A6C18PYbx9mS573J0xCEl5f3bK0xN4o99rSvAafsTewJQyI4KMK18m6tDSad3FvwS80kN0w3xAy5tncVtNqc1d40/GmcFRxrC1MrXh/1IvqC3ooov4d7p6Evoa/bdQaAxxzxmDGzL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SLT05Jg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SLT05Jg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20660C19423;
	Tue, 10 Mar 2026 11:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141154;
	bh=GwgNXECudpB/tlaQNh5JdhkYey9cmB7CsD5obxOpLUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLT05Jg2ZdcLP8dBGYmGqyYh/WDGIWO03oDjIp7HZZpgVpw5mhMy8D3tYhuk/++e0
	 +0TMSA9ro5cdaJUVN89KQPHcMc5llTWJnxKLeQr41w8KZW4HMDcXRtdZ5z1Rwpw1OP
	 3bdEB+QNRH8bK/KvD0UwXuFQzrI3PoMsvJO6QXuq3mdZC4D8bF2jhxEmQTwqm698bE
	 q6OO5OUeb/GXQuboG3wxJiryq9xcFco6+j4STwFXBCeK4bJIMVrtSwjBSXbGIF3JYd
	 uCgOO8EXQleKZcRp4ziE6Hvc+qNS8pDgkXPuO0KlvXApiQCYUQC5v0NPO71S8q62ty
	 8Hv/adaV+kYcg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Henrique Carvalho <henrique.carvalho@suse.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 156/311] smb: client: fix cifs_pick_channel when channels are equally loaded
Date: Tue, 10 Mar 2026 07:03:23 -0400
Message-ID: <53a84a5425a87dbb2ce6bed7bb1b117683c0784b.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
 fs/smb/client/transport.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 3b34c3f4da2df..67aee82e98860 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -808,16 +808,21 @@ cifs_cancelled_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
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
 
@@ -847,14 +852,8 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
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
 
-- 
2.51.0

