Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F340314D28C;
	Mon,  6 Jan 2025 15:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178025; cv=none; b=sUJKnQoKCrepzBT1zfk2J6824KxrBmW5FGsm40auy4uwMQcy4cZNFS0B1d6qxzpY8LBznIfeQR+GkEwFetrZHqgUij1JCs/wKNo7cOLNKsLRn8P4LPTGBVQp4e1cjwqvEM8VG8EGcA8Kq4C4Ca3159gwJEKYzL43pdLaCd8vfJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178025; c=relaxed/simple;
	bh=q/5hjB/TVsD+k8wawRxUufV9DZRWoHx71/fuk6U/wnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcUkUZqiKAViRL8z5Sk1LKbV6fwYPql+DaHSBRKcowFeCobGAudB7snob5p+m9797BYOVKetdyRG63mqvXXnEBkQlFcfc67xv8ELMKwA/qTq/OznOBapA11PBfmWvRuoKaYeHwdJwWYPenJWWLvPx5joSLa8wVt/3LKS2vuy9TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlFcYehO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlFcYehO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E373C4CED2;
	Mon,  6 Jan 2025 15:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178024;
	bh=q/5hjB/TVsD+k8wawRxUufV9DZRWoHx71/fuk6U/wnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AlFcYehOjL8ZjzSjhwgLWTWZlnmjN+vtPujXSFcjl0gA9ryJs5BAoxY/M/PeNL3ZM
	 jGAtcqkWXZNUT8AZ0i5Y2A5RrRFB5M/tZPYeYUmYxU2XnJoRcdt5h6f/zFDKscbifr
	 4WYCPIKlv74WvrlWnNc6IlpEspLVIHZoHJjxx2LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 136/156] fgraph: Add READ_ONCE() when accessing fgraph_array[]
Date: Mon,  6 Jan 2025 16:17:02 +0100
Message-ID: <20250106151146.854682139@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zilin Guan <zilin@seu.edu.cn>

commit d65474033740ded0a4fe9a097fce72328655b41d upstream.

In __ftrace_return_to_handler(), a loop iterates over the fgraph_array[]
elements, which are fgraph_ops. The loop checks if an element is a
fgraph_stub to prevent using a fgraph_stub afterward.

However, if the compiler reloads fgraph_array[] after this check, it might
race with an update to fgraph_array[] that introduces a fgraph_stub. This
could result in the stub being processed, but the stub contains a null
"func_hash" field, leading to a NULL pointer dereference.

To ensure that the gops compared against the fgraph_stub matches the gops
processed later, add a READ_ONCE(). A similar patch appears in commit
63a8dfb ("function_graph: Add READ_ONCE() when accessing fgraph_array[]").

Cc: stable@vger.kernel.org
Fixes: 37238abe3cb47 ("ftrace/function_graph: Pass fgraph_ops to function graph callbacks")
Link: https://lore.kernel.org/20241231113731.277668-1-zilin@seu.edu.cn
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fgraph.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -802,7 +802,7 @@ static unsigned long __ftrace_return_to_
 #endif
 	{
 		for_each_set_bit(i, &bitmap, sizeof(bitmap) * BITS_PER_BYTE) {
-			struct fgraph_ops *gops = fgraph_array[i];
+			struct fgraph_ops *gops = READ_ONCE(fgraph_array[i]);
 
 			if (gops == &fgraph_stub)
 				continue;


