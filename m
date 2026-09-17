Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460903BD65D;
	Thu, 17 Sep 2026 18:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670946; cv=none; b=tBXnUTlgQobv3N7Mw0S6kv3OqSb1jTphtgaIxWMyFokBmiWKHL580nyPdxcXdJs0LpagTa9hCa+0AVE13v5cJUkNkH2bijjVZBCVG7S0bntXAmJh859KLjQpd1mIgczOwsbDaJ2i6wwjikh2qcOL/vXAk4I4OSMn+YsW2h0CgK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670946; c=relaxed/simple;
	bh=goVFXJGfekdidxlr5Rwg+5H39eBS6FSErNk+umYiYxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtVeuj57bG2QWO7+Fi9PFqgNUdwtpALsz8vs9JDtmaoYK0OsQY5LjF9my/KdZQ3PWtNULKu4S0HCCXWeD1xw+Nzcq4EVYSs/nweTaYB0T8TnbttzBqi842fHQQ97I7EHM6v/a8unQxIp9TNzHJ5v2fBPZ5sdaDDE3OmXiLsr0rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SyaZnG//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SyaZnG//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBE51F000FF;
	Thu, 17 Sep 2026 18:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670945;
	bh=EiJKClNSaEMiKkiWDidUZJvC0dQmzl7OvLsYliGtjsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SyaZnG//5mQiXSoFR9ZKw1+UoLP5Mre1YBemIoF2z1s6wcmEulkS+H0Dc89d+tK/I
	 viogPI8732sXityBktvfyHMk5Cyqb4eP/zIl37rFyAppFAy+mofw2gsxBNnAGp07dx
	 n9zQqYCX5pMJ1/B1TK6OkGSoddXNJ756z7WtrCgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 0820/1102] tracing: Free histogram the var ref when its initialization fails
Date: Thu, 17 Sep 2026 16:12:43 +0100
Message-ID: <20260917151601.087984466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2211,7 +2211,7 @@ static struct hist_field *create_var_ref
 	ref_field = create_hist_field(var_field->hist_data, NULL, flags, NULL);
 	if (ref_field) {
 		if (init_var_ref(ref_field, var_field, system, event_name)) {
-			destroy_hist_field(ref_field, 0);
+			__destroy_hist_field(ref_field);
 			return NULL;
 		}
 


