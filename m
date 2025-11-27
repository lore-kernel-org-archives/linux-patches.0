Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41CD33436D;
	Thu, 27 Nov 2025 15:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255983; cv=none; b=BzQR2IFnh+HBv9XGV7b8Ni163s1yfZmhX3ImPq2/EiBwZ3pBbpK69HEFVLAi5qTF8kMlvJwzOPAwCdleBV50IAIKvkdOiIf2DzFm+DDp+IE3/quYfH+jWrPaoW41KzHdTlqU7TcwdY/OTaBb5VKIu5crDfMm5pd3Jm//3wHMVsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255983; c=relaxed/simple;
	bh=ONjKIrwCOszJAmJkIm+Q9jwbSTZuW5fIrxnZAgdyGbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VilGglPMHH/Lj+SHxToF+LObzQjNexGXnXBggErH6U9liFdvST/rYx4M8tVcnUiXZvu7JRuRbnL5S+JUV1iGiEsd0V7cJa7TDEpLZEAbsLfEJsrUPICJl7+s3iscOfO4nxxbZR0bJpz40MggXxXEtjSF1ZgLYgFoq3GJ+K5Fs9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rg0G7IG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rg0G7IG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFEEC4CEF8;
	Thu, 27 Nov 2025 15:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255983;
	bh=ONjKIrwCOszJAmJkIm+Q9jwbSTZuW5fIrxnZAgdyGbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rg0G7IG5b9Ot6sejiNIj3YECXEHvhzhHuz6bCPDSyAi1rIPtTahu0dsd9peBnbl+1
	 OKfQO4hyBodeuG4qDt6xWIT8PDigxHHnMKncaOe1kwk/FOSERrMyQB8DWIuBi1zrSl
	 OUa4PO5tDzPbb7AwbJP5LPsfGLMIc3q49QXstQ5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.17 175/175] sched_ext: fix flag check for deferred callbacks
Date: Thu, 27 Nov 2025 15:47:08 +0100
Message-ID: <20251127144049.349038297@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Tsalapatis <etsal@meta.com>

commit a3c4a0a42e61aad1056a3d33fd603c1ae66d4288 upstream.

When scheduling the deferred balance callbacks, check SCX_RQ_BAL_CB_PENDING
instead of SCX_RQ_BAL_PENDING. This way schedule_deferred() properly tests
whether there is already a pending request for queue_balance_callback() to
be invoked at the end of .balance().

Fixes: a8ad873113d3 ("sched_ext: defer queue_balance_callback() until after ops.dispatch")
Signed-off-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -821,7 +821,7 @@ static void schedule_deferred(struct rq
 		return;
 
 	/* Don't do anything if there already is a deferred operation. */
-	if (rq->scx.flags & SCX_RQ_BAL_PENDING)
+	if (rq->scx.flags & SCX_RQ_BAL_CB_PENDING)
 		return;
 
 	/*


