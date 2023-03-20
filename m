Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B461C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8684FC433D2;
	Mon, 20 Mar 2023 15:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325794;
	bh=8L9HVobar10FaUPDLvq+ib92Ii0zI2ClCJQU03fK3M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCqTXl/1uxNgT6Yuk0x3BHZAI76zA7Bly9y0tyfDyvFj/ut0NNjnkcMLZmCiqLaT+
	 9/MCJ/Si49RpGh8ooRAaAx3IEjRMaAdy6pKL5F3gwKrg+tKQixlHAkjc2MQ3LzNQCO
	 HcybZmiwkBrnECmiIuUFkb/+kSl07Q2kmzt+WYrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 144/198] tracing: Check field value in hist_field_name()
Date: Mon, 20 Mar 2023 15:54:42 +0100
Message-Id: <20230320145513.590962566@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 9f116f76fa8c04c81aef33ad870dbf9a158e5b70 upstream.

The function hist_field_name() cannot handle being passed a NULL field
parameter. It should never be NULL, but due to a previous bug, NULL was
passed to the function and the kernel crashed due to a NULL dereference.
Mark Rutland reported this to me on IRC.

The bug was fixed, but to prevent future bugs from crashing the kernel,
check the field and add a WARN_ON() if it is NULL.

Link: https://lkml.kernel.org/r/20230302020810.762384440@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Mark Rutland <mark.rutland@arm.com>
Fixes: c6afad49d127f ("tracing: Add hist trigger 'sym' and 'sym-offset' modifiers")
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1330,6 +1330,9 @@ static const char *hist_field_name(struc
 {
 	const char *field_name = "";
 
+	if (WARN_ON_ONCE(!field))
+		return field_name;
+
 	if (level > 1)
 		return field_name;
 


