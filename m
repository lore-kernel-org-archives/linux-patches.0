Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A6A47010C;
	Tue, 21 Jul 2026 20:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664142; cv=none; b=mbWXgAE9BClSyT2U4DlJwwSknK+L05sTHAiKyysmfZ8nKanjTNLFB0o8f53+34VyLVpG4osEmATDMNoi42RpC8/DZ3yuphTLWCQs4XhBCjYla5t7OM1iBOwQsP8O9ehpLNd5ZvAWzjopTAYc/oWLgK/7IwBnUR2bPBFn7BSo7oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664142; c=relaxed/simple;
	bh=wSi22vV7ELQXd/qw7XmOFxT8CD2NV14M36eORl5qL7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3xacreRx1qLIYjys9trTtKjYIh9gXodu+QF15RGn2sprbFRgxL0+IIcXeO7A5EUVcZWjJE5YM8fBNYTYjGiYnWvCLZhNIjj2Nyk602+r6XTKJuU64Wd3JEP560OKqo0A8Ys4zGruCyUugItwr6Wx/PjBKaLPmTpxa1GBy3ChTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p99MGhXs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p99MGhXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49DA1F00A3A;
	Tue, 21 Jul 2026 20:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664141;
	bh=Z9VOIxPBUh4sDOpjAyQCTfyIjOeoiiBfGOt6stAuZAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p99MGhXs4y9IzYYaSm9fA94R71YSh8HSjthdY9VFTClxQILIdE1SNYVSnON2ZIzWv
	 CORy3tOytCI+AtbYRzFvb2scKzYxeCw0xJm7p6CfROpYuM1ahoyk02PAaxcw+LDuuV
	 wEvqQ/azK745jUoXLHV2zoudNd21M9VXCiNt2QII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.12 1088/1276] s390/monwriter: Reject buffer reuse with different data length
Date: Tue, 21 Jul 2026 17:25:31 +0200
Message-ID: <20260721152510.333044112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


