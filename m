Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D96D2BD030;
	Wed,  8 Apr 2026 18:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674066; cv=none; b=qE4qe10n9utTW3n5ROyh3NzsXFzbqXNLKvoy25WiSSkTNOZktJuygG0HUOlw7ffo3y1+0M8gh0TeiD+fHRRmRMN7vOgE8gdKWSJiIU4ywIaTnVxHMq9GAPXUGT+DLlFw+QXRFwBLZ/8I1slpq97DnOVzi5povnvk0B+Kr6aZ9c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674066; c=relaxed/simple;
	bh=oT2lfgBoE/2Sm8iJZkNx/VDPIviN2sLhlE6qWeVx6Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRObNsLBCDOLxRy0tMGYTtj1FE52F8/DvxgJjI3ZtvCWHlRFFFJOveMHMDVDAmcvo+7WXJ8AfAq6CNp0CCzCsatfd5+eB2hc8kBzyQwYm7uA2EtHyaDBWrHelWFdAqJWqfaLsfnGqBWofsh6RTISJJrP0ELj+gDbvmSyFjo7vQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XflAaftn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XflAaftn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23596C19421;
	Wed,  8 Apr 2026 18:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674066;
	bh=oT2lfgBoE/2Sm8iJZkNx/VDPIviN2sLhlE6qWeVx6Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XflAaftnop3bbACymX/d/k7VW/Z2JwZyU0K+ylTDXDkjXbRooy61REC8JeswlVe4M
	 ExPoe67sS6xWsOTNt0bHQdZ6lNU2hr8fywGnrnMeP6+BBeflOW5YcRiyFDDxEy6985
	 9Uz0+tHohdhl3l4rn4nBiH22udCDEMqKfxaseShE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Urban <surban@surban.net>,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.12 196/242] usb: gadget: dummy_hcd: fix premature URB completion when ZLP follows partial transfer
Date: Wed,  8 Apr 2026 20:03:56 +0200
Message-ID: <20260408175934.419624467@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Urban <surban@surban.net>

commit f50200dd44125e445a6164e88c217472fa79cdbc upstream.

When a gadget request is only partially transferred in transfer()
because the per-frame bandwidth budget is exhausted, the loop advances
to the next queued request. If that next request is a zero-length
packet (ZLP), len evaluates to zero and the code takes the
unlikely(len == 0) path, which sets is_short = 1. This bypasses the
bandwidth guard ("limit < ep->ep.maxpacket && limit < len") that
lives in the else branch and would otherwise break out of the loop for
non-zero requests. The is_short path then completes the URB before all
data from the first request has been transferred.

Reproducer (bulk IN, high speed):

  Device side (FunctionFS with Linux AIO):
    1. Queue a 65024-byte write via io_submit (127 * 512, i.e. a
       multiple of the HS bulk max packet size).
    2. Immediately queue a zero-length write (ZLP) via io_submit.

  Host side:
    3. Submit a 65536-byte bulk IN URB.

  Expected: URB completes with actual_length = 65024.
  Actual:   URB completes with actual_length = 53248, losing 11776
            bytes that leak into subsequent URBs.

At high speed the per-frame budget is 53248 bytes (512 * 13 * 8).
The 65024-byte request exhausts this budget after 53248 bytes, leaving
the request incomplete (req->req.actual < req->req.length). Neither
the request nor the URB is finished, and rescan is 0, so the loop
advances to the ZLP. For the ZLP, dev_len = 0, so len = min(12288, 0)
= 0, taking the unlikely(len == 0) path and setting is_short = 1.
The is_short handler then sets *status = 0, completing the URB with
only 53248 of the expected 65024 bytes.

Fix this by breaking out of the loop when the current request has
remaining data (req->req.actual < req->req.length). The request
resumes on the next timer tick, preserving correct data ordering.

Signed-off-by: Sebastian Urban <surban@surban.net>
Cc: stable <stable@kernel.org>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260315151045.1155850-1-surban@surban.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -1537,6 +1537,12 @@ top:
 		/* rescan to continue with any other queued i/o */
 		if (rescan)
 			goto top;
+
+		/* request not fully transferred; stop iterating to
+		 * preserve data ordering across queued requests.
+		 */
+		if (req->req.actual < req->req.length)
+			break;
 	}
 	return sent;
 }


