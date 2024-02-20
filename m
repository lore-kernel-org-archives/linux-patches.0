Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6DF612D7;
	Tue, 20 Feb 2024 21:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463859; cv=none; b=MSYXcpx49s3pYvFJpnyxQJoqTcrEHS3M0zArNuSVL7ntM1KQb21YQInQGo0fTT2QtVSAUplqrFzP+LKZBdl6wd85FkLoX2iOtKvukCVL22W7k3vQB5NcGn+Gm+rMrlz2UNh1TPD06WXwTUBHHa+0QMpfN6HkKLXGhnTuCxY3IWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463859; c=relaxed/simple;
	bh=yTRgeRgK2XJJRZ408wFyY/S6H2NG/33bn62mfhbrXIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U846zKWNE4uyR+zJXh0OcjoOmI3iK8aYHoTiAyyW8HFDs2xN6wpokM39l6Si37NWCAUTPo0S8MRIBHrz1vnQ4+duT5W1RzJnutJuhhNWXy/rkqWrd5QUjUE3xYsjI2MGl7C4wTP5cF6YHJntDwKfPuvXB8t7bzoOZC2BQnHJpgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOxEOZIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOxEOZIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C7DC433F1;
	Tue, 20 Feb 2024 21:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463859;
	bh=yTRgeRgK2XJJRZ408wFyY/S6H2NG/33bn62mfhbrXIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOxEOZINFuyD5tfYf5jah8S4r5bQdSUt2BVbWap936QSq7g7QVDAnbC3Is/oS06cu
	 e3kq2JzZ9HBNPJnlFqNwyRLpoFIgeKMqBzfN5l7xRll6cUSoQUp8hepQzycAxEe9k6
	 jJLglqR2/k1NOWrIWn4Oo77l5BMM+y/XWMZp/3GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 175/331] ring-buffer: Clean ring_buffer_poll_wait() error return
Date: Tue, 20 Feb 2024 21:54:51 +0100
Message-ID: <20240220205643.014436056@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1091,7 +1091,7 @@ __poll_t ring_buffer_poll_wait(struct tr
 		full = 0;
 	} else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
-			return -EINVAL;
+			return EPOLLERR;
 
 		cpu_buffer = buffer->buffers[cpu];
 		work = &cpu_buffer->irq_work;


