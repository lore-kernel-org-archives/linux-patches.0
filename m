Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F260421FF2B;
	Mon, 23 Jun 2025 22:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717011; cv=none; b=bOsrAlqBQDGE1DNIlBUI5BYxuu36aTIEEdutKuU1U3Vrt2J5l8oDKa+qhRn0ru9oee4kMljHluUYyV1qQjAFXU/wNn8xcHsoWDWk5CeZ7MhRG1N9pihjans9jF1uwH3V+OZwme3b2/ucuYTXKr4lfVvtSyrN4IzRh1P99uAPy9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717011; c=relaxed/simple;
	bh=ON22bM1KqggAPa7Xf4r40gg96wa4ab2P25TNmaoXpgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qbo5dhEzlCu4w/Q8vtYI9gd4JDU4BodwResBRrmUQWbkemXuJCbeMF9AHdrMTpzIV9Eox3uBzV42Yv/jEFw8rp2JnPAH/b7HGp+hdTV0DA5zPowryGBhPn9lDCECtG2t0G+SCrZIni8tkDosLr/uJzsNGlIOj2WCtqAtpJB23hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ebg3U3AN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ebg3U3AN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0A5C4CEEA;
	Mon, 23 Jun 2025 22:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717008;
	bh=ON22bM1KqggAPa7Xf4r40gg96wa4ab2P25TNmaoXpgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ebg3U3ANWofhSn8fkz/dttDg+ET+Wmcq5J2wJoPOrzU5qBmcZ2q3GI8Gh3BD8Jert
	 b5Psi7jbtSmOzJKIwoHZebiA38/koBCy1HZITTrHKtBRyHVjHDxuTfH4QdL/++WMca
	 4U82UUHbUYDAfCL+7oVC9GIWe96ChlxFQzGiVjkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 306/414] cifs: deal with the channel loading lag while picking channels
Date: Mon, 23 Jun 2025 15:07:23 +0200
Message-ID: <20250623130649.652581965@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

commit 66d590b828b1fd9fa337047ae58fe1c4c6f43609 upstream.

Our current approach to select a channel for sending requests is this:
1. iterate all channels to find the min and max queue depth
2. if min and max are not the same, pick the channel with min depth
3. if min and max are same, round robin, as all channels are equally loaded

The problem with this approach is that there's a lag between selecting
a channel and sending the request (that increases the queue depth on the channel).
While these numbers will eventually catch up, there could be a skew in the
channel usage, depending on the application's I/O parallelism and the server's
speed of handling requests.

With sufficient parallelism, this lag can artificially increase the queue depth,
thereby impacting the performance negatively.

This change will change the step 1 above to start the iteration from the last
selected channel. This is to reduce the skew in channel usage even in the presence
of this lag.

Fixes: ea90708d3cf3 ("cifs: use the least loaded channel for sending requests")
Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/transport.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1029,14 +1029,16 @@ struct TCP_Server_Info *cifs_pick_channe
 	uint index = 0;
 	unsigned int min_in_flight = UINT_MAX, max_in_flight = 0;
 	struct TCP_Server_Info *server = NULL;
-	int i;
+	int i, start, cur;
 
 	if (!ses)
 		return NULL;
 
 	spin_lock(&ses->chan_lock);
+	start = atomic_inc_return(&ses->chan_seq);
 	for (i = 0; i < ses->chan_count; i++) {
-		server = ses->chans[i].server;
+		cur = (start + i) % ses->chan_count;
+		server = ses->chans[cur].server;
 		if (!server || server->terminate)
 			continue;
 
@@ -1053,17 +1055,15 @@ struct TCP_Server_Info *cifs_pick_channe
 		 */
 		if (server->in_flight < min_in_flight) {
 			min_in_flight = server->in_flight;
-			index = i;
+			index = cur;
 		}
 		if (server->in_flight > max_in_flight)
 			max_in_flight = server->in_flight;
 	}
 
 	/* if all channels are equally loaded, fall back to round-robin */
-	if (min_in_flight == max_in_flight) {
-		index = (uint)atomic_inc_return(&ses->chan_seq);
-		index %= ses->chan_count;
-	}
+	if (min_in_flight == max_in_flight)
+		index = (uint)start % ses->chan_count;
 
 	server = ses->chans[index].server;
 	spin_unlock(&ses->chan_lock);


