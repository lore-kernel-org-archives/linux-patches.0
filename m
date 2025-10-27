Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AF52DAFC3;
	Mon, 27 Oct 2025 19:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592988; cv=none; b=bP4fIc0yU8erxlB2azffsRxyMvaXVx+IyfOI3gXXDAbGz3IHEBATOCOsKetyV43WFkHy62jjoCOWyEwPO7dTELAmXLdrKvE2u4T5so7uWdKdeF8Oi832lbMaRVVjh6Zz1sfmJT8sH3O35qbjBg0zdON3GBl7kJTMIcwS91Xv7Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592988; c=relaxed/simple;
	bh=GsQAFy5jUChE7S+hCC/G6qvh2y8yA4Kq477MPUe4gFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCKKo8+zYwM63qPi4LWaOBXGh1UmT5eTRTDf2OQWZqT6aqVl39p8sBJ3ZemJNSEJ45iQd3qKHKZkHTPH9VjnjynWiMj99AQqO+xVkWjlQ8vqJM7WtDqF3r4Go4jXQIP55kCPgFdrLvFlDegFKoMQE7G499OZ/cvH1eB6eFQa4Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApB/dJAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApB/dJAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E1FC4CEF1;
	Mon, 27 Oct 2025 19:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592988;
	bh=GsQAFy5jUChE7S+hCC/G6qvh2y8yA4Kq477MPUe4gFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ApB/dJArjfkoLmdJ54esWvm5KdQddlvfj6VUiAoPeNbVlYS+jCl1i1D+Hf7f348dP
	 h7nkirVoPTlAmmdKzXJTWtM7FQtsv3fV9rlMIYtvDqcKLwq6yWNwopT2MrZ1BDxCq4
	 aa8Uxcd2z0LD5cpqIM7fUZYR3htb2IVRTuPlOwV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/117] io_uring: correct __must_hold annotation in io_install_fixed_file
Date: Mon, 27 Oct 2025 19:36:54 +0100
Message-ID: <20251027183456.404258994@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit c5efc6a0b3940381d67887302ddb87a5cf623685 ]

The __must_hold annotation references &req->ctx->uring_lock, but req
is not in scope in io_install_fixed_file. This change updates the
annotation to reference the correct ctx->uring_lock.
improving code clarity.

Fixes: f110ed8498af ("io_uring: split out fixed file installation and removal")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/filetable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 997c56d32ee6c..6183d61c7222d 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -62,7 +62,7 @@ void io_free_file_tables(struct io_file_table *table)
 
 static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 				 u32 slot_index)
-	__must_hold(&req->ctx->uring_lock)
+	__must_hold(&ctx->uring_lock)
 {
 	struct io_fixed_file *file_slot;
 	int ret;
-- 
2.51.0



