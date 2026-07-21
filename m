Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89CE47127A;
	Tue, 21 Jul 2026 18:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659248; cv=none; b=kngtLT3Fw1pCe+M7pepyREPRS8ONSrPR4osq/+9kpMlHtzLX9gLjfLaZvAyTS1E7YvN0RgnGI5JWeVEiG+e9u761CwxNc/uKFZQ6ePDrbbuS6kKJxHTC3KqHvVspKdiAfbkikyT83MO4pb0wQ4v0LKW2HxFu0oeYdEcg4MG00H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659248; c=relaxed/simple;
	bh=Hc+VjRsUE5c7+eBfLvlwR2VIkG3tuwCFF5jnsk/eDB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gf2gXg4wJjzoX0xKPT1lHqGNrE1SZa5XNNhyE08vDonibBlp7jH1Mb3BkrGbUXUUM3acEx5/FY55f50JxU+MmK6647Zp/jhGrvCZdkbnj23GrF6Q3OjqIhiFUsVXS9R5VVn/lvOC2mczpF4w+t66sYCyf5f5WjaPdDN4OJPevws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvrGKG59; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvrGKG59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4451F00A3D;
	Tue, 21 Jul 2026 18:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659247;
	bh=7zTmgju5LKYSNcMHbFF6uu/BDxbu0IjSijQGT1sjOmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvrGKG596vR5bU/e0m7SOK13AUK/Xp+iybVR4pJxJpw88UhT054A5MYxTZAk4brNL
	 YVbj+GUAxSfHKesKztXEJNb/cmKkkNRV3Ae1eDGXhqgQlaPo3uH2i3F1/juB1Y6kyB
	 b71KWFPBuvEx8hPtV3bH5iyVPHO+ljycHWgz4TZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 1450/1611] s390/monwriter: Reject buffer reuse with different data length
Date: Tue, 21 Jul 2026 17:26:06 +0200
Message-ID: <20260721152548.063959723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -123,6 +123,9 @@ static int monwrite_new_hdr(struct mon_p
 			kfree(monbuf->data);
 			kfree(monbuf);
 			monbuf = NULL;
+		} else if (monbuf->hdr.datalen != monhdr->datalen) {
+			/* Data with buffer reuse must not change its length */
+			return -EINVAL;
 		}
 	} else if (monhdr->mon_function != MONWRITE_STOP_INTERVAL) {
 		if (mon_buf_count >= mon_max_bufs)


