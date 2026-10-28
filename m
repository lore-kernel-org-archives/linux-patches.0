Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209672;
	b=cTxhQ0CzbaxbwI7xCam9vrWG0guvYMBGyOc8gvvnCmPsm0aaLRShG4a3O251ha1KxySL
	 BLfp4GYQY6gQ7Whg1q2EmGadcOhHal9hga/xMGiWD2Y2/3Gn8Wc7ISoHZwfzUQERSgmFi
	 RDgNcOAFnvmBVesWtg3cUJquO7duYvrq/9jbu2xWpBmy38z+xFEm2BdeWJhSP5EjWCrtI
	 a25CiWcYrwn78BJm4g3azb/jaq9zmjmeuvfPfhLnbIt16c7xcp/bmA/G78RDjo6q1K/NU
	 zf3tTSC2BS9hrX6jYyLFJzfkLj9OWrcgEIBVWJ6ZokRa9OWjda7JknWBXp2Wl1kRDyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vVrxKmsBzugMfWdKx55A8vkNJcZq0kd7/HJyl1vOvt8=;
	b=IRIlAYMXqoLqeS2OfVUZ62iuuBEj1JvsQ+1DAo57Bnkpme2mzdFoPpJrp2e9WgE7SitX
	 dR5ZChGk9ZAKVn2Z8MR+b8D1CGqR6RQj49eACbL7qXyS+QFlKddUM70uvmT/0uAh42Gnq
	 eWYpRmYh9yKwYSe29mT7zjSxq9iO4oglk+UWvxtsgFWwsCh/6fE9Erruzq76cp42sRtnn
	 pvQ4QXWPbVwpurQXn16/J/V1QkZq1n/DCpFtXBY6tf1b/AsaVVbnq2hwvdLNn2ZTXFDXx
	 F6qswww7Otvw5t82wB4FGfO1lF67x6tsOx7oYeW5vk7FhskeXSMt5OFXx12MXYkVdoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Np/exAlV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5680606A31A;
	Wed, 28 Oct 2026 17:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Np/exAlV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9771F01825;
	Wed, 28 Oct 2026 17:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209671;
	bh=vVrxKmsBzugMfWdKx55A8vkNJcZq0kd7/HJyl1vOvt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Np/exAlV2SYlEplcSm2jw0jMMD+y7CmIa1J6hfWKRMWQqA7A4znGAk8dOJXlE/rKI
	 C7wZyt84X2l0SvYjV40DGmZE7lHzSu/o+Yiw9Ge/362OE5BMcXjqX84EWyvH1P+k3U
	 eUrTQWYD+rsHeo086NGIatFwPYZ6PXstOCjbhE3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 035/109] tracing: Hold trace_types_lock when updating modules in persistent instances
Date: Wed, 28 Oct 2026 18:00:19 +0100
Message-ID: <20261028165943.188394872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 66877a312ae3c2c3d849e82e882f642ffd4ec3e2 upstream.

trace_module_record() walks ftrace_trace_arrays from the module notifier
without trace_types_lock. A concurrent rmdir of an instance removes it
from the list and frees it under that lock, so a module load or unload
can walk into a freed trace_array.

Cc: stable@vger.kernel.org
Fixes: 5f3719f697c3 ("tracing: Update modules to persistent instances when loaded")
Link: https://patch.msgid.link/20261016061638.214847-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -10693,6 +10693,8 @@ static void trace_module_record(struct m
 	struct trace_array *tr;
 	unsigned long flags;
 
+	guard(mutex)(&trace_types_lock);
+
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
 		flags = tr->flags & (TRACE_ARRAY_FL_BOOT | TRACE_ARRAY_FL_LAST_BOOT);
 		/* Update any persistent trace array that has already been started */


