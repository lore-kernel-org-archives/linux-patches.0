Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B003ACEFE;
	Tue, 21 Jul 2026 21:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670374; cv=none; b=WmjN7ZLyiETeUDZKfdZXYyhxAbiO43aYFhhZxf1f41T6LkRyO9Q9dlgj8tzTZ8bIhByGsoy+5qH5CWeZLY8UiKkKyY1bh0GhjZY60MatUpLwJCMmAYZVo/dtelWV27IebgGXosf9GEuFQXORkVguSYEY9ZL0Es5hvFqRffT0rs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670374; c=relaxed/simple;
	bh=lDWPAnBD+JIXhSYKyo7Jo8fPLNEgSeMkQucRDZQtZR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkTivZILrDGUFK2nfJf2MOH8QiLfB7bOI7nR23J5eQ9dGVvu4F0jDW0+dr9mUlJeNnJgiRcY0aygz3fz3ZDPNYQmx9hcUqHI48kT93EKxHb+jXrG2pU8WdZiro+EIgZAPa4d3YWx4K5cwerkbQoGcin27ZTDvni9uxiniVFZs1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njAUbjlH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njAUbjlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878E91F00A3A;
	Tue, 21 Jul 2026 21:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670373;
	bh=ur/gEPAlDh4gtfturOSOUUa+rQt3zRiGKP+vrTjn8+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njAUbjlHOJieHj4food/bTQuE996jeqEULOtjkK7GBQvFaP7WyXkSgKp8d38CFsHL
	 mJEL/O5R5mHn3pwcLgDsCdLaTk3PgnWcdsMlZHcQSL/AKJim4/9AvvT9Nxh5SYW8fM
	 JyceHndlNhEgyxfswEBr//5GXIcRxWSjqkZUGeNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.1 0908/1067] s390/monwriter: Reject buffer reuse with different data length
Date: Tue, 21 Jul 2026 17:25:09 +0200
Message-ID: <20260721152444.848832114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -122,6 +122,9 @@ static int monwrite_new_hdr(struct mon_p
 			kfree(monbuf->data);
 			kfree(monbuf);
 			monbuf = NULL;
+		} else if (monbuf->hdr.datalen != monhdr->datalen) {
+			/* Data with buffer reuse must not change its length */
+			return -EINVAL;
 		}
 	} else if (monhdr->mon_function != MONWRITE_STOP_INTERVAL) {
 		if (mon_buf_count >= mon_max_bufs)


