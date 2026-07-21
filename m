Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C9143031D;
	Tue, 21 Jul 2026 19:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661724; cv=none; b=OHhVoOSzP7ONaLIvEyXdA6TUDqgUCa8+SXlyFr9bdVITXE4nGGqJYlqavOp+T9EOPlTHXsR9WOle5/25a0k98tYtN92VubKRf6FTEixbtojebb3/noDnP9oxrS3h1mJRAlnH/d4paVGodSAvScDpxWYz3RTwsdaT0pEXv8qozl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661724; c=relaxed/simple;
	bh=pnAH3Y1sPOlivmBKC/WgSGqhnK54PoEu/PfrAjuoBA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGL43MxrHJbbaGc4puHii02QcvfLQc2z0n4i6oDDi3Pv18+poB8qqoXYJoUzp9XVmpP/apHUij1AR0hvvvEN1rFakv9A4ts9N2pI/iHTidZNDQNxZGJBI/whvmaj/2XgiFAoXeJMMZ73pwvS9zaDgQNPNdwlPhAptXrwC1DA/FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeiSg1pX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeiSg1pX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20FC1F000E9;
	Tue, 21 Jul 2026 19:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661723;
	bh=Zsdl7qXVc//6tSnJXkV1AHQNwvI1DSKq0hFTRXx64oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeiSg1pXkJATzhogJL4+to87uyeujpiBt/xHgZkRfojIxr9XHuQTtAvEElf+55OPa
	 Wpa6wdIkTZaMm5KAhXRK+hz6aCAFyX4AJ33QRkrs+jItU9gDxQ8/Yb+1sLE27Q8ZkI
	 QwAeoizHeNm2u4moPlv4BVr74g+dbgORElbEYQ1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0173/1276] workqueue: drop spurious * from print_worker_info() fn declaration
Date: Tue, 21 Jul 2026 17:10:16 +0200
Message-ID: <20260721152449.969415158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 611583a76ea97991b0f65ec1ff099eac7fe0bae4 ]

print_worker_info() declares its local 'fn' as work_func_t * but
worker->current_func has type work_func_t (a function pointer). The
extra level of indirection is wrong and only happens to be harmless
today because every supported Linux architecture has
sizeof(work_func_t) == sizeof(work_func_t *):
copy_from_kernel_nofault() reads the correct number of bytes by
accident, and %ps still resolves the printed address because the
stored value is the function address regardless of declared type.

On any future ABI where sizeof(void (*)()) differs from
sizeof(void *), the nofault copy would transfer the wrong number of
bytes and the subsequent %ps would print an incorrect address.

Match the field type so the intent is explicit and the code does not
silently rely on equal pointer sizes.

Fixes: 3d1cb2059d93 ("workqueue: include workqueue info when printing debug dump of a worker task")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2fdf9174ccec7c..a91215dc0db41f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -6172,7 +6172,7 @@ EXPORT_SYMBOL_GPL(set_worker_desc);
  */
 void print_worker_info(const char *log_lvl, struct task_struct *task)
 {
-	work_func_t *fn = NULL;
+	work_func_t fn = NULL;
 	char name[WQ_NAME_LEN] = { };
 	char desc[WORKER_DESC_LEN] = { };
 	struct pool_workqueue *pwq = NULL;
-- 
2.53.0



