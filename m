Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B6C3CAA41;
	Wed, 30 Sep 2026 19:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795667; cv=none; b=NnnWhOg2bRNdenuHESlvIRsSPnvOMNi3W8Swja4C8CJvQJbfO8OeC8qXCRHQpG4r3jMaFR7gI5rVX0qkgW9ZVhl7sPknhYlhuJ3peNd9mQ43tSGnVyG1bhHjV0JyhV0RuhgLjcHkTg0h9XuJlfq7FCRLLuIdq8AKdub4J52oZmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795667; c=relaxed/simple;
	bh=xwpIJR1PTT28GRMU/yPaTuCUo+67saILqLVIFr+H/cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPZp/hwoo4Cn1ydo8+1sOnchrnpPH3H32Dkd/0K77XD5pfu7DgwWX2X+372ToK8PhI2Ws2xy19aTpCl0bf8vYan+NVvWa8PSac2Cx5Ha7CkHsB+0CpCracVSGvJtKsRcE123U4oZ7BLlyfwtud948OSrBK8lSq9YRzHTLlvYbiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19ACLzS3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19ACLzS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CD41F000FF;
	Wed, 30 Sep 2026 19:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795665;
	bh=M4XBMUEQ16O77yrZ2aUtueA4kImZTW9PCafW0CAHCS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=19ACLzS3akK3Kq8dKPUmzFJNALPUvcJaQuDlkU/HPBbdWk4X1KEthQGobB4bhsvSI
	 DptLrpaiSjXFVyCK3g0nR1HgmgyiVOQfoZPP4u/rUt4Qi2QOdQprPifpZDa0h5ypdp
	 FE873zKCFzicXCq85VjCMKhK0zcZFf9vGzCy4B3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 0614/1193] tracing: Free histogram the field rejected for a bad modifier
Date: Wed, 30 Sep 2026 17:21:38 +0200
Message-ID: <20260930152447.883621357@linuxfoundation.org>
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

commit 230234d12ce42ab04132a32c3a848f07a5d27a71 upstream.

Writing a hist trigger whose value or variable carries a modifier that is
not allowed there leaks the fields that were built for it.

__create_val_field() takes the field from parse_expr() and stores it in
hist_data->fields[] only after the modifier checks have run:

	hist_field = parse_expr(hist_data, file, field_str, flags, var_name,
				&n_subexprs);
	...
	if (hist_field->flags & HIST_FIELD_FL_VAR) {
		if (hist_field->flags & (...))
			goto err;
	} else {
		if (hist_field->flags & (...))
			goto err;
	}

	hist_data->fields[val_idx] = hist_field;

Both checks jump past that store, and the err label returns without
freeing anything. The error unwinds to create_hist_data(), which calls
destroy_hist_data() -> destroy_hist_fields(), and that reaches a field
only by walking fields[]. A field that never got there is unreachable.

commit e0213434fe3e ("tracing: Do not let histogram values have some
modifiers") set ret to -EINVAL and fell through to the store, which left
the field owned by fields[] and freed along with the rest of hist_data.
Splitting the check into a value case and a variable case replaced that
fall-through with a goto that skips it.

With CONFIG_DEBUG_KMEMLEAK, 200 writes of

  # echo 'hist:keys=prev_pid:vals=next_pid.log2' > \
	 events/sched/sched_switch/trigger

each correctly rejected with -EINVAL, leave 332 unreferenced objects
(63744 bytes) reported at create_hist_field(); 200 install and remove
cycles of a valid trigger leave none. A '.log2' field is two
allocations, since create_hist_field() puts the plain field in
operands[0] of the log2 field, and both are reported.

Use destroy_hist_field() rather than __destroy_hist_field() so that
operands[0] is freed as well. It returns early for HIST_FIELD_FL_VAR_REF,
which is what an operand owned by hist_data->var_refs[] needs; the
rejected field itself is never a var ref, because a var ref never carries
a modifier flag.

Cc: stable@vger.kernel.org
Fixes: e30fbc618e97 ("tracing/histograms: Allow variables to have some modifiers")
Link: https://patch.msgid.link/20260907034948.240387-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -4283,6 +4283,7 @@ static int __create_val_field(struct his
 	return ret;
  err:
 	hist_err(file->tr, HIST_ERR_BAD_FIELD_MODIFIER, errpos(field_str));
+	destroy_hist_field(hist_field, 0);
 	return -EINVAL;
 }
 


