Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599CB47B422;
	Tue, 16 Jun 2026 17:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631095; cv=none; b=Lh86DWF+n4bMLF+W3Fir+y9RQ5nHpf/VzYyKEhM816ACTLSsxZaHGfAxpNt+WrpqD41vogqcrI6d86kwMaPtRqSfPvgdKUauLCC6GIM9Z/z+Inb8MGNdFJdwwO8OhUCwDJrNPaH04un6cgh+1C+ip/iN3aLnDqhhOhQyyacMVtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631095; c=relaxed/simple;
	bh=TvUxwqGNO9UzerTS/wEV0oDvLlBq6wNxuFW3V/5iDMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3ZT+UOi9e6P5WXFqlzwTdtvmsc+UeTdDK4QZKDCUUkw/Ol+x29AvdA3yB8idMN3dpnou1dUWRTSzjFS1ykIdvKkHe9DbvQ7/st1LjAjM5v1nABFbhcaGEBvG1fnpysRwdJVC1DwkBckIjqVdqmLM4D2hjECHCxtiqYqYKmO9a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddwk2N0w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddwk2N0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BE01F00A3A;
	Tue, 16 Jun 2026 17:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631094;
	bh=PSW77uzTO3uornqDQBFrEiydl70qdFAMMjbK9Ya2YqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddwk2N0w3CeFMu8odBNYNQ1bcEYUlgBck2iHqRdhdPHY43TeZk4rRtNlDorGw1aIO
	 ujLW7GbHWytvB4Xmf3S3bGybVLXmo7e6CqNHdgREp28Z8PnF0tsTV+5BkIcwq9NDiY
	 kN4BDcIYW/hnlguA/Oz0WJ3hHgXPngwIDpfMdA/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 155/522] USB: serial: mxuport: fix memory corruption with small endpoint
Date: Tue, 16 Jun 2026 20:25:02 +0530
Message-ID: <20260616145133.355296606@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 4085f0dbb1ce2251c9a5938d693de6593f0ab2bd upstream.

Make sure that the bulk-out endpoint max packet size is at least eight
bytes to avoid user-controlled slab corruption should a malicious device
report a smaller size.

Fixes: ee467a1f2066 ("USB: serial: add Moxa UPORT 12XX/14XX/16XX driver")
Cc: stable@vger.kernel.org	# 3.14
Cc: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/mxuport.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/mxuport.c
+++ b/drivers/usb/serial/mxuport.c
@@ -962,6 +962,14 @@ static int mxuport_calc_num_ports(struct
 	 */
 	BUILD_BUG_ON(ARRAY_SIZE(epds->bulk_out) < 16);
 
+	/*
+	 * The bulk-out buffers must be large enough for the four-byte header
+	 * (and following data), but assume anything smaller than eight bytes
+	 * is broken.
+	 */
+	if (usb_endpoint_maxp(epds->bulk_out[0]) < 8)
+		return -EINVAL;
+
 	for (i = 1; i < num_ports; ++i)
 		epds->bulk_out[i] = epds->bulk_out[0];
 


