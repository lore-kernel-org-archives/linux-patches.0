Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889B03D6D;
	Mon, 23 Dec 2024 16:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970102; cv=none; b=pzOULU8CHIThL2fhdiaqRC35pA5GpzKlCtMSOIz9Ljg+GScwhnLLSKPCW1QU9BplwG5PQG32XAwe9o1mrGgsnLceNGZUTWAAn9H1aK2FX4pPTQojRf9pcAhQ/gdrqPeEe98jT1aBr1KPoxajsYIY/tLSnCJXFzMGxshsPVEmg5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970102; c=relaxed/simple;
	bh=mWNBrBxMau4yJYJn1aYcb7rnzUOiaCe6s984NcT98mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kn7uFUw7wpLSmOVfnmj4XcwFOXua62zvgAAYZIsZXQwfunISDAV9vN8Z3PWdxM/FmvUX6yA//99EYIyN4jdk42s19EJEdsXyQzj52g0w5FyzikuZkFBzNJfEa55AeCy/WVb28Q4M6wpEqdRg8BY2TDXvlaCT3AmXRTN+LZ/lWb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPQf9R+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPQf9R+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA24C4CED3;
	Mon, 23 Dec 2024 16:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970102;
	bh=mWNBrBxMau4yJYJn1aYcb7rnzUOiaCe6s984NcT98mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPQf9R+4fBrCC7pj0i7zC5/8N4zKqPNCONXy1gkLaYNdB5JuN3RCc/VcRYkwHlMcF
	 YzE6+wQpBlpkPSsWxBdpUrMugk0CslUJ2GZ8fnUew9ZIX8l8jXZZa2KZKNb/uphMrv
	 ZGcGz7JCjpdpqRw1JTCfiBYQIuDJxHPRXMCve3cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	David Wang <00107082@163.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Sourav Panda <souravpanda@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 114/160] alloc_tag: fix set_codetag_empty() when !CONFIG_MEM_ALLOC_PROFILING_DEBUG
Date: Mon, 23 Dec 2024 16:58:45 +0100
Message-ID: <20241223155413.077325971@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suren Baghdasaryan <surenb@google.com>

commit 60da7445a142bd15e67f3cda915497781c3f781f upstream.

It was recently noticed that set_codetag_empty() might be used not only to
mark NULL alloctag references as empty to avoid warnings but also to reset
valid tags (in clear_page_tag_ref()).  Since set_codetag_empty() is
defined as NOOP for CONFIG_MEM_ALLOC_PROFILING_DEBUG=n, such use of
set_codetag_empty() leads to subtle bugs.  Fix set_codetag_empty() for
CONFIG_MEM_ALLOC_PROFILING_DEBUG=n to reset the tag reference.

Link: https://lkml.kernel.org/r/20241130001423.1114965-2-surenb@google.com
Fixes: a8fc28dad6d5 ("alloc_tag: introduce clear_page_tag_ref() helper function")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: David Wang <00107082@163.com>
Closes: https://lore.kernel.org/lkml/20241124074318.399027-1-00107082@163.com/
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/alloc_tag.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -48,7 +48,12 @@ static inline void set_codetag_empty(uni
 #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 
 static inline bool is_codetag_empty(union codetag_ref *ref) { return false; }
-static inline void set_codetag_empty(union codetag_ref *ref) {}
+
+static inline void set_codetag_empty(union codetag_ref *ref)
+{
+	if (ref)
+		ref->ct = NULL;
+}
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 


