Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5151CFECF;
	Wed,  2 Oct 2024 13:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877212; cv=none; b=Lhzk97B9B8cEFLXxvi7SMlukdYjAnkdCu4fFQ60P5LKDgHftjr0jkA+AsXPbne6heWYAZn2Wde8sM+hvdu0nxzK+Cii/OJQ4gD6srBFkXP7Ok4q0WB5ik8DsK+YXbVrn5P0rNU/NDJKInceJTzy+I+K8FSaSSjQuOuy3PneUEdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877212; c=relaxed/simple;
	bh=9RO/g9UQLmAkeH31SKTrh2tTmHuCml8aWQH3Fd/7SB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2xcGpqz3o+Ruq8QUcGiwiaJ2YndSRMuIP7eNHLOwRr3dks679FXk3Io9C0oX4WyrNnbKAfSALmO8Vr75hrduOxXJwo0QtSxIagJk56ez/+ISJ7xDNkBOL1VOHFwIsNevkNEjbPKsJqfKkAjksVhBk285cH66YMpwxE8xreQW9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJEexLLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJEexLLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D972BC4CEC5;
	Wed,  2 Oct 2024 13:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877212;
	bh=9RO/g9UQLmAkeH31SKTrh2tTmHuCml8aWQH3Fd/7SB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJEexLLiPA4RZQDc1L9FGtWnjK1bQnSlPaOI2QcqUSFfgQd7F8SHeo8/EV8u4/Sbn
	 z+ldh5ct/0Je1UyxD9g+XoT3zz4aEphuBTf84bHW4Fa91VTz9q8hnmhcJa0LC2xymf
	 j257z99VjCiryF73S7pqqnsQwijbOO5q3quOJdQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f7a1c2c2711e4a780f19@syzkaller.appspotmail.com,
	Oleg Nesterov <oleg@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 6.11 695/695] bpf: Fix use-after-free in bpf_uprobe_multi_link_attach()
Date: Wed,  2 Oct 2024 15:01:33 +0200
Message-ID: <20241002125850.263806058@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 5fe6e308abaea082c20fbf2aa5df8e14495622cf upstream.

If bpf_link_prime() fails, bpf_uprobe_multi_link_attach() goes to the
error_free label and frees the array of bpf_uprobe's without calling
bpf_uprobe_unregister().

This leaks bpf_uprobe->uprobe and worse, this frees bpf_uprobe->consumer
without removing it from the uprobe->consumers list.

Fixes: 89ae89f53d20 ("bpf: Add multi uprobe link")
Closes: https://lore.kernel.org/all/000000000000382d39061f59f2dd@google.com/
Reported-by: syzbot+f7a1c2c2711e4a780f19@syzkaller.appspotmail.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: syzbot+f7a1c2c2711e4a780f19@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240813152524.GA7292@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/bpf_trace.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3487,17 +3487,20 @@ int bpf_uprobe_multi_link_attach(const u
 					     uprobes[i].ref_ctr_offset,
 					     &uprobes[i].consumer);
 		if (err) {
-			bpf_uprobe_unregister(&path, uprobes, i);
-			goto error_free;
+			link->cnt = i;
+			goto error_unregister;
 		}
 	}
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err)
-		goto error_free;
+		goto error_unregister;
 
 	return bpf_link_settle(&link_primer);
 
+error_unregister:
+	bpf_uprobe_unregister(&path, uprobes, link->cnt);
+
 error_free:
 	kvfree(uprobes);
 	kfree(link);


