Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60529248F64;
	Fri,  4 Sep 2026 05:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501219; cv=none; b=qqdjyXjz5X3khKDF5C3qZKc+eGXKuBEtxMnLDsxhjhulkjMn205dxHsd+s+0Xj5/oBAi88YfW4jl4GqJefQCZQMPImpAf0vq6Zf39g2HFhW4Coqm+mcElO50A/wfXJnJlTTu7qlI8Ui9Sc+ObF5SYILJYWZnwpHIvG3gGvbyH9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501219; c=relaxed/simple;
	bh=z//cgCEPpqf+kbcC9IDFC4dnV5zEcRQxzdeDuauNtns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPLZqWloZBXkPj0wa1CSCkFgwUW929ggp3HMgGZ7j9IO8Yvq3DNW/eNxK6TKakMoXcV4LhoxER3o1nqVp3ohClRp1IxOmK+8I37FMzjsE9omXZSAGiRGyYanUN/YOKQO+wr7C/YcsVmd/NQzTQTbjv4EALoGQl6tM0FLxuAjNrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRdnlCKg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRdnlCKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752961F00A3D;
	Fri,  4 Sep 2026 05:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501218;
	bh=4HgFrcK+b3dL1W+9hgDPlpRgKEizrksR8q/yg2vAcFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SRdnlCKggBC2z4TYd0ns1m84a6NW6weljxS0Gw0HgNVFQvb9+Umk1fNL1dVt/u7DQ
	 6ItflL5elvXJU11SE+V9LiLhq44W3h+WpRwwOkVhzAY+fVfL/J5hDQE2lEIB6dx56B
	 YZfbWjQUWqE6Q3zpTUyAEXu8EIiYJGnKwSFUE+18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 331/552] ring-buffer: Hold cpu_buffer::lock when resizing a subbuf
Date: Fri,  4 Sep 2026 06:58:08 +0200
Message-ID: <20260904045757.768998243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

commit 24974bd0da1b47fd56c975533ead50abf754e74d upstream.

Because, ring_buffer_subbuf_order_set() can clear cpu_buffer->free_page,
hold cpu_buffer->lock to prevent races with
ring_buffer_alloc_read_page() and ring_buffer_free_read_page().

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260813131152.3589632-3-vdonnefort@google.com
Fixes: 8e7b58c27b3c ("ring-buffer: Just update the subbuffers when changing their allocation order")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260810125633.3344684-1-vdonnefort%40google.com # patch 3
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6973,8 +6973,10 @@ int ring_buffer_subbuf_order_set(struct
 		cpu_buffer->nr_pages = cpu_buffer->nr_pages_to_update;
 		cpu_buffer->nr_pages_to_update = 0;
 
+		arch_spin_lock(&cpu_buffer->lock);
 		old_free_data_page = cpu_buffer->free_page;
 		cpu_buffer->free_page = NULL;
+		arch_spin_unlock(&cpu_buffer->lock);
 
 		rb_head_page_activate(cpu_buffer);
 


