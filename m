Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC7C3F3265;
	Mon, 17 Aug 2026 13:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974400; cv=none; b=auDuLi74JtCqyixwZd74PdE1R2Z1RIdsJ8c4ccfBuVXxHpLnhhWecV8WTeFXo1AjR6XWrjV/Q29wecrnI3789qAelhENlGzEkYnW8aYAXp3u3G1BCFYNN/HGcYVF6ASMrTDAwzRJnGYgsKg93/EeZrRqYnEPAeGdIMTJaquRoCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974400; c=relaxed/simple;
	bh=OxAn8dozBy7iFOJOfAI9B0nNCOlRtUQK/PAceS8Vvps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbEEgKw7h3HkPYtLkCDW3HURRnRgsMRheR9jIZNBoy4mmibiGglu2Dh6zl4Auf+VhXH7NuHMFlhC0Q54d4XZF+egErxfzH79HujbJbT31vWiAFqV3VBZ23XJWy4lcs3WyCFEjCL0s8Ikah0+tcs9ZMHp6U4cVrXqaYd4SlOeerU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYoZ6DfR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYoZ6DfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0D41F00A3D;
	Mon, 17 Aug 2026 13:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974396;
	bh=kZkmA3sj1en+AwlM9xzJf/gDIssqL/LRLHDk6YuOUGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cYoZ6DfR3wy3U0NtM3OytEvmjY+w/wA43sHHQ6daSTfUsCJNDFVDpc2NoJ6Rk+DUP
	 JZLNJj/0lZ8ONDETcdSXOTpC8zWWVDLDIU91vnIUb6X2haUj7Fe4xUqsPIzkPMdDZd
	 52r88jJqAKDpFXc8fLf/ejIn2wwl/HqB3ZrMutyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 7.1 191/271] misc: fastrpc: take fl->lock when moving mmaps on interrupted invoke
Date: Mon, 17 Aug 2026 15:31:56 +0200
Message-ID: <20260817132544.672725410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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
@@ -1305,10 +1305,12 @@ bail:
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


