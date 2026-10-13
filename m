Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABDA1DDA18;
	Tue, 13 Oct 2026 12:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892896; cv=none; b=fLS5yEDNYGnJOZ7PuSQOsfLPT1iVv3uZV05TIRAj0JWR3fNPojQzdinW8QMHOduIXY3GbyEGm6MDQwJTxFn3uLFJ54RgAQgtzsIVQSmu0iUnh6WUTaHyjrPHJkiPtpdj0slJzrkw2Abv7xX2EpedGM1toDHihbopg9Sw4lymqSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892896; c=relaxed/simple;
	bh=rYp/0fQZTXE0s58XD4bfzEC1J2QOmf+NB/9IvSUv1dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiucWVjsi0Z1gFxmXJ8fz9wgHdUuhJ84XrwOtZIljl4h2L/mpbCUvxq5LhrzepdjjkccLxWLNmEk3y2shbl0JOzJ0vwS8+J5p87e1OGjfHNkp+05gW+iu3hjDn6/HhmBrR8VC68Dni/7N9cGlNm+Gvxc0zwLkioUiLxOZHALO4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXQDpe9m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXQDpe9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD061F00893;
	Tue, 13 Oct 2026 12:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892895;
	bh=RK6xJHGsTskC6ONs2cL87gmABcWWQYgVy+TEV6kTlKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXQDpe9mcXT0C9dNXTWnQ208h8wxXgjaKHXj5F+zvfybh7W0gJRPcOWGLAzcs0c0l
	 OeqGnAlGkeG0n5QYTnD8hxSgsZ4crCOKFR6GqfLNCGBiAMcNQ4mdc7QuQuJ844dAGe
	 nZLsKBwwm1ZPY5fkbdwqOdGZNzDo7BlotsJdlDYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Georgiy Osokin <g.osokin@auroraos.dev>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@oss.qualcomm.com>
Subject: [PATCH 6.18 043/621] tee: shm: reject zero-sized allocations in tee_dyn_shm_alloc_helper()
Date: Tue, 13 Oct 2026 13:30:38 +0200
Message-ID: <20261013112921.885370323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
@@ -343,6 +343,10 @@ int tee_dyn_shm_alloc_helper(struct tee_
 	unsigned int i;
 	int rc = 0;
 
+	/* get_order(0) is undefined and exceeds MAX_PAGE_ORDER. */
+	if (!nr_pages)
+		return -EINVAL;
+
 	/*
 	 * Ignore alignment since this is already going to be page aligned
 	 * and there's no need for any larger alignment.


