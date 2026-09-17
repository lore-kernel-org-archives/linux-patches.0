Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96D33839A8;
	Thu, 17 Sep 2026 15:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660276; cv=none; b=BTUzzNSLtmzPq2KlrW0Fi+mPOXZ0LSJgoX/fag+9OldVDexdTUWEIHOtgbxaOBikLVDDn3x7OYbHjRtd597A7nuDlFfgBcnu7WnWSGF31mUod5bY55rgxZ22UYT6G0Ie5z8xyzYzYduXFt36QqWZ0TycfRXp5dNS2vxtUO89GIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660276; c=relaxed/simple;
	bh=8Uj2s3ow8o3EEv4k//O1OfMIWkmw2p6bY6Am+4Z6Q9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkDa6bFZ59CejLs5okzbXLEdvuZu1ylL/FLIsEnDQ/hHA76109w4LOP0RDWSCUG+YPS9wwcvUMae3EzjyPufesbjyampb6CWiz0qEB35TWV4U4qPwl0tUcWGFsrFro7isDISoYsXjfIlUp+GN1cJjR8GeXZxHD8T/HTtwE6DywQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/KWIO3S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/KWIO3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7A11F000FF;
	Thu, 17 Sep 2026 15:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660274;
	bh=t0J0ISgHd5+RodcLIb8WzS7JoZe3zAG7+OM9pPi8+0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/KWIO3Ssd4qGfLjuML5Gw/uj1eC59n0wK8kLZdDXTxpNNXxYTNAFjUOSYp73ejtK
	 mgJmCiikbEVJvNMDxULe0NDWwm4kV5rRa5fcYmtnYvivfdmRel47XkLig6HAOLccek
	 3BEKcOmqDY/gMrh3HLq3J2JuinHPulrbmFWu2FYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 498/733] tracing: Free histogram var refs regardless of how often they are referenced
Date: Thu, 17 Sep 2026 16:13:26 +0100
Message-ID: <20260917151404.494119341@linuxfoundation.org>
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

commit 4bddcb346a6cf4615ca77f69a589623b877ca267 upstream.

Using the same variable three or more times in one hist trigger leaks the
variable reference and its strings when the trigger is removed.

commit 656fe2ba85e8 ("tracing: Use hist trigger's var_ref array to destroy
var_refs") made a trigger's var_refs[] array the only owner of a var ref:
destroy_hist_field() returns early for HIST_FIELD_FL_VAR_REF, so the field
expressions never destroy one. One entry, freed once, no count needed.

commit 8bcebc77e85f ("tracing: Fix histogram code when expression has same
var as value") then made repeated references share one object and added a
count of them. Only the increment side exists, since those expressions
still return early and never drop a reference, so __destroy_hist_field()
sees how many references were created rather than how many are left. It
frees when the decremented count is 0 or 1, so two references work and
three or more leak.

Sharing kept one array entry per object, and create_var_ref() searches and
appends within a single trigger, so nothing outside it holds the object.
Removing a trigger whose variables are still referenced is already refused
by check_var_refs() with -EBUSY. Drop the count and free unconditionally.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260906124025.3550596-1-donggeunyoo.kernel@gmail.com
Fixes: 8bcebc77e85f ("tracing: Fix histogram code when expression has same var as value")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -170,7 +170,6 @@ struct hist_field {
 	struct hist_field		*operands[HIST_FIELD_OPERANDS_MAX];
 	struct hist_trigger_data	*hist_data;
 	enum hist_field_fn		fn_num;
-	unsigned int			ref;
 	unsigned int			size;
 	unsigned int			offset;
 	unsigned int                    is_signed;
@@ -1906,16 +1905,8 @@ out:
 	return field_op;
 }
 
-static void get_hist_field(struct hist_field *hist_field)
-{
-	hist_field->ref++;
-}
-
 static void __destroy_hist_field(struct hist_field *hist_field)
 {
-	if (--hist_field->ref > 1)
-		return;
-
 	kfree(hist_field->var.name);
 	kfree(hist_field->name);
 
@@ -1962,8 +1953,6 @@ static struct hist_field *create_hist_fi
 	if (!hist_field)
 		return NULL;
 
-	hist_field->ref = 1;
-
 	hist_field->hist_data = hist_data;
 
 	if (flags & HIST_FIELD_FL_EXPR || flags & HIST_FIELD_FL_ALIAS)
@@ -2218,10 +2207,8 @@ static struct hist_field *create_var_ref
 	for (i = 0; i < hist_data->n_var_refs; i++) {
 		ref_field = hist_data->var_refs[i];
 		if (ref_field->var.idx == var_field->var.idx &&
-		    ref_field->var.hist_data == var_field->hist_data) {
-			get_hist_field(ref_field);
+		    ref_field->var.hist_data == var_field->hist_data)
 			return ref_field;
-		}
 	}
 	/* Sanity check to avoid out-of-bound write on 'hist_data->var_refs' */
 	if (hist_data->n_var_refs >= TRACING_MAP_VARS_MAX)
@@ -3265,7 +3252,6 @@ static struct hist_field *create_var(str
 		goto out;
 	}
 
-	var->ref = 1;
 	var->flags = HIST_FIELD_FL_VAR;
 	var->var.idx = idx;
 	var->var.hist_data = var->hist_data = hist_data;


