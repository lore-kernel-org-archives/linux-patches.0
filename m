Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58147363081;
	Tue, 21 Jul 2026 17:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655141; cv=none; b=Kmsu3EYbWhYWlbOyahA+XbqMhKe2N0buUxPdnMDt2ODTJ2TfhrZn1fbb+Yg3A+s4GL5xeMwCarBVQPnIhXAJk47wZfWWWoJ+vH/zaHCbjIpTNGoypgs6fnkfKtxcgHj6lyQA7qna4tXlk79KV3eqnkbMMZDD417oSCFh9ZTFuKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655141; c=relaxed/simple;
	bh=RIZFHQu7GWP+NBC072dfXHb7SMpDeK9/kL3aj/0Rjpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g70c14mwi1Ze8+1MlXGCpqGmCSwG3JSHzUdz1hNnk2/HCNA2T/CBbPYge8KUEFf/5BYhxS+Q/w8pBJmfNgqVbMUZci1rsinkHzv+PbFqMtIE0Z2uePxKNE1/q9uH6wSZTqFFII6XiUGSTgmd+eCkoaTmOyMemsZyk7C7EMuFfXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6MpvvOn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6MpvvOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDC51F000E9;
	Tue, 21 Jul 2026 17:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655140;
	bh=Pn1ub+sEo+EpS0CrTOIsNwT5q8q/DtBmvsg/E5fstU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a6MpvvOna3keFHDtZM92jErzjj2x4X9eXvht0V9JcPcSUCyBlvmP4wzV5dlm3Mo3t
	 1mcICfhHrgDhX6Dl+X8G6m1uz8GovGSXJ5Ph6Ba1mqQ88gDkarpPqxQsa0b82KN6zC
	 Bryz3sX2+JKURW/wKFNTJB4Lfr/HjwVp8aG6gBxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 7.1 1970/2077] s390/monwriter: Reject buffer reuse with different data length
Date: Tue, 21 Jul 2026 17:27:23 +0200
Message-ID: <20260721152639.169528882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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


