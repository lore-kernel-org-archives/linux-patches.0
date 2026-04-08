Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1443537FC;
	Wed,  8 Apr 2026 18:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672278; cv=none; b=CWWhXknJRWPK/rSRZ3B6oYBSgDu7gICpHaSldDL98BOaY0vLJa9U2cNTNeg0rHO/1oZZXFLGvRBrVWe/bGJodGRI0nwV+48fWWO54Zm9BmX+QB8Ww3cXPyNdIR8Fg2JbDtNE+Q4hQvTqH2xD42DvYPibZs2j6PUvDLTlUJb4mdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672278; c=relaxed/simple;
	bh=LayHbW1TzWP8ZAVXYu1H0jb/3s6eq4bAVElfHaUi1Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuS/PLZQoKskrBg3b+j71Q0AHBuA0Jd5SIenBLE29fWeKTytGpEgeY0XLzoRLpoyvwLI806RRhB0LcKbmPYQfR07F8SYTI2KTj+sfCvAL3d/lnZm/bIBscQdOKj9OoCvf4Z4oOATasxYytY9qFRrafU6Fv0lJ0odYlGfUjmF5Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHbgHQgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHbgHQgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A39C19421;
	Wed,  8 Apr 2026 18:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672278;
	bh=LayHbW1TzWP8ZAVXYu1H0jb/3s6eq4bAVElfHaUi1Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHbgHQgXd6kFV9lmxDYsdO/0ZK8vn0CpssvsBEur9uGNWE9ZxBsMt1YEsBxmfpes7
	 x6XvyoDp1vwnfoo2UG0y0Q1a9gjdC3W7U9j0O4QfCJUXEJq3i5WjvmtsD5UDQgN8Fw
	 b9kZGDpMdNjPRRT5+FBlUgxeDWaRXc9j4H/w7+Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Urban <surban@surban.net>,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 257/312] usb: gadget: dummy_hcd: fix premature URB completion when ZLP follows partial transfer
Date: Wed,  8 Apr 2026 20:02:54 +0200
Message-ID: <20260408175943.345003208@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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
@@ -1538,6 +1538,12 @@ top:
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


