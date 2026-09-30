Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCA04FECE0;
	Wed, 30 Sep 2026 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783155; cv=none; b=sBsfKKnUhUp8Kq+dBoGyqCE9UARuqwysRXrEPaOPWfG9voqinDjcVDuhvyOi5a5leL7bkZQamsgu8SKSZ6pWM17o2hQzBl6K9xdQb8uw1G2jcEd+YH2ilbx1DfHAk3vfIDq2RckAHbQnwQAIczJbWLxPwzr9ouHwalwmTOwdXsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783155; c=relaxed/simple;
	bh=UXta+D97hSECDVr5agHzoB7KghSBAoEfY2wJyt5MM4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwcQH5cBK73Tlu/wYe4ZV4OGDx3jQg7YatfulI058IJGlHVOCUplx2fX8jUTKAeNJ5IP5frYNJNUB9YSy4sfX6+KrsovrzMgr3EE4OzTawpmNVdnFuZ7jrwFZN/TK+kcJsKVoF8jckPNgg/bVvTyhT82I8s65nzveAfZbVVefzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+40Mbfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+40Mbfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0311F000FF;
	Wed, 30 Sep 2026 15:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783148;
	bh=foAHT7YSaixLnoXUwDY7NfFRqqrjSqnW8ITH2aF0W8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+40MbfpdL5EeqmykwtnSFy/l2JIeqE0gzTp8wTF66tzpKGCnrWBXEiiFruQ3D91n
	 P6XTisKPe0cTq2j0EgrkddgRj0PZB2BLUQHuhD9ZwPFFD4EfOq86trYRww9OXdNzHS
	 tsKjKisFn/pggk34CHOfq6bYYHmMeNZbNjqizQqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.10 295/595] tracing: Free histogram the var ref when its initialization fails
Date: Wed, 30 Sep 2026 17:23:08 +0200
Message-ID: <20260930152354.039091559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit 516001d53e6b2ea95a251ee2ef54a1a689a3fd58 upstream.

create_var_ref() allocates a VAR_REF hist_field and then calls
init_var_ref() to fill it in. When that fails the field is leaked.

commit 656fe2ba85e8 ("tracing: Use hist trigger's var_ref array to destroy
var_refs") made destroy_hist_field() return early for
HIST_FIELD_FL_VAR_REF, since var refs are freed by walking the trigger's
var_refs[] array instead. create_var_ref() adds the field to that array
only after init_var_ref() has succeeded, so on this path the field is in
neither place and nothing frees it. The call was correct when it was
written, before var refs were taken out of destroy_hist_field().

init_var_ref() cannot free it either. The caller owns the field, so
init_var_ref() undoes only its own string allocations and leaves the
field alone. Freeing it there would leave create_var_ref() passing freed
memory to destroy_hist_field(), which reads its flags.

Call __destroy_hist_field(), which frees the field without consulting
the flag.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260906133352.3815019-1-donggeunyoo.kernel@gmail.com
Fixes: 656fe2ba85e8 ("tracing: Use hist trigger's var_ref array to destroy var_refs")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1853,7 +1853,7 @@ static struct hist_field *create_var_ref
 	ref_field = create_hist_field(var_field->hist_data, NULL, flags, NULL);
 	if (ref_field) {
 		if (init_var_ref(ref_field, var_field, system, event_name)) {
-			destroy_hist_field(ref_field, 0);
+			__destroy_hist_field(ref_field);
 			return NULL;
 		}
 


