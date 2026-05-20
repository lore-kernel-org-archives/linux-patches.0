Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1870F3D75DA;
	Wed, 20 May 2026 17:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297071; cv=none; b=q0/yjdJ2IMoopIo9Sk/B3HiPSMH9awdFzxkQkB6Nly9X+mv9sngbhPz5v6BH2/7zZHoRsr6kY49R0peT7JUkrZg+z1oDg6ECLF+20sqLL8SoEFrnRNhVZz/JnS8ksZD0IQ/3PWBJuJYecZPjZIu8xUTesI7yBvdMLGtrwS/h4YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297071; c=relaxed/simple;
	bh=NZR1UrUuayu89T00dFkRIblz1ORXbNUanTXUawG67CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2aRimFrYOOqORsE8BvB5qqbCSe/8x30IgH6QDeVpg4gKnKqFgawNcU6XM4ptd/dT7bJLFImOXhVVD25WtIeXsJl4CFq/UJWXpvrqy33/RnKlaNwlwG9cGNiXpSn5gkWZ8E6YpuLoqUbG2tz4w5vh9mm5Qz6RNh7QJuDuT3oWJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRKnXyo1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRKnXyo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4441F000E9;
	Wed, 20 May 2026 17:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297070;
	bh=+vcMpsFcdOM7pndeDck1NvqfqZ/6+asdMP5v78I38ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sRKnXyo13NrgPtj83jc4nAPUehQTiWhqMlIzDYwS5oROtzg21G6uhSS35l2+4ilBM
	 zwiTHHXnucy13FOGnoGfzajfrH13/DcU0d6PnmhxSv6z52pax9CoslJYYQ6iiXZqh8
	 CL1KMLSIQr73IN0fIEA0bXm2HKAbu9TCvZT0RI0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1038/1146] workqueue: fix devm_alloc_workqueue() va_list misuse
Date: Wed, 20 May 2026 18:21:28 +0200
Message-ID: <20260520162211.723011897@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 0de4cb473aed57ee4ba7e0551ad27bddc19fc519 ]

devm_alloc_workqueue() built a va_list and passed it as a single
positional argument to the variadic alloc_workqueue() macro:

	va_start(args, max_active);
	wq = alloc_workqueue(fmt, flags, max_active, args);
	va_end(args);

C does not allow forwarding a va_list through a ... parameter.
alloc_workqueue() expands to alloc_workqueue_noprof(), which runs
its own va_start() over its ... params, so the inner
vsnprintf(wq->name, sizeof(wq->name), fmt, args) in
__alloc_workqueue() received the outer va_list object as the first
variadic slot rather than the caller's actual format arguments.

Add a new static helper alloc_workqueue_va() that wraps
__alloc_workqueue() and runs wq_init_lockdep() on success, and
fold both alloc_workqueue_noprof() and devm_alloc_workqueue_noprof()
onto it as suggested by Tejun.

The wq_init_lockdep() step is required on the devm path
too, otherwise __flush_workqueue()'s on-stack
COMPLETION_INITIALIZER_ONSTACK_MAP would NULL-deref wq->lockdep_map.

No caller changes are required. devm_alloc_ordered_workqueue() is
a macro forwarding to devm_alloc_workqueue() and inherits the fix.
Two in-tree callers actively trigger the broken path on every probe:

  drivers/power/supply/mt6370-charger.c:889
  drivers/power/supply/max77705_charger.c:649

both of which use devm_alloc_ordered_workqueue(dev, "%s", 0,
dev_name(dev)).

A standalone reproducer module is available at[1].

Link: https://github.com/leitao/debug/blob/main/workqueue/valist/wq_va_test.c [1]
Fixes: 1dfc9d60a69e ("workqueue: devres: Add device-managed allocate workqueue")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/workqueue.h |  6 ++++--
 kernel/workqueue.c        | 28 +++++++++++++++++++---------
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index f8d235aef10dd..218557a8f7577 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -529,8 +529,10 @@ alloc_workqueue_noprof(const char *fmt, unsigned int flags, int max_active, ...)
  * Pointer to the allocated workqueue on success, %NULL on failure.
  */
 __printf(2, 5) struct workqueue_struct *
-devm_alloc_workqueue(struct device *dev, const char *fmt, unsigned int flags,
-		     int max_active, ...);
+devm_alloc_workqueue_noprof(struct device *dev, const char *fmt,
+			    unsigned int flags, int max_active, ...);
+#define devm_alloc_workqueue(...)	\
+	alloc_hooks(devm_alloc_workqueue_noprof(__VA_ARGS__))
 
 #ifdef CONFIG_LOCKDEP
 /**
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e57040931d8b7..5d704df76a946 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5885,6 +5885,20 @@ static struct workqueue_struct *__alloc_workqueue(const char *fmt,
 	return NULL;
 }
 
+static struct workqueue_struct *alloc_workqueue_va(const char *fmt,
+						   unsigned int flags,
+						   int max_active,
+						   va_list args)
+{
+	struct workqueue_struct *wq;
+
+	wq = __alloc_workqueue(fmt, flags, max_active, args);
+	if (wq)
+		wq_init_lockdep(wq);
+
+	return wq;
+}
+
 __printf(1, 4)
 struct workqueue_struct *alloc_workqueue_noprof(const char *fmt,
 						unsigned int flags,
@@ -5894,12 +5908,8 @@ struct workqueue_struct *alloc_workqueue_noprof(const char *fmt,
 	va_list args;
 
 	va_start(args, max_active);
-	wq = __alloc_workqueue(fmt, flags, max_active, args);
+	wq = alloc_workqueue_va(fmt, flags, max_active, args);
 	va_end(args);
-	if (!wq)
-		return NULL;
-
-	wq_init_lockdep(wq);
 
 	return wq;
 }
@@ -5911,15 +5921,15 @@ static void devm_workqueue_release(void *res)
 }
 
 __printf(2, 5) struct workqueue_struct *
-devm_alloc_workqueue(struct device *dev, const char *fmt, unsigned int flags,
-		     int max_active, ...)
+devm_alloc_workqueue_noprof(struct device *dev, const char *fmt,
+			    unsigned int flags, int max_active, ...)
 {
 	struct workqueue_struct *wq;
 	va_list args;
 	int ret;
 
 	va_start(args, max_active);
-	wq = alloc_workqueue(fmt, flags, max_active, args);
+	wq = alloc_workqueue_va(fmt, flags, max_active, args);
 	va_end(args);
 	if (!wq)
 		return NULL;
@@ -5930,7 +5940,7 @@ devm_alloc_workqueue(struct device *dev, const char *fmt, unsigned int flags,
 
 	return wq;
 }
-EXPORT_SYMBOL_GPL(devm_alloc_workqueue);
+EXPORT_SYMBOL_GPL(devm_alloc_workqueue_noprof);
 
 #ifdef CONFIG_LOCKDEP
 __printf(1, 5)
-- 
2.53.0



