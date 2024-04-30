Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FF41E50A;
	Tue, 30 Apr 2024 11:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475893; cv=none; b=eLwLhDzGw9z7rntr3p5prjXnSx2iC9C2ANwVowhCTgQxUIVVNtge+kYOAOwVJXyTtgyCgOJdTpb+ifWsbu6xSEU4h3jUR29rWtdmWcbmOqFrIR1366Nx05pQy8af2v3fUi/p+lWC5EUK9HrvYjDUQcjbcM3EPuO+2+fi9vj+hOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475893; c=relaxed/simple;
	bh=QJzPOpjf9BN5DLIdBHHfkBVuqYwH7GkWVA5dgIc1wjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKleNL87IG2Ve0KpjlIxzgOeI/7jdYa53Gc+CluwrSjVI/gon4whbOOaKLMApaU4qMyXIcrVV8erRR8upnfABHx0tE9cu+eBIoVe14kZ3ZjG31n2//ivfpGIUzRlFspn3uSWHLm9MF9VSf5ZJTN5h4qn4BoJSREpZvH6VUjq0hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iQoGS29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iQoGS29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B96C4AF48;
	Tue, 30 Apr 2024 11:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475893;
	bh=QJzPOpjf9BN5DLIdBHHfkBVuqYwH7GkWVA5dgIc1wjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iQoGS29uXASxsOMnk62RdMxCClvx7pRVv+7kZ3ML+TOtDAIwgcf0uagymIPE+f9A
	 C+tMEp4aHAgXsEDi8DKTIs36vMQ86uMT72Fyh6H6kaSRFcOlgk7ZLPujdWGntiq9fv
	 VxV8MdHYHKXvDndrLJATR0K3o0bVjDX0MeOEUNzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Robin H. Johnson" <robbat2@gentoo.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 50/80] tracing: Show size of requested perf buffer
Date: Tue, 30 Apr 2024 12:40:22 +0200
Message-ID: <20240430103044.896215500@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin H. Johnson <robbat2@gentoo.org>

commit a90afe8d020da9298c98fddb19b7a6372e2feb45 upstream.

If the perf buffer isn't large enough, provide a hint about how large it
needs to be for whatever is running.

Link: https://lkml.kernel.org/r/20210831043723.13481-1-robbat2@gentoo.org

Signed-off-by: Robin H. Johnson <robbat2@gentoo.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
---
 kernel/trace/trace_event_perf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -401,7 +401,8 @@ void *perf_trace_buf_alloc(int size, str
 	BUILD_BUG_ON(PERF_MAX_TRACE_SIZE % sizeof(unsigned long));
 
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
-		      "perf buffer not large enough"))
+		      "perf buffer not large enough, wanted %d, have %d",
+		      size, PERF_MAX_TRACE_SIZE))
 		return NULL;
 
 	*rctxp = rctx = perf_swevent_get_recursion_context();


