Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A78F21D5B0;
	Tue, 17 Mar 2026 17:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768162; cv=none; b=DB4LThH5GGX5brjZlXAZSdlYgQ9UMCGw7XWpkKmYcXr+gzmdepfM4A/HTAlZMSqTNU4X6UiMUCBRsFMBbR2qYa6JweMLYhYuLbWgIzAZxK3jN2dgYW4lUHLrRUSQI6uX+JzE3jZKKqeYv4lLRbKUTks6AN0/kpz7He2A5ML0WNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768162; c=relaxed/simple;
	bh=GP2uet8fKYRBg1kPrD/u1b4XSl+xJ5dnqCkP/AF2QU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SESXJBg3CcICEFHytzNInKBBXSLUNW2P2DqdBu7rDVZGeyZNZvHctFfpD3jakzzLqi4jVU4C3t0HAaI0n+1QEZR4+RR2NJ1oQoZHmpHXqB0HAEI3He+XGXhXFdNqc3gqCmRpGjANQVNTuvo28vCKbeoJlhQy7UBsbYCFAnU5534=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rm7rD1et; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rm7rD1et"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9E3C2BCAF;
	Tue, 17 Mar 2026 17:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768162;
	bh=GP2uet8fKYRBg1kPrD/u1b4XSl+xJ5dnqCkP/AF2QU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rm7rD1et5wBrloO3TSGD+1P8ymjR1fT8GFl7ZI1yqBN4rWzzbNJfAKEOC5qLdfXWk
	 /JTRgolxyvfscl90doaddkIpE5oVr9PiSGUlNmbplca39EVo5c1UFx9ZP4qKpAYZM8
	 7HhEOhbpQCSASo1ejGl515Sg7F3UBfPAqfn4nAhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luka Gejak <luka.gejak@linux.dev>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.18 212/333] staging: rtl8723bs: fix potential out-of-bounds read in rtw_restruct_wmm_ie
Date: Tue, 17 Mar 2026 17:34:01 +0100
Message-ID: <20260317163007.225592717@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luka Gejak <luka.gejak@linux.dev>

commit a75281626fc8fa6dc6c9cc314ee423e8bc45203b upstream.

The current code checks 'i + 5 < in_len' at the end of the if statement.
However, it accesses 'in_ie[i + 5]' before that check, which can lead
to an out-of-bounds read. Move the length check to the beginning of the
conditional to ensure the index is within bounds before accessing the
array.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20260224132647.11642-2-luka.gejak@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -2008,7 +2008,10 @@ int rtw_restruct_wmm_ie(struct adapter *
 	while (i < in_len) {
 		ielength = initial_out_len;
 
-		if (in_ie[i] == 0xDD && in_ie[i+2] == 0x00 && in_ie[i+3] == 0x50  && in_ie[i+4] == 0xF2 && in_ie[i+5] == 0x02 && i+5 < in_len) { /* WMM element ID and OUI */
+		if (i + 5 < in_len &&
+		    in_ie[i] == 0xDD && in_ie[i + 2] == 0x00 &&
+		    in_ie[i + 3] == 0x50 && in_ie[i + 4] == 0xF2 &&
+		    in_ie[i + 5] == 0x02) {
 			for (j = i; j < i + 9; j++) {
 				out_ie[ielength] = in_ie[j];
 				ielength++;


