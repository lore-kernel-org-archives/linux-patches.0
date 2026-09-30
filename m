Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E5B3D3002;
	Wed, 30 Sep 2026 19:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795635; cv=none; b=Usr9ge4wb78YhOwfeBP8+N1e4M1Oc0e9va6BXI3YZDnjBQqp1b0LxwuraB+PE6gGkKfi+LhoNubSVJ611gOabQKgIdSTX/HYjf6fIVdIXidQca/oLAPXd4sWnCNP2TybSgPHxsoxNUDWAiYOoLFo2ShEZJwOjOKWePpxbZ6eXec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795635; c=relaxed/simple;
	bh=Sp7FfJYLfdSsZYIMeSFkK4mG0eQODGpaKfhCVMuANog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aoThVuQmzysRTA11IAUYki1Fo3d/FCktZNmwu5yRjiB0USyucb4zuujQfrxXD/12XnKENCsM4qYBiYh/B8k+Z7YbrjxrjedTQFRaAmNOik3xS2oq9s334fRkBZ6XYY6cY5J3SdUOi8GyowWjM63+l40GNGfLKZ5hE/CS0fR4QHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5j6/Ujn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5j6/Ujn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7D71F000FF;
	Wed, 30 Sep 2026 19:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795634;
	bh=cTJinOJYYGza5orPAHGPYt29Vw6XBXpANbeeoabgA8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X5j6/UjnANnawtpSxqObU1uJcb55OCVAlNYcmv5S/HoWIKlZeTgYU3UnszblOxifk
	 ZgT6ymaCbNK2/qGu3X6TScjqZ3uxqB/flBdZVqVMNHf0JPKjPNO0zAN0U7aYHjtgbv
	 jQBgl0quxTMsUqXRY3DLQBtrueOj/Cd8+kfBxwQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 0613/1193] tracing: Free histogram var refs regardless of how often they are referenced
Date: Wed, 30 Sep 2026 17:21:37 +0200
Message-ID: <20260930152447.862813664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -163,7 +163,6 @@ struct hist_field {
 	struct hist_field		*operands[HIST_FIELD_OPERANDS_MAX];
 	struct hist_trigger_data	*hist_data;
 	enum hist_field_fn		fn_num;
-	unsigned int			ref;
 	unsigned int			size;
 	unsigned int			offset;
 	unsigned int                    is_signed;
@@ -1895,16 +1894,8 @@ out:
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
 
@@ -1951,8 +1942,6 @@ static struct hist_field *create_hist_fi
 	if (!hist_field)
 		return NULL;
 
-	hist_field->ref = 1;
-
 	hist_field->hist_data = hist_data;
 
 	if (flags & HIST_FIELD_FL_EXPR || flags & HIST_FIELD_FL_ALIAS)
@@ -2200,10 +2189,8 @@ static struct hist_field *create_var_ref
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
@@ -3242,7 +3229,6 @@ static struct hist_field *create_var(str
 		goto out;
 	}
 
-	var->ref = 1;
 	var->flags = HIST_FIELD_FL_VAR;
 	var->var.idx = idx;
 	var->var.hist_data = var->hist_data = hist_data;


