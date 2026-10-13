Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFB53D5657;
	Tue, 13 Oct 2026 12:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895862; cv=none; b=b5hvE3HaEBYfLwA5sMJnTIlXu1U0xyPaoR9G+O389jUUh7KGsPaGojvXBmZqIfsIADUc3yspAp6B/JEJffbh6+h8gexc7B4VGjLKykDsvlXdSA0G1q8zgCdj4p6xhGpC4o0TEGZbKRO0xfHNo+DqDzhUgV/gAMNz7dbGwJ4u8c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895862; c=relaxed/simple;
	bh=a4pV7tVmkt7tlNJmbYivsKwAeLXRKvR2tVGjHEBtfvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZifmaOCGPPGWmTERWxnFMiF+tYOZaNrZR39Ag8T13OCPma3EnB4nZGZBNaYFUfzIcS267bsCAA4V54UAI5oCtA7u3qNRtdfcRBSdoEvMSWQjDGejlKixX+qGdHqLvX2pVbpObGSMk2McWVldIxJUQrqOX1NzfTj1hnRQzLLiI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08px4qA0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08px4qA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E7F1F000FF;
	Tue, 13 Oct 2026 12:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895859;
	bh=umRx8HwEK0dguMLe/PkSkCLOvl5g3o64V/EdteJqhlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=08px4qA0DpwBOvx1ElTFelSp+xvAcVxHgQS8/n2KJ13YBX6SiHSTbx+ooCb2r5sLX
	 uDMLAE6m7EK4EaGdFscFaWr8vL4uCkpXX7lBjLKsEeBwmCsqh2FtLvbHhtl0QKxzTY
	 0FXdTce1JPNhb0/btDjyV60H1e1HATRq0RJ+bxEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Georgiy Osokin <g.osokin@auroraos.dev>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@oss.qualcomm.com>
Subject: [PATCH 6.12 373/497] tee: shm: reject zero-sized allocations in tee_dyn_shm_alloc_helper()
Date: Tue, 13 Oct 2026 13:39:00 +0200
Message-ID: <20261013112916.751870426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Georgiy Osokin <g.osokin@auroraos.dev>

commit b7f925fd5226deb953c8dcdc9677d3fcc2717c00 upstream.

tee_dyn_shm_alloc_helper() derives nr_pages from a caller-supplied size
and passes it to alloc_pages_exact() without checking it. For size == 0
nr_pages is 0, and alloc_pages_exact(0) calls get_order(0), which is
documented as undefined and returns BITS_PER_LONG - PAGE_SHIFT. The page
allocator then trips its order > MAX_PAGE_ORDER warning and fails the
allocation; on a panic_on_warn kernel that ends the boot.

This can be triggered by TEE_IOC_SHM_ALLOC with struct
tee_ioctl_shm_alloc_data where size is 0.

Reject a zero page count, as register_shm_helper() already does for the
register path.

Fixes: cf4441503e20 ("tee: optee: Move pool_op helper functions")
Cc: stable@vger.kernel.org
Cc: lvc-project@linuxtesting.org
Signed-off-by: Georgiy Osokin <g.osokin@auroraos.dev>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/tee_shm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -215,6 +215,10 @@ int tee_dyn_shm_alloc_helper(struct tee_
 	unsigned int i;
 	int rc = 0;
 
+	/* get_order(0) is undefined and exceeds MAX_PAGE_ORDER. */
+	if (!nr_pages)
+		return -EINVAL;
+
 	/*
 	 * Ignore alignment since this is already going to be page aligned
 	 * and there's no need for any larger alignment.


