Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F9C2FB2;
	Tue, 27 Aug 2024 15:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770949; cv=none; b=iQX2XOlJBy3XMXwKR248l8tRaku0fuKU90ag47X2mhmwvgDGLVC33Ew079jTIIfOnq1Du/bYhLknDkdzKDpKC4kqlwxu6WQpKU4uTOiaFVlvNWKMBwusEXvtKrVkWMyqunpDh3oR593WT5ky6C1YoTsVm6iqnXY2zpjAtEVmVlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770949; c=relaxed/simple;
	bh=MPqbQjC+ezVNDhSozd7HGnkWQsjBgfzFTF6WlqL+HBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRO5cyYubcUrkW/9H+/xMik6FvO+NZQx5ZWIMomRggzGxLT0BiN/pW1QR/u7ohSA9Baehd4M2A1jRlPdy5OQkh9Lq1onnDzGpG11hsc2dGZ5xmw4CgSJeWcl5Noy4g/NMTiE62x3bMGy33wi0qTdt2Ud/Jal6ioMs6qZRQfKeBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KT/CDXoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KT/CDXoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA192C61042;
	Tue, 27 Aug 2024 15:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770949;
	bh=MPqbQjC+ezVNDhSozd7HGnkWQsjBgfzFTF6WlqL+HBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KT/CDXoKJ34IDD/JGrgzXO7a5Idla7Xp7cEntmdfba5aRq+DVebk3eWYKjxYSkQE+
	 dcwb1HyE5beYpT6q9QcmIYxrWXQxjMlP5Hv4ydJujbrQEyTnvDq64ljBCK4r0jzBoD
	 OE1n38rxFvcH0FfGcO3qTaKHIJdiAu853gOGoGNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.10 042/273] rtla/osnoise: Prevent NULL dereference in error handling
Date: Tue, 27 Aug 2024 16:36:06 +0200
Message-ID: <20240827143834.998387885@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 90574d2a675947858b47008df8d07f75ea50d0d0 upstream.

If the "tool->data" allocation fails then there is no need to call
osnoise_free_top() and, in fact, doing so will lead to a NULL dereference.

Cc: stable@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>
Cc: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Fixes: 1eceb2fc2ca5 ("rtla/osnoise: Add osnoise top mode")
Link: https://lore.kernel.org/f964ed1f-64d2-4fde-ad3e-708331f8f358@stanley.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/osnoise_top.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/tools/tracing/rtla/src/osnoise_top.c
+++ b/tools/tracing/rtla/src/osnoise_top.c
@@ -640,8 +640,10 @@ struct osnoise_tool *osnoise_init_top(st
 		return NULL;
 
 	tool->data = osnoise_alloc_top(nr_cpus);
-	if (!tool->data)
-		goto out_err;
+	if (!tool->data) {
+		osnoise_destroy_tool(tool);
+		return NULL;
+	}
 
 	tool->params = params;
 
@@ -649,11 +651,6 @@ struct osnoise_tool *osnoise_init_top(st
 				   osnoise_top_handler, NULL);
 
 	return tool;
-
-out_err:
-	osnoise_free_top(tool->data);
-	osnoise_destroy_tool(tool);
-	return NULL;
 }
 
 static int stop_tracing;


