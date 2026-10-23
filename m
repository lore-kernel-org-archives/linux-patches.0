Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774074;
	b=vC9zd1j6Bkg56pgHBodNG3UTQ4fAkzmqdx9QfuA/HgA2MDgSHkthY1HNDQtG+qrgvk5Z
	 rlOn9AW9aX7i00ktO2W+yuPYMaaKRP5Ni4oIGYyhQlOhBXd84Q54n5BcU352z0/tKkD5s
	 20h18gTFP2fvgLMueeM7UXAoVnS5MDK1XSHvd8YfWjWBjvOjpNfI1IreiE4/SmcTjo5b8
	 cV3jxNe/6U4Vf7BNji106PlVoCcnm6wbv2oBNppnG0KhtbHt/f2jsik1t7R41Tjd8QXoE
	 EzFlxxqriwcVH29RYOFAdJ1/fJvebLHpQzOaQ9/78TMZm7FKW3H2FxQyU/sKJAm3gHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fbahacrd+WDlaJ5geIeozvf4107lXBANxplfMc0F9ig=;
	b=dI3f9rh2gcFufgeeVboJyT7+9SZxoUdjQGoFsbY5yaPp2waTWjToD8YjJqpIABAjDd9/
	 hn8MoYI2GUD8NBfqs/TltaHVIPMKlu3hANsE0WLz2XJdsCQpUlVXnOpf5/hrAwHGNeSSN
	 yZZ+s0YawePF+WbHXqIZMwYs4PCTVUReuIOvvTnu0VOiqq604v+M9RslVoxf5+pwy1N53
	 NJIbn9kjf8+gGdlLnZ2+49XgoZXyLfmzaPEV6znvzX3kYmOIx4ObvTjamdqleZN7afJ1K
	 Zpn8TTVv3bz4Eu09FGB9vzAKGG/FURfeNLIPbeDeIYIvDI36KS/g7ualffb+xK/E3bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wKE00uJ4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EED6606A31B;
	Fri, 23 Oct 2026 16:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wKE00uJ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2811F01825;
	Fri, 23 Oct 2026 16:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774074;
	bh=fbahacrd+WDlaJ5geIeozvf4107lXBANxplfMc0F9ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wKE00uJ4vqsiseoVdhMiiQJmyStxRz2uToJlHYYQSVLL4nOJDi/VdqDWPjKV7114V
	 woVrIMCfAQVlG0CMKRbPhWi/y1oPKknP4225Ppj8kaGv2q4l3y0J/puV7zFQUE/M67
	 E4B39oL0+5lLF+j1KvqDUA8FmAo/9gbTOBOutTuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 095/193] ring-buffer: Do not show buffer_meta for CPUs without a buffer
Date: Fri, 23 Oct 2026 18:36:12 +0200
Message-ID: <20261023163716.451505698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

commit 3f23cae09a4677a3f7c163a68388512cb231ff22 upstream.

The per_cpu/cpuN/buffer_meta files are created for every possible CPU,
but buffer->buffers[cpu] is only allocated once that CPU comes online.
Reading the file of a CPU that never came online dereferences a NULL
cpu_buffer in rbm_start().

Fail the open with -ENODEV when the CPU has no buffer, as the other
per CPU ring buffer interfaces do.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260914133506.4865-3-devnexen@gmail.com
Fixes: 950032ffcee7 ("ring-buffer: Add output of ring buffer meta page")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260913134906.6E8A01F000FF@smtp.kernel.org/
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2293,6 +2293,9 @@ int ring_buffer_meta_seq_init(struct fil
 	struct seq_file *m;
 	int ret;
 
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return -ENODEV;
+
 	ret = seq_open(file, &rb_meta_seq_ops);
 	if (ret)
 		return ret;


