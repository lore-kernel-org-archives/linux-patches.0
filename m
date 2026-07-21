Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771E140244F;
	Tue, 21 Jul 2026 17:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653939; cv=none; b=rlXRf2/bggJ/gosEyLjxNvUX91CSdk5THVX7GK45wDnW+XmJ14U3q6SseZprnmONqnSKT0c4HzcHyFrMLOcYsg+fkEYE+1ez0LqvFilnX05Ou56noZjnpQqU6j7aH7odo6lCa4ralXgE1EIeaBZIoqvjkri6hiI8nLnxvpi+OF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653939; c=relaxed/simple;
	bh=9iPSevNYP/RFZwm0snt9x9EDyZwovUDav0q6k5cPNAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnxsm+0VakXW+qGF+Du3HZoQGSpJIhj73EtPfoodoX7m7xzbDhVD7nUV58upvdzH+8oyBWPkNKmpbxsLeLhfRbOjrTBCASd7I5PyEwjGGAKPIjoYZpden0f3ZBswgieHms04zmbGtsPbaiPtp6p8opfY/1WExoKT1jYMNx5TQ1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gE7PnDfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gE7PnDfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0DF1F000E9;
	Tue, 21 Jul 2026 17:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653938;
	bh=G/LgwS791/8jaaaWSRDfabPaDVmWUEODygDUa+Jh6qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gE7PnDfodhqVIR3A5NHpoRvZUR1Y7ERh09JoHsvoLtEpwQw2bymIg8ezT1P5Zxj4b
	 yzrm0FUSo1pDZ6668G9Lrm4/cJpLEgVYfcb0O7Dl1O105JR6aPP4+tqMbYFIf01TA8
	 jKm2siFEf9fCIDnc1wHi11UFev0+UgYQiWmnyS9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1514/2077] ring-buffer: Allow sparse CPU masks in ring_buffer_desc()
Date: Tue, 21 Jul 2026 17:19:47 +0200
Message-ID: <20260721152628.493457167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit 601ddaceb861be7eb557278109966320a6f3478c ]

No user currently relies on sparse CPU masks, but the descriptor logic already
supports them via linear fallback. Remove the arbitrary limitation.

Link: https://patch.msgid.link/20260709160017.1729517-4-vdonnefort@google.com
Fixes: 2e67fabd8b77 ("ring-buffer: Introduce ring-buffer remotes")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index fcaa3761ef3eb3..da9339466bddd6 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2220,10 +2220,7 @@ static struct ring_buffer_desc *ring_buffer_desc(struct trace_buffer_desc *trace
 	size_t len;
 	int i;
 
-	if (!trace_desc)
-		return NULL;
-
-	if (cpu >= trace_desc->nr_cpus)
+	if (!trace_desc || !trace_desc->nr_cpus)
 		return NULL;
 
 	end = (struct ring_buffer_desc *)((void *)trace_desc + trace_desc->struct_len);
-- 
2.53.0



