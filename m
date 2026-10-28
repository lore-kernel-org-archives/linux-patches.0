Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207204;
	b=z4VAe5F63UhM1gZb1T/V5+Ew/n+UBIawSpoWCUIXdZe07tnwMR1Ael9YwNlPzN5wwQ1U
	 +wwkmUebtFRfal9mzlKDkWRGac7i9HYOjzosOK6tbQ9Dlr6wj1+3xQuR3CR0E/z8abl5E
	 Y6QQ4xNjZFKA+qwUM0UDf8MyPYn7N/Jst0TfmhrNMlATGR7k76jF9uIQ/8teem+n5/LwL
	 pO7318kRR43MD5tAeKiTRot17q4rNKELNxcp9OS0AaMxzY5tOXYBd3ZXF2IPkJ9rrJ5cu
	 t8vz4jhXaviu/PsEkSe0Aa4i7g972MgVv9CW4ifaWUh/wL9PPw7ZA2eTJ31JtwKcsOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0TFtC0w1r1pEPqbXbAZL/ikZMCX+fWMsBM9nuRTv3FY=;
	b=3zxShygAuni0mGBJUWh9vCVxdVn8e3akYj34s7EgjT/HTzugNepvK6GjLLWfJOUopS3m
	 rwBKLBT39KjU0urvTlCFgk5Cvx/qW8HM6CrgtT76f+WPNkg9J7SlA7w1cCMLVt5hU2hqQ
	 j/ZFCjB6mGFif2MTmrwNtdMAxtJOuM7fdyyQpHGAxrbR51fqakUZs+nDQPWRDlexZ3UtI
	 k90M6zwEgZXUlIRlSLSW5gX77fRKUtfk/4V/S+ZE3lolJE+Zwf177tXNcH/+2/YQn9wPX
	 f58kZ22yw4gQeST8eddO7faYWiR/9NuSWc7L0ja/bavmsPV6wxtIujpwv9bgRwIGbUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TwtETpb1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4773606A31E;
	Wed, 28 Oct 2026 17:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TwtETpb1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74E91F031E7;
	Wed, 28 Oct 2026 17:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207204;
	bh=0TFtC0w1r1pEPqbXbAZL/ikZMCX+fWMsBM9nuRTv3FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwtETpb1EFZIjWTIONUNxH3S6dxydVDTJ3X0sqNPfHEkDmkmDQOPpIZOqM1WicloW
	 UK7R+c8ViNptsY74XgB6oyBlnPu3z274D2j+9FC0lOUdtI0rBFxA0839jfmkDomKtt
	 A4wYZZaVniQ9x2El786wy3VkQPwUUCSuXwaH4atQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 08/88] tracing: Hold trace_types_lock when updating modules in persistent instances
Date: Wed, 28 Oct 2026 17:59:16 +0100
Message-ID: <20261028165942.310825965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9261,6 +9261,8 @@ static void trace_module_record(struct m
 	struct trace_array *tr;
 	unsigned long flags;
 
+	guard(mutex)(&trace_types_lock);
+
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
 		flags = tr->flags & (TRACE_ARRAY_FL_BOOT | TRACE_ARRAY_FL_LAST_BOOT);
 		/* Update any persistent trace array that has already been started */


