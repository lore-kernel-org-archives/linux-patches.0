Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826EE6311D;
	Tue, 14 May 2024 11:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685844; cv=none; b=VCnv1gaz8miDaUNBxDvRYYmlMl31StmZ5bEnrmoJpkiAYAZ/wPtg5g+Fh9fnJ7N7Txta2VYqg6xvwy6jB4/NHgvIoRXqUzzf2F9IYaeqxklWM9VLvbQtGnVMQJWZ/mFD29Q5Ug61n63e/i7EDT82gzu6/uGHdENlqRVuKdrOGtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685844; c=relaxed/simple;
	bh=iNDRcOmXBH4elN4vCkfwbuKZb47GIMcaG4p27c00+bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbUCCKdM1rNvSMQ1JvsdPnZtQssH9pyfUaYffSS6btl90gk9kcjKYbvthmpIGNkqndV7nHkY4wyc+iuiZI825wAY+A4rRxAZ8GRVBjoR/IeokPmDvZru+/WMqEaXu45bVHoYJ7MbyZKxTJ/I74/+HY0upEEksEBdyD3jE2bQlfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukvp20/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukvp20/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD095C2BD10;
	Tue, 14 May 2024 11:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685844;
	bh=iNDRcOmXBH4elN4vCkfwbuKZb47GIMcaG4p27c00+bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukvp20/jHyPizXzl/wqnmws1TOiHsxPtj/DFvKrzZMNfqPlIyXJ/0lW+wxHoQ1mVh
	 JATDznVAoRCMjAH1g4usBP+KIWKSgRzuMPRUU1dt5M/hx9hlG/VhVuvUSk0ULIeZrP
	 Cor+N+PFURXbiAnOEMnsUuNZER/Q6GSvZ94g/pTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Avdeev <me@provod.works>
Subject: [PATCH 6.6 231/301] usb: gadget: uvc: use correct buffer size when parsing configfs lists
Date: Tue, 14 May 2024 12:18:22 +0200
Message-ID: <20240514101040.977039726@linuxfoundation.org>
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

From: Ivan Avdeev <me@provod.works>

commit 650ae71c80749fc7cb8858c8049f532eaec64410 upstream.

This commit fixes uvc gadget support on 32-bit platforms.

Commit 0df28607c5cb ("usb: gadget: uvc: Generalise helper functions for
reuse") introduced a helper function __uvcg_iter_item_entries() to aid
with parsing lists of items on configfs attributes stores. This function
is a generalization of another very similar function, which used a
stack-allocated temporary buffer of fixed size for each item in the list
and used the sizeof() operator to check for potential buffer overruns.
The new function was changed to allocate the now variably sized temp
buffer on heap, but wasn't properly updated to also check for max buffer
size using the computed size instead of sizeof() operator.

As a result, the maximum item size was 7 (plus null terminator) on
64-bit platforms, and 3 on 32-bit ones. While 7 is accidentally just
barely enough, 3 is definitely too small for some of UVC configfs
attributes. For example, dwFrameInteval, specified in 100ns units,
usually has 6-digit item values, e.g. 166666 for 60fps.

Cc: stable@vger.kernel.org
Fixes: 0df28607c5cb ("usb: gadget: uvc: Generalise helper functions for reuse")
Signed-off-by: Ivan Avdeev <me@provod.works>
Link: https://lore.kernel.org/r/20240413150124.1062026-1-me@provod.works
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_configfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -92,10 +92,10 @@ static int __uvcg_iter_item_entries(cons
 
 	while (pg - page < len) {
 		i = 0;
-		while (i < sizeof(buf) && (pg - page < len) &&
+		while (i < bufsize && (pg - page < len) &&
 		       *pg != '\0' && *pg != '\n')
 			buf[i++] = *pg++;
-		if (i == sizeof(buf)) {
+		if (i == bufsize) {
 			ret = -EINVAL;
 			goto out_free_buf;
 		}


