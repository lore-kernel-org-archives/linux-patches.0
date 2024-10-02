Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A151D1728;
	Wed,  2 Oct 2024 14:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879089; cv=none; b=YPom9s9URh8WpUQkguG0HluYViVDFtMIE1mg8kRUm9LgWA7KgZV5sTtb4saZudrxcI32cuO1941rpSapMPE4U8Myf2/b2otNPJxC7VUhQI85sRHkQq/mmAOU4IIyT4lBXo1qnz0E2XJ4w05ILfMfCVWwVJTcFEZLRQGIEKCEU4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879089; c=relaxed/simple;
	bh=dEyvKHbR5V+nG1g3oybRYcCTqbEw6JkHwe9hRFm0bo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1n46r5HcbxZfxPNMP+3daZy7zh9B0OXiBRdQebJcZkCjvtyYdkA0bErO2i0qfMyitcHk5/UqYs/pwAfCb6a1w8LTgZkMV+dSlfc8OKzlK4TsbOrRbq8B2kD04gwu28y1O6d+UMLr+DDdIsFWB1/s+qKj1ElyHr3j99r9oLtUMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4V5+Mzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4V5+Mzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82312C4CEC2;
	Wed,  2 Oct 2024 14:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879089;
	bh=dEyvKHbR5V+nG1g3oybRYcCTqbEw6JkHwe9hRFm0bo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4V5+Mzp/BqbR8dO0O4k91AP1Qoby/8cYdN7AsPNDHvKXG05Sf4r4iiGnoR9IqG0e
	 F2sPvflksnTXGCE2c2Vj+oUrekp53PDYXv+uYdJK2q06CpS6LjL4DgnuU8GCe06Voi
	 h0VZz0gzEC5YkEa0eh5vxzmnok/CCd/1R5X9oWqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f7a1c2c2711e4a780f19@syzkaller.appspotmail.com,
	Oleg Nesterov <oleg@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 6.10 634/634] bpf: Fix use-after-free in bpf_uprobe_multi_link_attach()
Date: Wed,  2 Oct 2024 15:02:14 +0200
Message-ID: <20241002125836.151680672@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3484,17 +3484,20 @@ int bpf_uprobe_multi_link_attach(const u
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


