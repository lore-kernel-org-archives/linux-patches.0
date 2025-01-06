Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7CF16D9B8;
	Mon,  6 Jan 2025 15:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178001; cv=none; b=cCU/DIq0oRu154dWN5IJ5zhs0yJQsACuYwxYNBCFLSWQwrKOUVL4P48AcmDLYcZWVcvOxRgWSu1DqwxJX9bosKcYaMUhXaod3A+pRZjEUF8vYLa0yq+8IoebPT6oxjouv0UbPbY4dXIvN1lDMIUmqTpwlvlw29mVCbWGNHk5gqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178001; c=relaxed/simple;
	bh=hY5Qy27gjANYa0Y+6wytJ7TG3ee4bSWmqC+Q/qjxkyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWobUM1xeJuEQyRWFpJUBDH82f0dJj0wvJc+srK+ECRkTuMKzdaGVGI1Op7Z8Qo26luUWhOnsyBSYQ/cSFVkjqCAJZKOe0seB/Geo2W4JaobB188+AtSYeDou8E5hkPlsBaRdMKXgVT2fTeBIVNEy5+qtrrJszJ0BqJ6UH3tM9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WacP/dvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WacP/dvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55DFC4CED2;
	Mon,  6 Jan 2025 15:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178001;
	bh=hY5Qy27gjANYa0Y+6wytJ7TG3ee4bSWmqC+Q/qjxkyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WacP/dvE2lSr4GnbTwc67wCmgc4IP+cDa3zqHXBmY0sES8vEVrE4qr1F4a0OElt0a
	 dcRbSs04LIYNnU+H5q7LGolY+2bLl6T9g/9XcPePXy/J1u5WDYR5qQGh3HjXXPjfCR
	 PUKUZ7ChsEXouOIJ8g1GCnobZ+OwoMrDfhsH48XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Huang <henry.hj@antgroup.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 129/156] sched_ext: initialize kit->cursor.flags
Date: Mon,  6 Jan 2025 16:16:55 +0100
Message-ID: <20250106151146.591015886@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Henry Huang <henry.hj@antgroup.com>

commit 35bf430e08a18fdab6eb94492a06d9ad14c6179b upstream.

struct bpf_iter_scx_dsq *it maybe not initialized.
If we didn't call scx_bpf_dsq_move_set_vtime and scx_bpf_dsq_move_set_slice
before scx_bpf_dsq_move, it would cause unexpected behaviors:
1. Assign a huge slice into p->scx.slice
2. Assign a invalid vtime into p->scx.dsq_vtime

Signed-off-by: Henry Huang <henry.hj@antgroup.com>
Fixes: 6462dd53a260 ("sched_ext: Compact struct bpf_iter_scx_dsq_kern")
Cc: stable@vger.kernel.org # v6.12
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -6637,7 +6637,7 @@ __bpf_kfunc int bpf_iter_scx_dsq_new(str
 		return -ENOENT;
 
 	INIT_LIST_HEAD(&kit->cursor.node);
-	kit->cursor.flags |= SCX_DSQ_LNODE_ITER_CURSOR | flags;
+	kit->cursor.flags = SCX_DSQ_LNODE_ITER_CURSOR | flags;
 	kit->cursor.priv = READ_ONCE(kit->dsq->seq);
 
 	return 0;


