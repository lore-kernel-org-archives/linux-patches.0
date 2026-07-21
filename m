Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEA6442FCF;
	Tue, 21 Jul 2026 20:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667579; cv=none; b=obCO7ghAWRGXbLZvsrZnwDcV6j6S3BTSgP8rpjPePBXq0sO2JZXVdHOmcBS4M239XJoujMZnISQDHfye76e7I5rUnbnmhI8nMnRBsDT7w6pRDPcKjgpu/3HzSDzKXJQLsz7YxzWVEUDka8g4PGZZh8teAX12cfKxuikRMaPBmpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667579; c=relaxed/simple;
	bh=RsASm/FaLMsjcuR5vtv75f+TFEBPH1acO3qUMH/Bjmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuL1i9DwZchShs+FcJFkP0NfZzzHPnsBO0GmVQbEVPHCjJQHRyThq580A9cVTikPWDBQjm45WI0lVlAoLnEswT4UD8ptsirWE8z4mOyYVoExwCbZLfLapBf9Fhxv2cugih3ZkzGQvfOCZx9gwyBk9L6601a9HN2PWZmfTZTGPHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3c07RkF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3c07RkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF901F000E9;
	Tue, 21 Jul 2026 20:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667577;
	bh=VX+lFsKg5lKEfVtzJAfzub/KagJXgb+Zriiw9iRT9gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3c07RkFAF0qndKI7/olHf2Si73Dk0XuYmVa+OcmKEwzzzNCX7DlO3acXsw74VIX2
	 ccsgTr7x9VDZnpUvECs2E/DmJee4TT0XZSzuOGL5o6B4aNr8dJBgmiaYuDIydd+QGM
	 71KreoWT7XVwKN6y1BGeGiYXqUFYXSovSvfcUi8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 1115/1266] s390/monwriter: Reject buffer reuse with different data length
Date: Tue, 21 Jul 2026 17:25:52 +0200
Message-ID: <20260721152506.753325465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


