Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDE7415F01;
	Fri,  4 Sep 2026 05:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498516; cv=none; b=FEqEqHGisPnySK6F697qv9Rz8ubSWDl01vWR2MUIAJkmYMqPfXU7JtGFU+mRCMD8zKUVGaEDGLsCtAi3QDfIHQYk8z+HWH8+0szE3lAGckJ8mS6WRVxHrni36m5cXmQVxwHmn9FLK2P4swEiW8Qcq+0TW0sJCTuy6sgBHkDjROg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498516; c=relaxed/simple;
	bh=EjZ/DFxLOz2K+7xkacWJVHoFlNkzgBclv12Sp7f0YNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TITGYH/TU9hOqbRB8KP23o9KQ61i5uh7rokzIsaPO2JzxHZLCXtJXj1E2Wt1cWz4RYzJwcLdGRQy60zPSrPImwWuDQGRibnn9OvHzIqxk15AH9/XAkWxey/l4Wh0MCotSo2ww4vZVYuZRdzUuSQsvza6naiCTed6DWXBtby8Ppo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arnZykI/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arnZykI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBFD1F00A3D;
	Fri,  4 Sep 2026 05:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498511;
	bh=BznajIsUmAWkIiGzQ9UHCBNkjQrIZOf/nL2VTadPs8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=arnZykI/G92xHeQ4G5mw2cFAcBJLe5yIfTa1Eh4nu2Cc47KRk2Xj14qFkYHxLeLBf
	 E+OeXazmkZAhPDnE0cJ7dJ75WGMtQknlhgYQoROltUOZeA9qXebkna0WpIXE8hPf7G
	 9L8BP1SXj50Ev6k5qjf4C3Rv3np6tDZqv49w3uFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 090/713] tracing: Fix logged instance name on creation failure
Date: Fri,  4 Sep 2026 06:50:58 +0200
Message-ID: <20260904045805.855262506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Vincent Donnefort <vdonnefort@google.com>

commit a9a01be2834a529cbd490ccbab02643f0c1735f2 upstream.

When boot instance creation fails, the kernel incorrectly logs "(null)"
as the instance name because strsep() consumes curr_str entirely during
parsing.

Print the properly parsed name variable instead. And while at it log
the error code.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260807085423.4175161-1-vdonnefort@google.com
Fixes: cb1f98c5e574 ("tracing: Add creation of instances at boot command line")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9726,7 +9726,8 @@ __init static void enable_instances(void
 
 		tr = trace_array_create_systems(name, NULL, addr, size);
 		if (IS_ERR(tr)) {
-			pr_warn("Tracing: Failed to create instance buffer %s\n", curr_str);
+			pr_warn("Tracing: Failed to create instance buffer '%s' (%ld)\n", name,
+				PTR_ERR(tr));
 			continue;
 		}
 


