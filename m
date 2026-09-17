Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E34158F07B;
	Thu, 17 Sep 2026 15:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659383; cv=none; b=FXNKKI7d7zkztmJeTBKOJXVsTojwORqH/B65pjKKkBf7JSC5zz0eKt4Bx5HNAtzcWoCU2ejh+EyAq9sDpH1vbM6JFsknX5ewAjuX1r5vA31HcpCicesiEE/km6JKj5YLkr040LACXVI15Bff3XDOEilCL14dEyZCcUUf0DkYKx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659383; c=relaxed/simple;
	bh=8oVZ/UUIdgEQ3w0WGGQB5BBdILx8zevcYlonEKJEBiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8DLi0Zi5YVN7yIOfJ7rQIUBsk1S/2urbLEeafySW4GeBJ0sYaO2t5PlZlX7f6sseeq7v7y0ZWBDH6n3nLb6IQvNO8YCy6KLnrU6SE1Ju1ZO7YLOxk27ljuHGQaWc9xQtkz5nsUwWQN4rOP2Wy7KX8vwxXsSk44QOTueIBCytn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0VQList; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0VQList"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B2C1F00893;
	Thu, 17 Sep 2026 15:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659374;
	bh=qLQ7p9kD8yiWhf3Z+WuG9aIwJ61F7xdY6slmJyDisHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0VQListN0Xex33dIoqXXsFIRKeznjxoxgLOjg7S0ccSjVZHwQjpvz3xZpOXk2amE
	 hQQO8+rQh47DpU5Qwyo/siAL449H8nO7MILVbwNs5BDjuJG7pB1Qcs+LQvlP37AOIf
	 /vVgxxlBYPKv/b/mBUk8ROyb087Fao0kbTmNB+5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 234/733] ring-buffer: Add checking nr_subbufs to persistent ring buffer validation
Date: Thu, 17 Sep 2026 16:09:02 +0100
Message-ID: <20260917151357.067023815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 6c001a62c34f13fe1c6a24304c289b387d9e697d ]

Sashiko reported that the code was using meta->nr_subbufs without making
sure that it matched the nr_pages + 1 on data that was assuming the two
were the same.

Add a check to the persistent ring buffer validation code to make sure
that the saved nr_subbufs matches what we expect.

Link: https://patch.msgid.link/20260903132728.7fb27d34@gandalf.local.home
Fixes: f5b95f1fa2ef3 ("ring-buffer: Validate the persistent meta data subbuf array")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260901164836.D962D1F000E9@smtp.kernel.org/
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1925ee9cc36da..70e43fe3a1006 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1836,6 +1836,11 @@ static bool rb_cpu_meta_valid(struct ring_buffer_cpu_meta *meta, int cpu,
 		return false;
 	}
 
+	if (meta->nr_subbufs != nr_pages + 1) {
+		pr_info("Ring buffer boot meta [%d] invalid nr_subbufs\n", cpu);
+		return false;
+	}
+
 	buffers_start = meta->first_buffer;
 	buffers_end = meta->first_buffer + (subbuf_size * meta->nr_subbufs);
 
-- 
2.53.0



