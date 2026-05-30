Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFFD3BF667;
	Sat, 30 May 2026 17:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163486; cv=none; b=V3D5GKg1iUKj6vSs4vyb5fEJPRIlGezG8kf2Gsh8qVF12eD/y9KT/XYvMeKoWHtXGJVrrURcaUUmNrV45Sgye+Logvfn3YxH2z8ueZh+h/djPyyxetvKVuTIz2a2Rje56F/GR6ev7LDPAc8Tvb2lF+aOK4J8o/1t3WqH3ICDSnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163486; c=relaxed/simple;
	bh=9ADxpyPbSSt2cMtfIkHavY0BsLJuoohBY1EzisTJ1ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDEGkh9p7y2dP8Jn7RLGiIaGVTbQrEYVDKS2yAQpySvAaJdWBYGMkA2FtSK8iplwLUg188++FB59XIbjwRG4IYJflY5VCVFl0iwguujS1S62hYCOcyRqNj6O2lrpOpocZ/zyyMoz2YKvf+sKASQVbY0sdLq93D8dfJGd6MIujVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QI/9noX4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QI/9noX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622081F00893;
	Sat, 30 May 2026 17:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163485;
	bh=zzYLoH+TsZ2odrrFj89ANsz20T0dCSQKBaA6CbhvaMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QI/9noX4PFhsORJMsBNsZfwHmIqoPjyilVhi4i8swyfzJQkv8m3lPb1hki1BgfE14
	 +Y5+KRUpWcA5JyoSk4uhpYMDlw+FHcXqwbbo6Fa/y0u02Tuvqq0ittmAHUK/DCI0mx
	 UTfyV1rQpysDHaatF4vXVkEej2VvWi4wmm+Nktg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 5.15 273/776] ipmi: Check event message buffer response for bad data
Date: Sat, 30 May 2026 17:59:47 +0200
Message-ID: <20260530160247.613694070@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

commit 36920f30e78e69df01f9691c470b6f3ba8aebf98 upstream.

The event message buffer response data size got checked later when
processing, but check it right after the response comes back.  It
appears some BMCs may return an empty message instead of an error
when fetching events.

There are apparently some new BMCs that make this error, so we need to
compensate.

Reported-by: Matt Fleming <mfleming@cloudflare.com>
Closes: https://lore.kernel.org/lkml/20260415115930.3428942-1-matt@readmodwrite.com/
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_si_intf.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -624,7 +624,13 @@ static void handle_transaction_done(stru
 		 */
 		msg = smi_info->curr_msg;
 		smi_info->curr_msg = NULL;
-		if (msg->rsp[2] != 0) {
+		/*
+		 * It appears some BMCs, with no event data, return no
+		 * data in the message and not a 0x80 error as the
+		 * spec says they should.  Shut down processing if
+		 * the data is not the right length.
+		 */
+		if (msg->rsp[2] != 0 || msg->rsp_size != 19) {
 			/* Error getting event, probably done. */
 			msg->done(msg);
 


