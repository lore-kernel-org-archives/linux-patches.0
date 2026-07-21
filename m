Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AEA42DA53;
	Tue, 21 Jul 2026 19:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662709; cv=none; b=UoH5cnr8/2byopDwGuyj4NkHZ8KdLf2OkZvrLJGod7QSWhAyidlB/emSCGYSZNbtMv+lhDJxLAypY0KveVZcyZMoWivpCZ1fDiWjUxLjAZHSvLDHqUvPcWOD91+vFW+aGzYPwKl+aJb2aYPQkgcLmqYGvDexPpelwxlpBZTJkvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662709; c=relaxed/simple;
	bh=01mFnvo6QdWH+w+I/EODR/NENZwerQNvHCa+h7ZoM1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kq2NHXPm75hGdOSxtQIY0vF5wbnT1ccQQMT4X6AcOrIS+wpQ9rA1p+iHL9TxToNDJulsn7NJqwVs98DvOLXItTkBMGF4ZA7uqk/WirkWv0vUPEkvrl+8tdXMC9oF1uHipviO/r4WwAV/t8mEAQhCOELRWcZ2hvPnhvi5qFJYilk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCM0BxMW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCM0BxMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE781F000E9;
	Tue, 21 Jul 2026 19:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662708;
	bh=1+oCtCGlZ+4b2lzjGi7UGHU6nze4Cb+A1jUW1ZhapWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCM0BxMW1RhsyZkgMb77nhNaFgHT9kDZ/TynhpDPvIi65UIYq6i3PgQmTDhnPdTxC
	 zUUuT6crXE3vJe774xwEoxSQ07Ph+MLkdfrMNRw4jBvAmUC1aUoNboiHdWYBHHT1O7
	 9zUxGPrNmgibi2E1fhTOSxHsSxWjOmSBDEQxRJKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0545/1276] workqueue: Add new WQ_PERCPU flag
Date: Tue, 21 Jul 2026 17:16:28 +0200
Message-ID: <20260721152458.315954875@linuxfoundation.org>
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

From: Marco Crivellari <marco.crivellari@suse.com>

[ Upstream commit 930c2ea566aff59e962c50b2421d5fcc3b98b8be ]

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.
This lack of consistentcy cannot be addressed without refactoring the API.

This patch adds a new WQ_PERCPU flag to explicitly request the use of
the per-CPU behavior. Both flags coexist for one release cycle to allow
callers to transition their calls.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

tj: Merged doc patch.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 527756cb9ebb ("i3c: master: Make hot-join workqueue freezable to block hot-join during suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/core-api/workqueue.rst | 6 ++++++
 include/linux/workqueue.h            | 1 +
 2 files changed, 7 insertions(+)

diff --git a/Documentation/core-api/workqueue.rst b/Documentation/core-api/workqueue.rst
index 16f861c9791e4a..6597577f8c48b8 100644
--- a/Documentation/core-api/workqueue.rst
+++ b/Documentation/core-api/workqueue.rst
@@ -183,6 +183,12 @@ resources, scheduled and executed.
   BH work items cannot sleep. All other features such as delayed queueing,
   flushing and canceling are supported.
 
+``WQ_PERCPU``
+  Work items queued to a per-cpu wq are bound to a specific CPU.
+  This flag is the right choice when cpu locality is important.
+
+  This flag is the complement of ``WQ_UNBOUND``.
+
 ``WQ_UNBOUND``
   Work items queued to an unbound wq are served by the special
   worker-pools which host workers which are not bound to any
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 23642bb1a103cf..c75327e31e6a0e 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -401,6 +401,7 @@ enum wq_flags {
 	 * http://thread.gmane.org/gmane.linux.kernel/1480396
 	 */
 	WQ_POWER_EFFICIENT	= 1 << 7,
+	WQ_PERCPU		= 1 << 8, /* bound to a specific cpu */
 
 	__WQ_DESTROYING		= 1 << 15, /* internal: workqueue is destroying */
 	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
-- 
2.53.0



