Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6501C4EF9;
	Tue, 27 Aug 2024 14:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769773; cv=none; b=Rghzf0O3B07FHqCJfW+V0fzUZ+aI9Hh9MmxVq4I2H426Ho7NyyflAH6ZAl21fFvcBHNMUPKfT+nFvtbr/vs18OOQ7ZaCzej2xNswP9fF1Xtb3kFlPV7ru7SR1UhnRDngK+JFJ63LUPziK9GU9uFKlJR7TXbs4OMKsqaY+OVfduI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769773; c=relaxed/simple;
	bh=T+7n6ckpWyn7uWiTNbRjZyrCDBwpHXf69XVAPar1Ddg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIjT4PfFVzLRcpJLcaK4sMG3DCc4G0CXSMc5L+v6wPjvKeBbX0lmxREww3MAT2MAndBfG0zhMzhVWrAqxbwuywyT/8yUBjKkC0XfXaMhg+EbPhjwnvkp6ZmGCnOfpP1UUhbPoujriWzUvRWNxHdRqHHgHtreOo2skMGYMcCduWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZI6putJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZI6putJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462B1C61043;
	Tue, 27 Aug 2024 14:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769773;
	bh=T+7n6ckpWyn7uWiTNbRjZyrCDBwpHXf69XVAPar1Ddg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZI6putJyTJSzoHTb77rZceTeHXpWjYFFPINV4F3pMty4LDig6um28817VG2khiDj2
	 vn7fSbM5Lr9y/6b5d3lCAVtJfAhBSIZ6hKSVRyneUvwwhuR6WWdWJoutNJRghrNnuS
	 lTYOFDAkDFxW4GTYJ/ByWw5alPwkkkmSSGsu1itA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 032/341] rtla/osnoise: Prevent NULL dereference in error handling
Date: Tue, 27 Aug 2024 16:34:23 +0200
Message-ID: <20240827143844.635310569@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
@@ -624,8 +624,10 @@ struct osnoise_tool *osnoise_init_top(st
 		return NULL;
 
 	tool->data = osnoise_alloc_top(nr_cpus);
-	if (!tool->data)
-		goto out_err;
+	if (!tool->data) {
+		osnoise_destroy_tool(tool);
+		return NULL;
+	}
 
 	tool->params = params;
 
@@ -633,11 +635,6 @@ struct osnoise_tool *osnoise_init_top(st
 				   osnoise_top_handler, NULL);
 
 	return tool;
-
-out_err:
-	osnoise_free_top(tool->data);
-	osnoise_destroy_tool(tool);
-	return NULL;
 }
 
 static int stop_tracing;


