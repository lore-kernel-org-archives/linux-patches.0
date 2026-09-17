Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156603EA955;
	Thu, 17 Sep 2026 18:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670504; cv=none; b=CaEzOVtA+JyqCLUPtN3B+6CVGqKvcVgfrfcuwACxwia3YJeYoZwM3ZHtmzWTPzQflGx0SkrStT6rvsvDSrEy2VLqOIwm+9riL8Pn2w6V955LBse1mftz/ZboaiT/YUVIjeuYDEOXbd7cov6Jb75ekp2q/ne6OwND8XObuCRQR34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670504; c=relaxed/simple;
	bh=MoK5xsEnTQXwxdmUy3jp6Oe+ZFnrnaooVnsaylmpzso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sz1zCMgZZ6ue6ZBwoE6SlNbbOYoNdjzHrCMh6ffZPs9HCfD7vfgTRTLS5Xp4k69zGwxATDKljvEsuY5cSF6zXFKO5V1WDlBZ95ItX1/3n75m8VUxsABMEmUAGfPie80OsydtWuymh9BJ006sLpNXkPA0bGoiP31P1t0FSHk1S4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WGNql+3I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WGNql+3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBB81F000FF;
	Thu, 17 Sep 2026 18:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670503;
	bh=Fo7ojOyjxQjHEzpdoshIJRMXfjbkagruGmgGqu831yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WGNql+3IqzZ2dnJF4J9DFW46THzUJIIr2d1G95FozD2CoTJG0Az+g6XGtv/iOhkI2
	 jwmsAPu+O7d7EPFvMMdWUyStCyWhEpiyDCw6lD8wIM7bJX7c/P8CwVT6VsTvcpYHOP
	 j88yVLsCnfrLM1Sd9kwR+1nyXzzyZiYb43y5v5aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0644/1102] ring-buffer: Add checking nr_subbufs to persistent ring buffer validation
Date: Thu, 17 Sep 2026 16:09:47 +0100
Message-ID: <20260917151556.313884069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index cfa08e9e64983..b4c7dd8c1d806 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1743,6 +1743,11 @@ static bool rb_meta_valid(struct ring_buffer_meta *meta, int cpu,
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



