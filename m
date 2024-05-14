Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B7769950;
	Tue, 14 May 2024 10:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683709; cv=none; b=NZmt+VwUmYvJngrDrYtxf3uqOrU3+y0P+1MaEl/nB+M1WjwKUL67bm2Rx42+9Cz1iEynPId0pofnVwWOa2Hlu7UBiq/ktdrdr5iUD7EQtFUWy+hc0uCSJSTv96Y7UHBiP9jS4PEB4jbhAslFqzrkKweAgOzW+nnBkm8uR8Jxjg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683709; c=relaxed/simple;
	bh=f9QjVPDC/VCgUpHTmFqxQs9a2UnCTi93MFo/ndD7Eks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dA6gCi98XUyaByfqbmKb74seaXJaSsIqx01ur3Dey3Yvl0nnB30jbfKmRJI/8TVBvDz2JjgAPaWwToUSqF1TKOeDR3XVZ6DIIrfE+QXNSODoe18U9PNbkstkOMQw4SgyQlYZ9Fcc0+7H9fXfuh0MYyoS1XCFco3ZRzUUAcXSikg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWQgVEH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWQgVEH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B76C2BD10;
	Tue, 14 May 2024 10:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683709;
	bh=f9QjVPDC/VCgUpHTmFqxQs9a2UnCTi93MFo/ndD7Eks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWQgVEH2f1eqLKKgUHO+ZJDkJkL8kkUhi2tPEwEg42xYRdokOcr98cKcwL9xJYQsv
	 uf3+BOmL7VUJkx/nriqydm5T9zteLNNzOMjJYmVt/uD2wXZTJIpAkQOGK+vPszhBo7
	 OPsP3cOySx94fFfVZapNGSRvdeKp3v+YmO6WYQEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 6.8 261/336] firewire: ohci: fulfill timestamp for some local asynchronous transaction
Date: Tue, 14 May 2024 12:17:45 +0200
Message-ID: <20240514101048.468741624@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


