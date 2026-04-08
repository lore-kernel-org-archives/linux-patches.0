Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F2C2BD030;
	Wed,  8 Apr 2026 18:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674056; cv=none; b=mXOgQU6HZI84TxLsBzAx4wLG7Hpp8NaZzIqv7LlDR7guQ85x4YXio7gpVbJ/w60EgVqMMYZKk9NImFMrfzcCW/85zQ16d3r+gUBb0PmLPJ+DsiSOxDSQ/t5eeKvYhXCmMG4ft1KyOwpBz2X/71SIXyn6C/MgTaCdyHYLpYYn9lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674056; c=relaxed/simple;
	bh=Qb5qlRwDv0yEui/fk01kppDFmp2xrk3J5130zlmS7hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmkMTZTyvOcuIzwgjnuSFxr2SN0Y3lanD50/XL/Kv9+qq4ObiwY59I+bwFHxoJYEnZT1MeC7udjNH6SHzGKI8Fmmv4PjxApA+jXBOjTK/PE3gOq5kJauWj/bOmBa0SjFS1pbp0nXUaYXPPt3T25JdFA5G3Tly5Ixxm0ARZ6dKO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uaAjmlki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uaAjmlki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6ACEC19421;
	Wed,  8 Apr 2026 18:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674056;
	bh=Qb5qlRwDv0yEui/fk01kppDFmp2xrk3J5130zlmS7hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uaAjmlkih5dohfFgw3z4z7fHll0tw3UakTsrsg4dTHqd5PIl5CGMotHLb+GX8Ln2x
	 UIfFTz9LUuBK4KDkdVSgShWYnbOtiaK4hC1zgd9slZieotpYk8K9fXsD7koF1qJ4dj
	 cP9jrn84+qCphfV1gaGDka+6CsHJsYhHKbaZxo6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingjing Deng <xjdeng@buaa.edu.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.12 192/242] misc: fastrpc: possible double-free of cctx->remote_heap
Date: Wed,  8 Apr 2026 20:03:52 +0200
Message-ID: <20260408175934.270467005@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Xingjing Deng <micro6947@gmail.com>

commit ba2c83167b215da30fa2aae56b140198cf8d8408 upstream.

fastrpc_init_create_static_process() may free cctx->remote_heap on the
err_map path but does not clear the pointer. Later, fastrpc_rpmsg_remove()
frees cctx->remote_heap again if it is non-NULL, which can lead to a
double-free if the INIT_CREATE_STATIC ioctl hits the error path and the rpmsg
device is subsequently removed/unbound.
Clear cctx->remote_heap after freeing it in the error path to prevent the
later cleanup from freeing it again.

This issue was found by an in-house analysis workflow that extracts AST-based
information and runs static checks, with LLM assistance for triage, and was
confirmed by manual code review.
No hardware testing was performed.

Fixes: 0871561055e66 ("misc: fastrpc: Add support for audiopd")
Cc: stable@vger.kernel.org # 6.2+
Signed-off-by: Xingjing Deng <xjdeng@buaa.edu.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20260129234140.410983-1-xjdeng@buaa.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1373,6 +1373,7 @@ err_invoke:
 	}
 err_map:
 	fastrpc_buf_free(fl->cctx->remote_heap);
+	fl->cctx->remote_heap = NULL;
 err_name:
 	kfree(name);
 err:


