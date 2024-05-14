Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42B7135415;
	Tue, 14 May 2024 11:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686185; cv=none; b=dG5kAHub1rfdUnzM/rqXHFo7ZscEBtWfs4lBcCnd7HJZV3QgYzXtNed9GB/uXsTL5JYX1xfsw8JbW1inc0NP1wLsAmkYeMONTvYA2i/wxX94yp7Bva7hbqYCIMhJFprpRrajKhyC4z7Gc5OFqtJ/zFZt/7VoOrkjJ1epiIJDa4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686185; c=relaxed/simple;
	bh=/0jIIO6z8OPbVoLT8yutYhfjXD6I26xZ+o/9I8mcf/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbIjZ+/QRnmBSvMfxREwEau6LjCiNHM19QZn+yVD0yVvFQMCCNnYycXaekSvR3Cw/TBOmpukMfySRcdDM+yW/t7fi1BinsQ/937uMdOBeVii+DTDh627CZoO1BvS/CE+hK7x6ueotrPCfQlg7HAYukir3yI6SXusaMMVSJ7TTrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmNApqYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmNApqYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A890C2BD10;
	Tue, 14 May 2024 11:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686185;
	bh=/0jIIO6z8OPbVoLT8yutYhfjXD6I26xZ+o/9I8mcf/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmNApqYqsuZFvhtXaCwakFHiO3YdJc3V9l0YyImBJ6RW8Ar4MG2najcRmtkzdN2H2
	 OspoWy6WEBY6BkDd8iol0NUlYSH/VydE53QsvgR5eoM+GPzIWhSvNIPjV89/MbSXOP
	 vQtr076xf9lJZSJ5tj3FJ7E3enJ126v92wXuKNMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/236] cifs: use the least loaded channel for sending requests
Date: Tue, 14 May 2024 12:16:22 +0200
Message-ID: <20240514101021.099519981@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit ea90708d3cf3d0d92c02afe445ad463fb3c6bf10 ]

Till now, we've used a simple round robin approach to
distribute the requests between the channels. This does
not work well if the channels consume the requests at
different speeds, even if the advertised speeds are the
same.

This change will allow the client to pick the channel
with least number of requests currently in-flight. This
will disregard the link speed, and select a channel
based on the current load of the channels.

For cases when all the channels are equally loaded,
fall back to the old round robin method.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 8094a600245e ("smb3: missing lock when picking channel")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/transport.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 338b34c99b2de..da2bef3b7ac27 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1045,15 +1045,40 @@ cifs_cancelled_callback(struct mid_q_entry *mid)
 struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 {
 	uint index = 0;
+	unsigned int min_in_flight = UINT_MAX, max_in_flight = 0;
+	struct TCP_Server_Info *server = NULL;
+	int i;
 
 	if (!ses)
 		return NULL;
 
-	/* round robin */
-	index = (uint)atomic_inc_return(&ses->chan_seq);
-
 	spin_lock(&ses->chan_lock);
-	index %= ses->chan_count;
+	for (i = 0; i < ses->chan_count; i++) {
+		server = ses->chans[i].server;
+		if (!server)
+			continue;
+
+		/*
+		 * strictly speaking, we should pick up req_lock to read
+		 * server->in_flight. But it shouldn't matter much here if we
+		 * race while reading this data. The worst that can happen is
+		 * that we could use a channel that's not least loaded. Avoiding
+		 * taking the lock could help reduce wait time, which is
+		 * important for this function
+		 */
+		if (server->in_flight < min_in_flight) {
+			min_in_flight = server->in_flight;
+			index = i;
+		}
+		if (server->in_flight > max_in_flight)
+			max_in_flight = server->in_flight;
+	}
+
+	/* if all channels are equally loaded, fall back to round-robin */
+	if (min_in_flight == max_in_flight) {
+		index = (uint)atomic_inc_return(&ses->chan_seq);
+		index %= ses->chan_count;
+	}
 	spin_unlock(&ses->chan_lock);
 
 	return ses->chans[index].server;
-- 
2.43.0



