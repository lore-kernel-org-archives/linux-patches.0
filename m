Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D00D43CED7;
	Mon, 17 Aug 2026 14:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978657; cv=none; b=OULIGW+0fKf5/skfvgaKT3/rJNB4U7LoK877/haO5nKm/VA6TnJEGUCyiz/WUdG2sPqVasyKL3Z3TzmeasO85/G7KSfapX8Z+b8NdgAdI+Fe4tfcaOfBZO/z1EVEtNBlwzKjhpWS2nO21tMIL4JX/2JxZoJLpPcwwMWBRFAfvNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978657; c=relaxed/simple;
	bh=c8LYyJSzuX9nTlOYQg/HRKaZzef+yqd+M6u1icxs+Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+AATulC+MNDpX/V5ShfHglr70lKiEN7bP8YOCG2VimEOd/bR4q4oN/WYogxG9jpHdUxM0HVaFJnAFCQpQMlvWtdkH1uDLEnyF+mCoC+4Oh3bdd4PqIUD8oibnUizwFZeQFKGvhOvsiwhpaMURgCCX3knDl5wu4b/mtxu80kVjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0acJ8mz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0acJ8mz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D141F000E9;
	Mon, 17 Aug 2026 14:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978656;
	bh=gtxz6K0FZUcFRzt+QwYhygo7LKhq9BNRx1Rl/sX6m2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u0acJ8mzSvGSPomvBk/5zVTN/Ax5+FkPYmdUO43LdqOV4UO8OgIqZwXkVGqnOtehr
	 LT4HUmeReIuCsUPUCk23slnD12DVVpNC1tdjQ9r5BlvuWK2LSp2n2VO+YKpkw6xmNu
	 XR/vh5jwiMnTM1V79f2B96Abk5VMNo5KVGgfBN8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.6 111/156] misc: fastrpc: take fl->lock when moving mmaps on interrupted invoke
Date: Mon, 17 Aug 2026 15:34:05 +0200
Message-ID: <20260817132538.966956658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

commit b85a0e91d7d6cd06a53c881a46f749cfcef416a2 upstream.

When an invoke is interrupted by a signal,
wait_for_completion_interruptible() returns -ERESTARTSYS and
fastrpc_internal_invoke() moves every buffer from fl->mmaps onto
cctx->invoke_interrupted_mmaps. This list_del()/list_add_tail() walk
runs without holding fl->lock, the lock that serialises fl->mmaps in
fastrpc_req_mmap() and fastrpc_req_munmap() everywhere else.

Take fl->lock around the move, matching every other fl->mmaps accessor.

Fixes: 76e8e4ace1ed ("misc: fastrpc: Safekeep mmaps on interrupted invoke")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260724223342.629168-4-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1275,10 +1275,12 @@ bail:
 	}
 
 	if (err == -ERESTARTSYS) {
+		spin_lock(&fl->lock);
 		list_for_each_entry_safe(buf, b, &fl->mmaps, node) {
 			list_del(&buf->node);
 			list_add_tail(&buf->node, &fl->cctx->invoke_interrupted_mmaps);
 		}
+		spin_unlock(&fl->lock);
 	}
 
 	if (err)


