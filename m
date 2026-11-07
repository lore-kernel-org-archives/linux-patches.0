Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063435;
	b=qI0W+VEAN7SLGvcvnomSFxIJWseyVKamstueg/gPIEkHAuUPIlIiwTsipwGMrvfKDgw0
	 1m2NXcQbr2fUtU6OUNv87Qrc+4lAR8w/DTGbL5FGAXxLvJnjZohVyx1s/gqDpDCjdtW4X
	 aiK1qeO3ZHToaRBWRvW5oY4mwHF0pG7fDk+Euq6eEKC7Twl908JkRXX70ejksqoYzRFwD
	 uUJdmrScPRS/MgV1gDrFKM9aNdMhRspxAUazWNuxLgu/vLE1AqeJt+IGdHktYOiv+NkXG
	 H9JvQHqREqHuIu41vO7kKtveOfhF+Z5hYDx0PR5tYlDEVo1w0RYjkFd/yJYHbd3A2yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BkMLqvaYqVDV3W44XAJv13qJUOgJxzL2+MYSt1alY/s=;
	b=MvPz98WS+9oWEbSC49fLNefM/79Ze20WsW6VYqvneoSdJuRb6r/2HvGNQrk/IdPdKdK1
	 /r+AzF4g/4U8WH1cVTNQpQ1RytDqVs+A+ROZgQTGjFNmtdBhRSlqcVRjolUe+zw2FuFoh
	 sxsHon+QR6e4ojePYeAoWtX6ZoZJoj7sgaEr7Kie85aOaNrmGLsUWPGwYpEuj3AstfUK/
	 Wn0BZ/j5xbCmsXJzKaE5EwPqPn/vAUoHLYPSH1IfL8jrOv11b9awbbF6WYP/VqZjPgHg4
	 yT7HCvnRzSsKiTdsx+RaGxyBIfejHNzlfdfGa3IlwoeaCgqAESdEG46NC3vMf3x3dfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iJOfBirI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5BB606D801;
	Sat,  7 Nov 2026 14:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iJOfBirI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F4D1F0089F;
	Sat,  7 Nov 2026 14:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063435;
	bh=BkMLqvaYqVDV3W44XAJv13qJUOgJxzL2+MYSt1alY/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJOfBirI0LDfa6QKvO47/R6i9yc0sS+JB6gqsQsve082Nu39o4wEvT13n/IQ8gTKu
	 a9mbyRrAGTRf+KZ+WuiKbXlSEhNvQ6oLXH2VTLfFbvDhtraz1NecmyCbGiIk33JNQr
	 iWq0z3klSW8fE6BurLe9fVSubrdi8/gaMS17ewdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 597/869] ring-buffer: Take cpus_read_lock() when changing the subbuf order
Date: Sat,  7 Nov 2026 08:54:39 -0500
Message-ID: <20261107134913.324751926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 453d0f47b174cac387af48d303c503b84f82212e ]

A CPU coming online for the first time gets its per CPU buffer allocated
by trace_rb_cpu_prepare(), which then adds it to buffer->cpumask. If that
happens while ring_buffer_subbuf_order_set() is running, the CPU shows up
after the allocation loop and the install loop walks it with an empty
new_pages list, corrupting the buffer.

Take cpus_read_lock() as ring_buffer_resize() does.

Cc: stable@vger.kernel.org
Fixes: f9b94daa542a ("ring-buffer: Set new size of the ring buffer sub page")
Link: https://patch.msgid.link/20260916192628.274136-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f74acc78866d8..dcb762664ce73 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7004,6 +7004,8 @@ int ring_buffer_subbuf_order_set(struct trace_buffer *buffer, int order)
 	if (psize > RB_WRITE_MASK + 1)
 		return -EINVAL;
 
+	guard(cpus_read_lock)();
+
 	/* prevent another thread from changing buffer sizes */
 	guard(mutex)(&buffer->mutex);
 
-- 
2.53.0



