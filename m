Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207821;
	b=OOcPbbt15ddpFldgbHi/kcwBsTKoMh0O+8Jk49ItqzwoyyVJzVLAQ2KFPdfhK50HtzO5
	 LmkXc67U59N4qlL5dZxccfuoWCJI2JW/o8/PwDRzdU/vTfnjbwu1sA7WzRAXOWomgv2Ok
	 UCWJNTyJbD6mBvYRet5ePl0mvu2IiNcbFKbE8TVx1SYJpxcyhGkVjeh1el4HFVVNwnFP5
	 qdv6qwlT7bqpDQ0+YrTpNaiuG9kZ1CKv3BwWv/KlvfALLcFWON1Or7A6nVHzi62I278vm
	 SvRrbp5JB96/1+VjP4K7op+rIm/2DKN3R0Ky3S/RY8wxdvuG2Rbv6Zk+93YAI0cfM+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4M7PxFuU8qSz2RavNqay6nF75y2gZI7kCtSjuqmpMw8=;
	b=okKQJ6E+RxjsZpAUybwHzv2mda4igPhf8SoIkNb4E15kRjcQzIOfHrvxO8rluCKX1bdI
	 RfUnDX0Mt0JZE9XO94sTHf9NBfcIFa5VmzzUbAAcca66KsjGcSDAhvjlMtfq3rTMcEbZy
	 QPwWcbhSjduAQySVG5QPd0xDm8n79s0pw8hYdd8s9rYb5rQxNSqLJRfMFjvwEl7ojrePB
	 7RISjbSUUE5Uys20fyBi+4CkGWQNwy4iEqY7lggodanKcS0bSxkrWp6Kf4NvdvmAsv9jr
	 8jufLPUDrtnvx8fWYW1ifUDncQjhiVUewNEeexSOHvovWkJqs6tqr/tQgIPsQQkRhoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zj0GQ7bR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6A0606A31D;
	Wed, 28 Oct 2026 17:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zj0GQ7bR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5381F01828;
	Wed, 28 Oct 2026 17:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207821;
	bh=4M7PxFuU8qSz2RavNqay6nF75y2gZI7kCtSjuqmpMw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zj0GQ7bRSZWxijoqO8vxlaKuwTCZI8ax9rHGjVdBVxgrAPEpyA/xUT9IPC6BAHQ9f
	 6tRFQSGtANrqixgO/lmUSMOrf8BJYwNGSmSR+7LU+9qP+iyV7YzenV/5pxGzjxDzwo
	 ze3w3JQjZFeJZFdKuIPgYnDT/JNeKYYAfQ3pSDmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/247] tracing: Fix ignored return value of resize_buffer_duplicate_size()
Date: Wed, 28 Oct 2026 17:59:14 +0100
Message-ID: <20261028165950.988158943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kandybka <d.kandybka@gmail.com>

[ Upstream commit 3110d09bb98e3ac66482a7b257548a1683ec6c1a ]

When tr->allocated_snapshot is true, resize_buffer_duplicate_size() is
called to update the snapshot buffer size. However, its return value was
not checked. In case of a failed resize this could lead next snapshot
being incomplete.

Add resize_buffer_duplicate_size() result check and return error if
resize fails.

Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260928152634.4354-1-d.kandybka@gmail.com
Fixes: 180e4e390978 ("tracing: Add snapshot refcount")
Signed-off-by: Dmitry Kandybka <d.kandybka@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ sashal: Adapted the resize call to use max_buffer instead of snapshot_buffer. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7936e8cd7811e..2816708932d6a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7275,9 +7275,12 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		if (iter->cpu_file != RING_BUFFER_ALL_CPUS)
 			return -EINVAL;
 #endif
-		if (tr->allocated_snapshot)
+		if (tr->allocated_snapshot) {
 			ret = resize_buffer_duplicate_size(&tr->max_buffer,
 					&tr->array_buffer, iter->cpu_file);
+			if (ret < 0)
+				return ret;
+		}
 
 		ret = tracing_arm_snapshot_locked(tr);
 		if (ret)
-- 
2.53.0



