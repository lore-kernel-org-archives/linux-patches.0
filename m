Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC4B221F24;
	Thu, 17 Sep 2026 15:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660273; cv=none; b=Sjssfg/zFNVHFCtyREWVFqCYiB5FZO5BN8MR9RzDLMMRYRK5AlnLiiS1SAPooS5Uq8VJrCzIYGIFtstLreuINdvgEl9bjUeuTuj2Z8YDl3zledr7Q29TGLNkRZ7jpS1lwE7Iq2+xd4dF2/4mTIL7PQV1e2OHjIkOb9qZocsy2xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660273; c=relaxed/simple;
	bh=+wUD7XJbaEOjTrGsaFPRq1ncJFe+cNoE/juOSi12Mkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idkrkH9BFgURmtDwn+Zj/VO+afg3VVBqumJvVisukNExOWRsXBU12neYIuCthNymvaUKiKThtxA6JRPSLvzBikkjvSKDsdXakvbzz7WI5x77KpzikIbcjvSdR9iE0kdj+YYLb4kGy1FZE05eRukjVtIdnZoNqaLkaNjDYUpVJjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyoiVOVD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyoiVOVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C622F1F000FF;
	Thu, 17 Sep 2026 15:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660271;
	bh=UaLL9A527DxROUT7l6qXRVzGmC+t3jMxbLaDRRHKA/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kyoiVOVDl6F7gRZ3DhGeXbTzCjuEv3cfOTlq2BpgGPlY1pVAlVkpZoyaHbE4K+CPx
	 BclKPcLOU6aiB5lXqXAggI5CIdLEt9IdFXC5OPB8jPxoCBQ136gvET7n/wdlhLtEkI
	 U3P46M7D+lgGNFdu/scCy5gohlrQTvVd7ovloABE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 497/733] tracing: Free histogram the var ref when its initialization fails
Date: Thu, 17 Sep 2026 16:13:25 +0100
Message-ID: <20260917151404.465399697@linuxfoundation.org>
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
@@ -2229,7 +2229,7 @@ static struct hist_field *create_var_ref
 	ref_field = create_hist_field(var_field->hist_data, NULL, flags, NULL);
 	if (ref_field) {
 		if (init_var_ref(ref_field, var_field, system, event_name)) {
-			destroy_hist_field(ref_field, 0);
+			__destroy_hist_field(ref_field);
 			return NULL;
 		}
 


