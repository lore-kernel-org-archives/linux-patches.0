Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3351FB9
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2E6C433EF;
	Fri,  3 Feb 2023 10:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675420090;
	bh=N1No8VHBGzrYCWl0VMuFSPCS4kD9cyYqRKLukILRu4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=od6NmBl8xqf7c4NneXLI3pBJQUsIHrdEM9kTgjvrf+S6bJzKzZhsX99Zq5XK4PkUJ
	 V0LEIN9onorkHcQr+PVBfOqbCP8WpXyt1/7Vlhbucgkky2okB0Nxx9k3v6IA//F99c
	 K4TxIKUolN7nMULHiIzy6pYvhA556nVwgMejaISY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natalia Petrova <n.petrova@fintech.ru>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 076/134] trace_events_hist: add check for return value of create_hist_field
Date: Fri,  3 Feb 2023 11:13:01 +0100
Message-Id: <20230203101027.279301732@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Natalia Petrova <n.petrova@fintech.ru>

commit 8b152e9150d07a885f95e1fd401fc81af202d9a4 upstream.

Function 'create_hist_field' is called recursively at
trace_events_hist.c:1954 and can return NULL-value that's why we have
to check it to avoid null pointer dereference.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lkml.kernel.org/r/20230111120409.4111-1-n.petrova@fintech.ru

Cc: stable@vger.kernel.org
Fixes: 30350d65ac56 ("tracing: Add variable support to hist triggers")
Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2552,6 +2552,8 @@ static struct hist_field *create_hist_fi
 		unsigned long fl = flags & ~HIST_FIELD_FL_LOG2;
 		hist_field->fn = hist_field_log2;
 		hist_field->operands[0] = create_hist_field(hist_data, field, fl, NULL);
+		if (!hist_field->operands[0])
+			goto free;
 		hist_field->size = hist_field->operands[0]->size;
 		hist_field->type = kstrdup(hist_field->operands[0]->type, GFP_KERNEL);
 		if (!hist_field->type)


