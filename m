Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54774C225E;
	Wed, 30 Sep 2026 17:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788666; cv=none; b=Gl3akCooSQ0O6seDLsTrRar/GASla0GWk79BYwG8qxwexYrIDt4qR3pHyz7qs0Q8yL3/nS85cN7Zzy1aHJ3yGk0fv+YS8lEFhXrqeycmRHGSawwFy3n/iI7gtCHfWHu7V337a3YErByoHuQ5PV3ijRmA6lFiTDjKJg44IMr/MiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788666; c=relaxed/simple;
	bh=nxiyB7p3Rc3Q20EF+KhwbUQJJ+xdUP86C+wCw6y4LPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifwx4B3TsU1b00yMQb/vbQorLsmAofCQKchX0lI4g4R9xd1vc7lvygqe2vYVZuKCafbsz3ycAMn8FTfh60TovwtpjKF7L52GoiBAoCr0sfUYutJWs2sMxYAQOh2eX0A0P87wKzbqDNtXN0q+3JOcFIqsOM57sCkKFN6vt3xsdlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfzvQi9N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfzvQi9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C65A1F00898;
	Wed, 30 Sep 2026 17:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788665;
	bh=9YyFk8mGI1OXjcgklxbmdOi7KvqKqOCZwlkcMbP4oRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BfzvQi9NG022jpnPeuA0n6snnfxz7FGSEXkCv+7wtLzHUPDj/karTAUY0WxdoJoqt
	 tGOkxU5Wl8jaR8l8w1WDCbXjQQYxnmlYkxaCBkyVL32i3LPad8vW69GyBFk+ylsJPF
	 5m3lo0il4UPZ4UlNzinX/RARj+eZPLhkC87cOIa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 203/877] memstick: ms_block: destroy io_queue workqueue on removal
Date: Wed, 30 Sep 2026 17:18:34 +0200
Message-ID: <20260930152419.104399671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Yifei Gao <gyf161023@gmail.com>

commit 90af7fde083e1b22c349c3a8b1626728e44e474c upstream.

msb_init_disk() creates the per-card ordered workqueue msb->io_queue with
alloc_ordered_workqueue(). It is torn down with destroy_workqueue() only
on the init error path; msb_remove() never destroys it. msb_stop() merely
flushes the queue, and neither msb_data_clear() nor put_disk() free it. As
a result every card insert/remove cycle leaks the workqueue and its
kworker, exhausting kernel memory over repeated cycles.

Destroy the workqueue in msb_remove() after the disk has been removed and
the queue drained.

Fixes: 0ab30494bc4f ("memstick: add support for legacy memorysticks")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memstick/core/ms_block.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -2206,6 +2206,8 @@ static void msb_remove(struct memstick_d
 	msb_data_clear(msb);
 	mutex_unlock(&msb_disk_lock);
 
+	destroy_workqueue(msb->io_queue);
+
 	put_disk(msb->disk);
 	memstick_set_drvdata(card, NULL);
 }


