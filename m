Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0203C15705A;
	Mon, 29 Jan 2024 17:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548202; cv=none; b=plFRp89i62W2IupZTEwfPzmH85/P0bfqLcDfhYF0w8otcW7zzm6e7Sm8CkKhpAvvJwLbe1OtobbP6izl1fBNR3UzvVC4QgxnFRb8u9eM634iXYXuF75rubrQHu4ixemPxCOHgJQJfyvo7DJwErMVE4+Nkmu/GS84z1XHrYKScek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548202; c=relaxed/simple;
	bh=mQkoEKOrCphnGt/oixw9H6jWjBP9JoH8tSVh1GALTuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mi2cp8R7Rl3nPACuq+up3Sw3YZ1uKRxS3eeRGghoP5AyxbC/i4m6bFNo3yfcYixN9VSBIatv3Y+4ygTq6ikkGMscXufHqIbKM227aefxW42hs4Y5H/d3cno5sBxhSh63xl/KP2iugcrclCyA54nKIR6MERMsyst3cahpj9kKuc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdFs071f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdFs071f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA91C433F1;
	Mon, 29 Jan 2024 17:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548201;
	bh=mQkoEKOrCphnGt/oixw9H6jWjBP9JoH8tSVh1GALTuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdFs071fq4cUgTNttQeXOvOnzDnNkdJ+a4j9Dz72tIuMVRVxMvXIVsFIP/ZV1gh6V
	 RsT7yercgI81XUNHIEDhN/II2EH7MhgAcpFgQKlI+LCaKg7QRwfwfVtXqDaY8NMRyn
	 EF7aiG6zYEH8M6swSxB54xqg5hW8GTaUPvcptUl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janosch Frank <frankja@linux.ibm.com>,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.1 015/185] s390/vfio-ap: unpin pages on gisc registration failure
Date: Mon, 29 Jan 2024 09:03:35 -0800
Message-ID: <20240129165959.087608271@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Krowiak <akrowiak@linux.ibm.com>

commit 7b2d039da622daa9ba259ac6f38701d542b237c3 upstream.

In the vfio_ap_irq_enable function, after the page containing the
notification indicator byte (NIB) is pinned, the function attempts
to register the guest ISC. If registration fails, the function sets the
status response code and returns without unpinning the page containing
the NIB. In order to avoid a memory leak, the NIB should be unpinned before
returning from the vfio_ap_irq_enable function.

Co-developed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Fixes: 783f0a3ccd79 ("s390/vfio-ap: add s390dbf logging to the vfio_ap_irq_enable function")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231109164427.460493-2-akrowiak@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -425,6 +425,7 @@ static struct ap_queue_status vfio_ap_ir
 		VFIO_AP_DBF_WARN("%s: gisc registration failed: nisc=%d, isc=%d, apqn=%#04x\n",
 				 __func__, nisc, isc, q->apqn);
 
+		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
 		status.response_code = AP_RESPONSE_INVALID_GISA;
 		return status;
 	}


