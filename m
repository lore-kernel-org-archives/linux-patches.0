Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501724B44D0;
	Thu, 17 Sep 2026 15:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660242; cv=none; b=JFIyvOJBib8r9bjZgIT7kId8qUQXQA7EVFtgMqeLPEnxavu0aDlsrqiKnOU3A64zQasq3u/6/z2SCocRFfRgrdgWHrzgB6pZMbgb+2R08aLQxVOK2y5DsaifdaR65hkMZjcG5rYYmebskykqek6waZhMGCEvCCBgpOVI48b3Kck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660242; c=relaxed/simple;
	bh=cf7pCj/aBe/fLXNh8GTnaTFQ1syU2oqpmgQiynPSp8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRwLnmZiL5P86UCo/W6lZHE9EubRPSy1IPbbJJ4oKF/CjZQ9rqU2rLRB7Q+/u/FNWv5Zqk/PFwi5NJlfxxMu6xIj028AeYucOOdZRw3RbCfeB+y1tExx1owaWalHSuhDhmk9QUddEA8xuVHKjIxIrm3u6HdDGsmNAAQwqn/Iqrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2c2Ibf6j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2c2Ibf6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0E11F00898;
	Thu, 17 Sep 2026 15:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660238;
	bh=6nDvUYZPl24U4HUfukVLhLWYhEVA3TVM3765qzj9ICo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2c2Ibf6jVxZIpl7ixNC232RY95U2c+xBpvprV6YECfaT4JWDv4lGyYG5jLcJ//QO3
	 WKa580rVA5OWSa/A3vwrpoVqB82uvX/DCsdXqf0W0D6PrKSmP6Lvxmt3nTF1IGi7uV
	 L1zaL5v/jqHp2epOtjDKuT9ntXr3YkO/FWqe7ZCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 524/733] function_graph: Use the saved entrys size when reprinting it
Date: Thu, 17 Sep 2026 16:13:52 +0100
Message-ID: <20260917151405.232280340@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit 0701995aaf8fc2281154db829ca85e231951e51d upstream.

When a graph entry does not fit in the trace_seq, print_graph_entry()
saves it in the iterator's fgraph_data and reprints it on the next read.
The entry has already been consumed from the ring buffer by then, so the
copy is all that is left of it.

The copy is sized with iter->ent_size, which no longer describes the
saved entry but whatever entry the iterator has moved on to. The
argument count is derived from the same field, so a 72 byte entry saved
and then reprinted ahead of a 48 byte return entry loses its arguments.

Record the size next to the failure flag, so that the two are always set
together, and restore it before reprinting.

Cc: stable@vger.kernel.org
Fixes: ff5c9c576e75 ("ftrace: Add support for function argument to graph tracer")
Link: https://patch.msgid.link/20260906034406.1335316-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_functions_graph.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -52,6 +52,7 @@ struct fgraph_data {
 	};
 	struct ftrace_graph_ret_entry	ret;
 	int				failed;
+	int				ent_size;
 	int				cpu;
 };
 
@@ -1274,6 +1275,7 @@ print_graph_entry(struct ftrace_graph_en
 		if (s->full) {
 			data->failed = 1;
 			data->cpu = cpu;
+			data->ent_size = iter->ent_size;
 		} else
 			data->failed = 0;
 	}
@@ -1457,6 +1459,7 @@ print_graph_function_flags(struct trace_
 	if (data && data->failed) {
 		field = &data->ent.ent;
 		iter->cpu = data->cpu;
+		iter->ent_size = data->ent_size;
 		ret = print_graph_entry(field, s, iter, flags);
 		if (ret == TRACE_TYPE_HANDLED && iter->cpu != cpu) {
 			per_cpu_ptr(data->cpu_data, iter->cpu)->ignore = 1;


