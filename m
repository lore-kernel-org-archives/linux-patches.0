Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4D6389477;
	Tue, 10 Mar 2026 11:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142058; cv=none; b=nJ7JK02nlCbfBpQDsZMkifC2OxsUTv4FVcYKS6t2f81lfbCRW8CoybLY4zvJ97giLj1KJDpfWXJlt3jLc/OODF9V4dvcrpdPNVUoEQLvLpboSfOgRaNmGRkUqHCm16X7jSXIDCBwR8GGtPzW1a08F45Y+nWnWSQFqJVWvLpANxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142058; c=relaxed/simple;
	bh=kzSYyl+zvAxKnNXso7Ain+q8wNu351Ji9x6sEZRMKBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHDFQ8ph3C27FqNL6DiRPLnu2dm2fjpkIDjpohLcgOXGGmbs+HnuS7HDzeDhLO/jpEP46F678c6x7GSnbJ4pcoO4NVJT3Ejk1gXPmo4fPhNfAXs2RQ0wUKu2d1DMElwX/ZqSp24WdQcFOtFDFsSnQtG88NIkJVGLXY9lTiqXLC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dzn0+B26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dzn0+B26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DC2C2BC86;
	Tue, 10 Mar 2026 11:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142058;
	bh=kzSYyl+zvAxKnNXso7Ain+q8wNu351Ji9x6sEZRMKBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzn0+B266UwM9tkKnP2L5qWITfjZregHSCQuWc4mVF1RqUHmJICj3hCINp7LbIYbt
	 sX8TxUl3JwM+M433/6b4Y+k+n2lwKGQ0+YtO9Y7LAMaFt6Ti97liuIQjoeqmrPazEO
	 ztUeOaTv8mlLWRVxzPfmaKLgJ8qGdOXevrkBf+kG2tX+cMcLF7wrKP/IlSgQZV/Qz3
	 onbwfH8HSfZSa9eqYnvK6mUl9Aa/IA24XYun8aXHcGPogpI6hzZ7B5pGE8hTmY72Pt
	 OSdJpKZkuyu4EMHRxmXHzFxk0KnMTkJonfByT+IUyWP3wJv+NqV9YW2QAFoBTTg/ee
	 zcXID7ooG56pg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Henrique Carvalho <henrique.carvalho@suse.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 184/314] smb: client: fix cifs_pick_channel when channels are equally loaded
Date: Tue, 10 Mar 2026 07:17:23 -0400
Message-ID: <aeccbee1b34de2203f86ef33e7339a9e7206c050.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index 915cedde5d664..2d7140767dc43 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -806,16 +806,21 @@ cifs_cancelled_callback(struct mid_q_entry *mid)
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
 
@@ -845,14 +850,8 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
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

