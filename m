Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBB4415F10;
	Tue, 21 Jul 2026 22:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674465; cv=none; b=DqjAKkxArBIBosM6bFUjdUTEsCrnWsyB5i3JOdk0Pacj5JLwaq0sPMQY2FmyJK2Bvlwd8a9wEJGyeJDFt+hni1JdOXlwOEo7MdfkpN1KqAiZ9su9YdW6i7BHXbdEvrWttoDcVPf9WCleP0sx8BUEIL35U4NNvYr/Aar3hp+IkkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674465; c=relaxed/simple;
	bh=6BlB9BSQXNsUAnmpmeZ9MNidLWb8ZMyITrxSINe056g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUc/mIt9MscyXlK3ATeq8MVVlqEQzuHVgXAVq+rUpn7a7HLTaFcigvFXQ1M3ZRvnjukO4J6Mw49mC9a2sqQRkY3OVIhWS0fDhSOsj4vTXFeTvNY3+MprketJNUkxKypWZD46bbx9dtr39G82Az3JGGAoOX4GUbLQgXEO11pmcU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+ZP7zB2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+ZP7zB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646CC1F000E9;
	Tue, 21 Jul 2026 22:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674463;
	bh=7abN17faBYJDOIBHnscJ8X/l7x4qUz6iiuWn6g0ZbPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+ZP7zB27b08C1RcNa5o4dTw5efWJJhDpid30SCl2QaD/4cJoti0xvGi8UckfEfFw
	 tkYSDF6BxTV/jzS9yP5qI4U0r538pl4vDHiN5JYIwzg+scmgCeGoiC+h6LSLy3fEFH
	 kmzSsP3I5FCAq1NrWNvRvneamxCOY4RQ4woqI0E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 552/699] s390/monwriter: Reject buffer reuse with different data length
Date: Tue, 21 Jul 2026 17:25:11 +0200
Message-ID: <20260721152408.156397419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit 2995ccec260caa9e85b3301a4aba1e66ed80ad74 upstream.

When data buffers are reused, e.g. for interval sample records, the
first record determines the data length, and the size of the buffer for
user copy. Current monwriter code does not check if the data length was
changed for subsequent records, which also would never happen for valid
user programs.

However, a malicious user could change the data length, resulting in out
of bounds user copy to the kernel buffer, and memory corruption. By
default, the monwriter misc device is created with root-only permissions,
so practical impact is typically low.

Fix this by checking for changed data length and rejecting such records.

Cc: stable@vger.kernel.org
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/char/monwriter.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/s390/char/monwriter.c
+++ b/drivers/s390/char/monwriter.c
@@ -126,6 +126,9 @@ static int monwrite_new_hdr(struct mon_p
 			kfree(monbuf->data);
 			kfree(monbuf);
 			monbuf = NULL;
+		} else if (monbuf->hdr.datalen != monhdr->datalen) {
+			/* Data with buffer reuse must not change its length */
+			return -EINVAL;
 		}
 	} else if (monhdr->mon_function != MONWRITE_STOP_INTERVAL) {
 		if (mon_buf_count >= mon_max_bufs)


