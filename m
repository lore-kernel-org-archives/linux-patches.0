Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF03183CA6;
	Mon, 12 Aug 2024 16:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479546; cv=none; b=pZDZVJ3VUkMmcFLXTnvKc7S+yNoziyTSAjCckUgEdzcmbPCl6GfnGVL6sBqcO98FIROT9yDhoxVtJIiAz4/zR5gn4q72jr/epi+c5qSBlu+KY4SYp8MPupoRaPAxWw1LXjU/MnzroJ5mdXQC0sWH9NbYrx1OAUPo70CUuXEMXoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479546; c=relaxed/simple;
	bh=S2+9awx9AUNo8DY5oZrtEuDKVM0+mYeTv2eyNauUqIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLg5/iEiRtHTRzkRFBOK8u8Oiitn/PytaBqiNgEU4nvbJJQ+HtugxifZF7fMwKkLpd6jJAjmo1nVn/5E14g8w8JwG7F2dZLGsMRMTED83ek+lvOAoozC3RB9vU7n/I7lH6r1xOnnsgOyPYxvRxrAllli+g+FaYy3r92hVH6IkUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yj3kPjTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yj3kPjTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D8BC32782;
	Mon, 12 Aug 2024 16:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479546;
	bh=S2+9awx9AUNo8DY5oZrtEuDKVM0+mYeTv2eyNauUqIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yj3kPjTesfjbY3q5rAYcqW8r/fdVMRZiAK3to3XGb3ZMc39Gat1lHZZ9jqZxwSkyO
	 UfMxlaFhKDgYKIox3DLcG60txcWnrJc9NbGKGbs3QSpE4hU6vFLN/UFdJxbSQQHWBR
	 sG8WbYzSmZp/bomxxu/WCV7ucRwjmRQhiDj5YFl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 120/189] usb: gadget: midi2: Fix the response for FB info with block 0xff
Date: Mon, 12 Aug 2024 18:02:56 +0200
Message-ID: <20240812160136.765207994@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 228a953e61d6d608a3facc1c3a27b9fb03c99de7 upstream.

When the block number 0xff is given to Function Block Discovery
message, the device should return the information of all Function
Blocks, but currently the gadget driver treats it as an error.

Implement the proper behavior for the block 0xff instead.

Fixes: 8b645922b223 ("usb: gadget: Add support for USB MIDI 2.0 function driver")
Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240717095102.10493-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi2.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/usb/gadget/function/f_midi2.c
+++ b/drivers/usb/gadget/function/f_midi2.c
@@ -642,12 +642,21 @@ static void process_ump_stream_msg(struc
 		if (format)
 			return; // invalid
 		blk = (*data >> 8) & 0xff;
-		if (blk >= ep->num_blks)
-			return;
-		if (*data & UMP_STREAM_MSG_REQUEST_FB_INFO)
-			reply_ump_stream_fb_info(ep, blk);
-		if (*data & UMP_STREAM_MSG_REQUEST_FB_NAME)
-			reply_ump_stream_fb_name(ep, blk);
+		if (blk == 0xff) {
+			/* inquiry for all blocks */
+			for (blk = 0; blk < ep->num_blks; blk++) {
+				if (*data & UMP_STREAM_MSG_REQUEST_FB_INFO)
+					reply_ump_stream_fb_info(ep, blk);
+				if (*data & UMP_STREAM_MSG_REQUEST_FB_NAME)
+					reply_ump_stream_fb_name(ep, blk);
+			}
+		} else if (blk < ep->num_blks) {
+			/* only the specified block */
+			if (*data & UMP_STREAM_MSG_REQUEST_FB_INFO)
+				reply_ump_stream_fb_info(ep, blk);
+			if (*data & UMP_STREAM_MSG_REQUEST_FB_NAME)
+				reply_ump_stream_fb_name(ep, blk);
+		}
 		return;
 	}
 }


