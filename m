Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37E5127B70;
	Tue, 30 Apr 2024 10:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473773; cv=none; b=fdMGKwn3N87JzMBb3lg7uy9d1sVPU3ddYnYkuKzmXKdarHvVndPyKXZGbUokqHUKTJKYlkWCu7Q+203sKaCl6xBx43/NRhfjrt2HJLxpbP3hnCbwSIDyt7yAXq1zm4h09MsAouVDd6gxsZ0PZUG5/PxLd3XnKnTKFqPUB2JewrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473773; c=relaxed/simple;
	bh=YGTLPgDFSMmZc49bhfn5cbmK8e3H7l1PzpynqRn5yGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTNsfk1bSh4pnphjQvCQvqSxNSobM3PZaQ5ol2doQLaFIONdhi+b8B/spJgMzidvcUdcW8zOne2EVZ5wQ+nne88sVNKLMNY1fh/8svEu0MO16PfNU8SSt2N8LnHm0GQ9bSCxBmT7Fzh14ChabLbMB9jr1fHKAVa8lpPSp7lmKSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvhcLRDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvhcLRDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6973EC2BBFC;
	Tue, 30 Apr 2024 10:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473772;
	bh=YGTLPgDFSMmZc49bhfn5cbmK8e3H7l1PzpynqRn5yGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvhcLRDp5D2hFIYGkAYSaQ7wW7Ur5YFjfkxGkrYfOAOKjZ2ot6ewa/MA7V3Hch+6E
	 CDjXxtTTd6ABR3jcat+ndStThZ0L/Oskew50bBBpf8XXxgcA7XouWk16sVg4yqwacf
	 0bRG/jX7eZF+CF5vJOsnC8FUqAhaV8qyi2zXOW0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	stable@kernel.org
Subject: [PATCH 4.19 16/77] Revert "tracing/trigger: Fix to return error if failed to alloc snapshot"
Date: Tue, 30 Apr 2024 12:38:55 +0200
Message-ID: <20240430103041.603847893@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddh Raman Pant <siddh.raman.pant@oracle.com>

This reverts commit bcf4a115a5068f3331fafb8c176c1af0da3d8b19 which is
commit 0958b33ef5a04ed91f61cef4760ac412080c4e08 upstream.

The change has an incorrect assumption about the return value because
in the current stable trees for versions 5.15 and before, the following
commit responsible for making 0 a success value is not present:
b8cc44a4d3c1 ("tracing: Remove logic for registering multiple event triggers at a time")

The return value should be 0 on failure in the current tree, because in
the functions event_trigger_callback() and event_enable_trigger_func(),
we have:

	ret = cmd_ops->reg(glob, trigger_ops, trigger_data, file);
	/*
	 * The above returns on success the # of functions enabled,
	 * but if it didn't find any functions it returns zero.
	 * Consider no functions a failure too.
	 */
	if (!ret) {
		ret = -ENOENT;

Cc: stable@kernel.org # 5.15, 5.10, 5.4, 4.19
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_trigger.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1133,10 +1133,8 @@ register_snapshot_trigger(char *glob, st
 			  struct event_trigger_data *data,
 			  struct trace_event_file *file)
 {
-	int ret = tracing_alloc_snapshot_instance(file->tr);
-
-	if (ret < 0)
-		return ret;
+	if (tracing_alloc_snapshot_instance(file->tr) != 0)
+		return 0;
 
 	return register_trigger(glob, ops, data, file);
 }


