Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C682DC79B;
	Thu, 16 Jul 2026 13:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209771; cv=none; b=f9OMRhIBzC/kAm9AAu8Iw3CPu8prbphrHP2J/1r7liXPokWtCRgzGaju8IU+P8u8IeDOT+GDb9ZaDFO343LIkEaQC31Rv1o26hrkiXkHVn3mNpRWD7YtdV3ij6f1RVCLTa6qRwYAOi7BTjwqcJjckkMbVLhV2K8+nMmxNAGDmzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209771; c=relaxed/simple;
	bh=MtOZAJrV3vxcWw6LXDKQyNy0cLjpa/Z/Tqm1PSQz4dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCnIgUBXN7fR3Az80Ge+8q8T9o4nLYC0LlUqbooIxWQGdstO+uPGocYFeGSDCVo03gvs+vvr5+DIeO78akdXN2NaSIRdMrHZHB6qpgw3Tukf+BPKN9GSH4CvIaBG5YW9v018cx7PB+tJrTsN3p0jnCVOKcmnDmLftffvgLm8ecM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyf04kG/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyf04kG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C439A1F00A3A;
	Thu, 16 Jul 2026 13:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209765;
	bh=sny/7p9wD3kU1Z6pP0CU9Sb1A33BUcAmpZTqDaH8yrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cyf04kG/Ty/5SC2/Q2pYlUbhw4tn8pz8tQ9b48CQcuJdF20zpL6kyHCdR5rjuoakO
	 O4o3/xjdFChdUA/2CJiWZwLg+AXgKwiUsobGCJoHDrn3zjv8r8qs+12KCy21stKTK2
	 dfM+F9vjBwOiNDeQ9I0/m21s9KDlhmq2feFpVkQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.1 266/518] HID: uhid: convert to hid_safe_input_report()
Date: Thu, 16 Jul 2026 15:28:54 +0200
Message-ID: <20260716133053.637979146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 63a694c51bf120a37550890b8e7736b4888985e9 upstream.

Commit 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing
bogus memset()"), added a check in hid_report_raw_event() to reject
reports if the received data size is smaller than expected. This was
intended to prevent OOB errors by no longer allowing zeroing-out of
shorter reports due to the lack of buffer size information.

However, this leads to regressions in hid_report_raw_event(), where
shorter than expected reports are rejected, even though their buffers
are sufficiently large to be zero-padded.

To solve this issue, Benjamin introduced a safer alternative in commit
206342541fc8 ("HID: core: introduce hid_safe_input_report()"), which
forwards the buffer size and allows hid_report_raw_event() to safely
zero-pad the data.

Convert uhid to use hid_safe_input_report() and pass UHID_DATA_MAX as
the buffer size. This prevents the reported regressions [1], allowing
hid core to zero-pad the shorter reports safely as expected.

Cc: stable@vger.kernel.org
Fixes: 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing bogus memset()")
Closes: https://lore.kernel.org/all/ahsh0UtTX6e0ZeHa@google.com/ [1]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Lee Jones <lee@kernel.org>
Closes: https://lore.kernel.org/all/ahsh0UtTX6e0ZeHa@google.com/
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/uhid.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -595,8 +595,8 @@ static int uhid_dev_input(struct uhid_de
 	if (!READ_ONCE(uhid->running))
 		return -EINVAL;
 
-	hid_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input.data,
-			 min_t(size_t, ev->u.input.size, UHID_DATA_MAX), 0);
+	hid_safe_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input.data, UHID_DATA_MAX,
+			      min_t(size_t, ev->u.input.size, UHID_DATA_MAX), 0);
 
 	return 0;
 }
@@ -606,8 +606,8 @@ static int uhid_dev_input2(struct uhid_d
 	if (!READ_ONCE(uhid->running))
 		return -EINVAL;
 
-	hid_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input2.data,
-			 min_t(size_t, ev->u.input2.size, UHID_DATA_MAX), 0);
+	hid_safe_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input2.data, UHID_DATA_MAX,
+			      min_t(size_t, ev->u.input2.size, UHID_DATA_MAX), 0);
 
 	return 0;
 }


