Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F7A3F9D2;
	Tue, 12 Aug 2025 18:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021806; cv=none; b=Vfmi8OKr8K80ubI1O9EArOj5bwD8eMhDma8WxMRK8TgqWaHxNp9dZ46rp78Oy1INHoeooNHG7drmNXyq8dsq+XNbEJ2sQbkIuAydKWEmxXQgwUAhh4eulCzO5zlxH1IEOEu7Nir4yW0NjWygBBqQ0eMLvH2OzgU/gJ4mxeJSylI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021806; c=relaxed/simple;
	bh=pkfVsCwkiEn7BS+q1YNCI8XDaX4qBppjVIhIvTLnoKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8A39KlbmOcSb5JinExOfoKCf8BCJNQb2CeRFkxDkPlTLgK7+kt1aslk5YTCwJe5b0CzVV799RXyrK1LSzOEpdqqm8nwWlkQaaQvBNutBQpoaldJPKHMg2wLbUBe5LbHKrQqHHm62SEv8Vk5Zrg8uLXTzmawBPj7LRBo+FXAjvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJ9y+Qm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJ9y+Qm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B119BC4CEF6;
	Tue, 12 Aug 2025 18:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021806;
	bh=pkfVsCwkiEn7BS+q1YNCI8XDaX4qBppjVIhIvTLnoKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJ9y+Qm4GgGVSl7sb1qBLV1rrrdbC7Icbfoa0ylc5vAVLspkeGj0GsJQyjqkJkf+a
	 rglsD0Z5+oRdYTAuqheLIEj3A4U+ia2xN5UoKLJkApuVPTNRE/EVFSFZhFzqc8bDnw
	 ALN1gXxP29tNbiFtsCsjTeW+CCyiUlM7YFrDSM7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/262] sched: Add test_and_clear_wake_up_bit() and atomic_dec_and_wake_up()
Date: Tue, 12 Aug 2025 19:29:45 +0200
Message-ID: <20250812173001.547247650@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 52d633def56c10fe3e82a2c5d88c3ecb3f4e4852 ]

There are common patterns in the kernel of using test_and_clear_bit()
before wake_up_bit(), and atomic_dec_and_test() before wake_up_var().

These combinations don't need extra barriers but sometimes include them
unnecessarily.

To help avoid the unnecessary barriers and to help discourage the
general use of wake_up_bit/var (which is a fragile interface) introduce
two combined functions which implement these patterns.

Also add store_release_wake_up() which supports the task of simply
setting a non-atomic variable and sending a wakeup.  This pattern
requires barriers which are often omitted.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240925053405.3960701-5-neilb@suse.de
Stable-dep-of: 1db3a48e83bb ("NFS: Fix wakeup of __nfs_lookup_revalidate() in unblock_revalidate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/wait_bit.h | 60 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/include/linux/wait_bit.h b/include/linux/wait_bit.h
index 7725b7579b78..2209c227e859 100644
--- a/include/linux/wait_bit.h
+++ b/include/linux/wait_bit.h
@@ -335,4 +335,64 @@ static inline void clear_and_wake_up_bit(int bit, void *word)
 	wake_up_bit(word, bit);
 }
 
+/**
+ * test_and_clear_wake_up_bit - clear a bit if it was set: wake up anyone waiting on that bit
+ * @bit: the bit of the word being waited on
+ * @word: the address of memory containing that bit
+ *
+ * If the bit is set and can be atomically cleared, any tasks waiting in
+ * wait_on_bit() or similar will be woken.  This call has the same
+ * complete ordering semantics as test_and_clear_bit().  Any changes to
+ * memory made before this call are guaranteed to be visible after the
+ * corresponding wait_on_bit() completes.
+ *
+ * Returns %true if the bit was successfully set and the wake up was sent.
+ */
+static inline bool test_and_clear_wake_up_bit(int bit, unsigned long *word)
+{
+	if (!test_and_clear_bit(bit, word))
+		return false;
+	/* no extra barrier required */
+	wake_up_bit(word, bit);
+	return true;
+}
+
+/**
+ * atomic_dec_and_wake_up - decrement an atomic_t and if zero, wake up waiters
+ * @var: the variable to dec and test
+ *
+ * Decrements the atomic variable and if it reaches zero, send a wake_up to any
+ * processes waiting on the variable.
+ *
+ * This function has the same complete ordering semantics as atomic_dec_and_test.
+ *
+ * Returns %true is the variable reaches zero and the wake up was sent.
+ */
+
+static inline bool atomic_dec_and_wake_up(atomic_t *var)
+{
+	if (!atomic_dec_and_test(var))
+		return false;
+	/* No extra barrier required */
+	wake_up_var(var);
+	return true;
+}
+
+/**
+ * store_release_wake_up - update a variable and send a wake_up
+ * @var: the address of the variable to be updated and woken
+ * @val: the value to store in the variable.
+ *
+ * Store the given value in the variable send a wake up to any tasks
+ * waiting on the variable.  All necessary barriers are included to ensure
+ * the task calling wait_var_event() sees the new value and all values
+ * written to memory before this call.
+ */
+#define store_release_wake_up(var, val)					\
+do {									\
+	smp_store_release(var, val);					\
+	smp_mb();							\
+	wake_up_var(var);						\
+} while (0)
+
 #endif /* _LINUX_WAIT_BIT_H */
-- 
2.39.5



