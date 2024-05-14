Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3789D4F60D;
	Tue, 14 May 2024 11:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685749; cv=none; b=t0pSXum0yNdD769GyJ6PkmEIa4uo8ytUjNLGbSGGUhYQfDVfAl6l2lMKUFSCAJjnJnMDCROcVENQUUPYMBkvejyG4DzGtSqDlCF6G1nqESQP40CtMfFBvNY4ZR6GK+Rxj3xcf/R9p7uUthmbjmDh3PYtSOFL1Ha+R9uZ055DdoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685749; c=relaxed/simple;
	bh=Y+e82n9EjH2l6i2+yOtomqdVlI3ePmVxG/A765UW+Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5zT1gX/mTbZZ/4Ivk/QxNkFKh5OdzExaMbc9A6doIQ6kqKgnAybfyI/8ElzqTTlCGS0GFAqQ7LSItWfkcp30Zk2gMj0REfgQY8siPeQuHX1xJPsFLNjgy3HAomDScSIFc9e5JGdhq1JRNfAh2NGGluIvJK9T/P5RXKrrtZ+pR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNmuPXdB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNmuPXdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510CBC2BD10;
	Tue, 14 May 2024 11:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685749;
	bh=Y+e82n9EjH2l6i2+yOtomqdVlI3ePmVxG/A765UW+Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNmuPXdBhcyMnpjW9BZuVVlRBm9/c6lMZCCYT36hK3f1EUltqMkrrH+pdso8fzTOv
	 ppfVe1zWjzjMp5mhEmgjRQ/0ST3+pkljLb5CWPMf0KW3rUdH+bVqoxXa3I7oui7IPB
	 6VA1T4NJD1KEBp8+Gl5hniKbYcd4NKdy0itmIZm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 6.6 240/301] firewire: ohci: fulfill timestamp for some local asynchronous transaction
Date: Tue, 14 May 2024 12:18:31 +0200
Message-ID: <20240514101041.315173871@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 09773bf55aeabe3fd61745d900798dc1272c778a upstream.

1394 OHCI driver generates packet data for the response subaction to the
request subaction to some local registers. In the case, the driver should
assign timestamp to them by itself.

This commit fulfills the timestamp for the subaction.

Cc: stable@vger.kernel.org
Fixes: dcadfd7f7c74 ("firewire: core: use union for callback of transaction completion")
Link: https://lore.kernel.org/r/20240429084709.707473-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firewire/ohci.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1556,6 +1556,8 @@ static int handle_at_packet(struct conte
 #define HEADER_GET_DATA_LENGTH(q)	(((q) >> 16) & 0xffff)
 #define HEADER_GET_EXTENDED_TCODE(q)	(((q) >> 0) & 0xffff)
 
+static u32 get_cycle_time(struct fw_ohci *ohci);
+
 static void handle_local_rom(struct fw_ohci *ohci,
 			     struct fw_packet *packet, u32 csr)
 {
@@ -1580,6 +1582,8 @@ static void handle_local_rom(struct fw_o
 				 (void *) ohci->config_rom + i, length);
 	}
 
+	// Timestamping on behalf of the hardware.
+	response.timestamp = cycle_time_to_ohci_tstamp(get_cycle_time(ohci));
 	fw_core_handle_response(&ohci->card, &response);
 }
 
@@ -1628,6 +1632,8 @@ static void handle_local_lock(struct fw_
 	fw_fill_response(&response, packet->header, RCODE_BUSY, NULL, 0);
 
  out:
+	// Timestamping on behalf of the hardware.
+	response.timestamp = cycle_time_to_ohci_tstamp(get_cycle_time(ohci));
 	fw_core_handle_response(&ohci->card, &response);
 }
 
@@ -1670,8 +1676,6 @@ static void handle_local_request(struct
 	}
 }
 
-static u32 get_cycle_time(struct fw_ohci *ohci);
-
 static void at_context_transmit(struct context *ctx, struct fw_packet *packet)
 {
 	unsigned long flags;


