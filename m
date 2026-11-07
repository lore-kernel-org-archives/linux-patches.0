Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062455;
	b=gm6cyPuURhZeNFh5Nw82ptit1M12nQ+ho2smR64Q6RVUQ42pPrNC9Uwq7OvpqymocLMS
	 9TZZHhmHFgeu3a048cG1cj+2a7q1QM6W51UnTaVqhCj5zLOaRXCwF6YQ1zMAStCn+eVUp
	 NdbEGm45AigtOTmqNGZvwOwHkWJ+WtjY1KfvQy9M/E02g+4wyqG/V2rvPpnUJOQhiggtg
	 /JV3wzv9t7ljmEAGk09PFbIom5JWusjcG/L1iIfh+UGi4ILodpU8Qdy6FqoPp/Xa7L5YF
	 kGoI0roJTJdEw3CkcrU+3+1j76IPAX+Zvij50uEEIBXzM/g40fqizZmdlM3mg3ggFIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3NHlOPq9mjWAAXRY9Dzm0nCXMb/YvndSz+zheWypuy8=;
	b=3N1PopW3dH4NAPWSBIfpJQVgTNjEB/ofMys/ohfg3GNLB0AG6MK+h6R1G7l1qcRkIrOS
	 W/TlNPHGAG+BpNjtpSX6hOeJdounrY5tuT9dKNxooUD+Rym77Yymq1w1NZPIsGolQvvxS
	 ule4CC/piOBHb2eijsbpvLzoTUgEQs+2Fx5z/w4dIYcap961Oo6ccEn7lYwiW1xOrznL6
	 jq7blth79tBUpCBXbMubuH5HJvsL2v3j9r9SLV5FW0a4YXK0NcTSuSWWZ7T3fS9HxVUa2
	 0zP5V4qhgkFifDAJLSf7N9qDDSG5YPm954+txUDNF/SWFqtGbaRBUy7eaTgomrYVcsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wSxrZ1M6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFF4606A642;
	Sat,  7 Nov 2026 14:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wSxrZ1M6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6B61F0089F;
	Sat,  7 Nov 2026 14:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062455;
	bh=3NHlOPq9mjWAAXRY9Dzm0nCXMb/YvndSz+zheWypuy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wSxrZ1M6uewSnqE7Jg4TJcl9+GloKi/W9Kw9W7iZIIv0Pl/h80tmJdmDFh0ZReleU
	 UcBv9F4EFrCj0lmbBNp4jGnTGLgY1DR56O8C42M3WbzzRAAyOwxu9JD3M8yiDMiX0i
	 L8UKmbAfKNiybJUFnOQHZNb+ru/xfj5xD9GJUyIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1324/1536] ring-buffer: Take cpus_read_lock() when changing the subbuf order
Date: Sat,  7 Nov 2026 08:55:40 -0500
Message-ID: <20261107135034.999674718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index e894a5686be30..a203c19cebce2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6828,6 +6828,8 @@ int ring_buffer_subbuf_order_set(struct trace_buffer *buffer, int order)
 	if (psize > RB_WRITE_MASK + 1)
 		return -EINVAL;
 
+	guard(cpus_read_lock)();
+
 	/* prevent another thread from changing buffer sizes */
 	guard(mutex)(&buffer->mutex);
 
-- 
2.53.0



