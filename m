Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA7F3E024D;
	Wed, 30 Sep 2026 19:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796311; cv=none; b=KejKefYljQj3d41UQrstOfdyeQXBs+z2wk5nNk3quFb/uWrFYVxJ3UuW2pA07un1jWczY6H1CfCP8Cl8qqqIUuNLdLveKicmrQRC+O5hKAmwNHz9E8yCAa5BWCfyVDi07DbWI9HDhlJ2IekmJfeFLEkyKOmptcp/E1M07SwDSR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796311; c=relaxed/simple;
	bh=c0gVDDumJtzH0puQPmVVyjVW1RMycDnuzCi0zF+FaBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xo2/A2Ob3v/2B5VNVk9kWTQcoQdTdEIaFqa7xt98c6oecPSJeojNwXAixmyGPw73JViNEtOyZoKHa+irP1e1IizphbA4fqH4ywHQKUTbkeZHXOtzhFEuuXHBgdQWyO+b26BUNKRe+sRQN+nN2nExmOl4E9ShwMbs5ZYFHJtwsjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fd0WwAXD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fd0WwAXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB8E1F000FF;
	Wed, 30 Sep 2026 19:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796309;
	bh=bhvIN2nOBm2P6+mZsrYVW9lj+aCD7GaPBtgl4Nv3Rzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fd0WwAXD2FLOE3tO+JNRxuka00Kkzkx/fLQeTM3mo3dyHN4JIcro1SD/KzSgFHRNF
	 m84HxZ6fG+Lk9AsRK+LnMuWWagwAcilN/74Jg48JeKPEzz0UXyXwWCmSysEanRe+N1
	 nm80s5m3z2zs2nDLeRX1IhHQXY0HqoUsEnEBx48A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0869/1193] memstick: ms_block: destroy io_queue workqueue on removal
Date: Wed, 30 Sep 2026 17:25:53 +0200
Message-ID: <20260930152453.544497466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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


