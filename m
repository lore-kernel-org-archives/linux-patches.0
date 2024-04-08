Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FB379F0;
	Mon,  8 Apr 2024 13:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584136; cv=none; b=a6oDD84BCwUWwnI3mnBEgnx1pii+r99qWmYfLkSyQtJMQ8YAtkpWxsiwA7CEzGmmFe8psJZMPIOu+gvuIA50GMikZeCVdZFAv+T7cwlGmCATslo9QFfdnaTInKIakJbC8UV/ty20cdP9bJsNzIrvKfRAyf9XfEfrr1Oo4z3jwYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584136; c=relaxed/simple;
	bh=r+qBFI4/69hITdYmR9MdGxoYAPjKxdov9+yfFox7aNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAiRFrWS3k2B7k6YyRJbw8brpXH0ItXF1VoJ4mFNB/Je17o9tC17+nJDBsnrTPyoX2+BCE3Jcqg4AwT73Qwgv92bSg3jgzNf2EQOsH3iRHjfEtSTWEVw8aaNFdtR5rArDnZMAqBgZF1Oyc+lrN8BE6pIghLTGKzcgKZo1Qtt+YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YaP3ZEcD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YaP3ZEcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E222C433F1;
	Mon,  8 Apr 2024 13:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584136;
	bh=r+qBFI4/69hITdYmR9MdGxoYAPjKxdov9+yfFox7aNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YaP3ZEcDYt63+AjrBfBgy5258W58V90lDKZknQ/+32xXtZYkLUmo2DlD0IK7xnhxT
	 yDBy1pZmB6SVxxA+2eA/n8Njk/6sdhlKD1UH8bnUQ5vv4/F7fULLCC/Y33R87cye5N
	 v+zW4dDJ3opXCnbZ5M8nv3VZEhd1V63x/o8xL6IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.8 267/273] bpf: put uprobe links path and task in release callback
Date: Mon,  8 Apr 2024 14:59:02 +0200
Message-ID: <20240408125317.787818005@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

commit e9c856cabefb71d47b2eeb197f72c9c88e9b45b0 upstream.

There is no need to delay putting either path or task to deallocation
step. It can be done right after bpf_uprobe_unregister. Between release
and dealloc, there could be still some running BPF programs, but they
don't access either task or path, only data in link->uprobes, so it is
safe to do.

On the other hand, doing path_put() in dealloc callback makes this
dealloc sleepable because path_put() itself might sleep. Which is
problematic due to the need to call uprobe's dealloc through call_rcu(),
which is what is done in the next bug fix patch. So solve the problem by
releasing these resources early.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20240328052426.3042617-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/bpf_trace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3142,6 +3142,9 @@ static void bpf_uprobe_multi_link_releas
 
 	umulti_link = container_of(link, struct bpf_uprobe_multi_link, link);
 	bpf_uprobe_unregister(&umulti_link->path, umulti_link->uprobes, umulti_link->cnt);
+	if (umulti_link->task)
+		put_task_struct(umulti_link->task);
+	path_put(&umulti_link->path);
 }
 
 static void bpf_uprobe_multi_link_dealloc(struct bpf_link *link)
@@ -3149,9 +3152,6 @@ static void bpf_uprobe_multi_link_deallo
 	struct bpf_uprobe_multi_link *umulti_link;
 
 	umulti_link = container_of(link, struct bpf_uprobe_multi_link, link);
-	if (umulti_link->task)
-		put_task_struct(umulti_link->task);
-	path_put(&umulti_link->path);
 	kvfree(umulti_link->uprobes);
 	kfree(umulti_link);
 }


