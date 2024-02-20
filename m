Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA48151CF4;
	Tue, 20 Feb 2024 21:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463044; cv=none; b=kHiuVxQNYyAq2GgmACNLTlKL0uS1cdAhTRqLTNWKYHVKe4I33W4oXFuDFt1xnSyf8IPO/2GrfNqKjc8a6RGhEpc+lTZflxOUSjEXKlJkmiaeUZB+lPHMSri5MD7dfXzM+0Wx5UA9WSr9TAyUsjwK3wafKdLQbZOd6JstBceg2xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463044; c=relaxed/simple;
	bh=V7jItIPJ76X8au/4zlH0+rsgiwgEa3U9xmZ02lloB0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbvdK1sd5cyLCTkxfsyWTpbfVRPLRAU04Zd5tqPcxU0Fg3fu+yZV/Uyd9Dtu+KIC58B0AUgQO/sbHJyax6Z73hg11p56M8m44tz9PBw2VsYTFVBEaTY/zq9l7LdPGTWxyBcMe4ckr6fo8dljWJMY+pn6nln/yUpt8D6WUTxlKEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEuTaaL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEuTaaL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2888C433C7;
	Tue, 20 Feb 2024 21:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463044;
	bh=V7jItIPJ76X8au/4zlH0+rsgiwgEa3U9xmZ02lloB0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEuTaaL/UxYFm2M4ll+UU1pk+2u17Xu8pQovH5ZOwTb1c8nZ6v0A9jsV5ZAcYeFSR
	 NAislypUyV6WC7Lii2QB2zkT/a18GL7PPOt/+67Qul2obanzsEWZchipe9Jc2I0G6K
	 80z1mv07oYDuQMmPJ2RVYsisGpwijnoDyu/cm4ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 118/197] ring-buffer: Clean ring_buffer_poll_wait() error return
Date: Tue, 20 Feb 2024 21:51:17 +0100
Message-ID: <20240220204844.606976677@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

commit 66bbea9ed6446b8471d365a22734dc00556c4785 upstream.

The return type for ring_buffer_poll_wait() is __poll_t. This is behind
the scenes an unsigned where we can set event bits. In case of a
non-allocated CPU, we do return instead -EINVAL (0xffffffea). Lucky us,
this ends up setting few error bits (EPOLLERR | EPOLLHUP | EPOLLNVAL), so
user-space at least is aware something went wrong.

Nonetheless, this is an incorrect code. Replace that -EINVAL with a
proper EPOLLERR to clean that output. As this doesn't change the
behaviour, there's no need to treat this change as a bug fix.

Link: https://lore.kernel.org/linux-trace-kernel/20240131140955.3322792-1-vdonnefort@google.com

Cc: stable@vger.kernel.org
Fixes: 6721cb6002262 ("ring-buffer: Do not poll non allocated cpu buffers")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1095,7 +1095,7 @@ __poll_t ring_buffer_poll_wait(struct tr
 		full = 0;
 	} else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
-			return -EINVAL;
+			return EPOLLERR;
 
 		cpu_buffer = buffer->buffers[cpu];
 		work = &cpu_buffer->irq_work;


