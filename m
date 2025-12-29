Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F893331A45;
	Mon, 29 Dec 2025 16:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026061; cv=none; b=VR+cQyvfWrYhqBL43tg1auH8fUzPmy6xK8IN1D2F+wxDu9BGxbpKpVZTHKmApBo/nFh7iEmUWLBqB7VoGih1IG7HLKzdtXjhZle60tmhkiGMlYcQSCtJNvF2FVUTAa+ZPWhsElElBB5lL0gpqhIQR/YhN4mPMrlQAbNOlVSW4j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026061; c=relaxed/simple;
	bh=Yk8pvWRz5fyVRxC8CwFxBM57R0yeNEqpdqUnmdf6rrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTMFSOT05cMJPlYTN+/7vXMi3BULt4mZsx9hmJqAxPhEeBsYS2vUAJM712L6vyL6+sQK41Tu+CwtfrVI50GQsY9+2vSjMVFse/tFP4RY82ePEEsbOVwBxt4eltA1so5T2qfbl+NuLybrbqcFXoKZvH9EO2vYPI8MvJifSxusFMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZMehdn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZMehdn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEFFC4CEF7;
	Mon, 29 Dec 2025 16:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026061;
	bh=Yk8pvWRz5fyVRxC8CwFxBM57R0yeNEqpdqUnmdf6rrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZMehdn/VZQVMxAF0er1E3HRXAR/pAFPxxONh+e/RZbXmK56WjBAVySlfOqndA16o
	 2qynXLS949IPHUPtFOb+8SRCiawhqfOetxWsQ2cJ+vRrJHSmTKKqu2qrfsPSKrFkOD
	 j6WeXWmpqL5RD+SloGjJlNQx8NcO1io1p+VP8S0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 418/430] io_uring/rsrc: fix lost entries after cloned range
Date: Mon, 29 Dec 2025 17:13:40 +0100
Message-ID: <20251229160739.695571438@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

commit 525916ce496615f531091855604eab9ca573b195 upstream.

When cloning with node replacements (IORING_REGISTER_DST_REPLACE),
destination entries after the cloned range are not copied over.

Add logic to copy them over to the new destination table.

Fixes: c1329532d5aa ("io_uring/rsrc: allow cloning with node replacements")
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1200,7 +1200,7 @@ static int io_clone_buffers(struct io_ri
 	if (ret)
 		return ret;
 
-	/* Fill entries in data from dst that won't overlap with src */
+	/* Copy original dst nodes from before the cloned range */
 	for (i = 0; i < min(arg->dst_off, ctx->buf_table.nr); i++) {
 		struct io_rsrc_node *src_node = ctx->buf_table.nodes[i];
 
@@ -1248,6 +1248,16 @@ static int io_clone_buffers(struct io_ri
 		i++;
 	}
 
+	/* Copy original dst nodes from after the cloned range */
+	for (i = nbufs; i < ctx->buf_table.nr; i++) {
+		struct io_rsrc_node *node = ctx->buf_table.nodes[i];
+
+		if (node) {
+			data.nodes[i] = node;
+			node->refs++;
+		}
+	}
+
 	/*
 	 * If asked for replace, put the old table. data->nodes[] holds both
 	 * old and new nodes at this point.


