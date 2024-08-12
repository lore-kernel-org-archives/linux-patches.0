Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB0F183CD9;
	Mon, 12 Aug 2024 16:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479723; cv=none; b=H2JNLCjUWQ4o9/3Co0qmvFJFGesUtC2sJRIVex1+qpYsJ8jf+NpxGMGmAuGWCl/R/vRpj7qRjaOBJxpQYZiAktQPdKJ7BRaBzAU7DVxvRBvMogbZggn4hr9KWKz/k5gb7haNQIFlQPELlQxsn6jC/Kl3NO5AahJ4LskSbmUI85o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479723; c=relaxed/simple;
	bh=DHfLNkDCE97ItS3hSwz/4Vz8+cNi57K356UuPNOh1qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qw/JnMQTPhvnoO3n/s1zmhMsJSJMlpIg0HW/kpeYKlCHBMFkXsTXTJK8X79RSj+wqTtN8UTZIgFCerCq+tBmjJvdRXTs3k3NPBzGr/ak5cxJzJCZAMDUdKOKu3VKtXqJ3efDpQq8P6BIdPO9RZyq6kxDCTHj+jOLsesGU1vMy9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUYutvYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUYutvYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6CFC32782;
	Mon, 12 Aug 2024 16:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479722;
	bh=DHfLNkDCE97ItS3hSwz/4Vz8+cNi57K356UuPNOh1qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUYutvYACfx07Jluz1Vn7LGlbdj+F4Xc7gYH4DoRm7QbPEh7ui0ixDag1Nnr7NGu+
	 bOz2NFQBZ1/9K9ZMvPNg1p9TtrcQJ4HZcwG08xx9ZughMjCMgRMKR88f47Cr+JlP74
	 9gxh8l5Y20SsqU7I/hiOJLrpP052qcj+6pUlBa1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shi <yang@os.amperecomputing.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Christopher Lameter <cl@linux.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 6.6 173/189] mm: huge_memory: dont force huge page alignment on 32 bit
Date: Mon, 12 Aug 2024 18:03:49 +0200
Message-ID: <20240812160138.804793648@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Shi <yang@os.amperecomputing.com>

commit 4ef9ad19e17676b9ef071309bc62020e2373705d upstream.

commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries") caused two issues [1] [2] reported on 32 bit system or compat
userspace.

It doesn't make too much sense to force huge page alignment on 32 bit
system due to the constrained virtual address space.

[1] https://lore.kernel.org/linux-mm/d0a136a0-4a31-46bc-adf4-2db109a61672@kernel.org/
[2] https://lore.kernel.org/linux-mm/CAJuCfpHXLdQy1a2B6xN2d7quTYwg2OoZseYPZTRpU0eHHKD-sQ@mail.gmail.com/

Link: https://lkml.kernel.org/r/20240118180505.2914778-1-shy828301@gmail.com
Fixes: efa7df3e3bb5 ("mm: align larger anonymous mappings on THP boundaries")
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Reported-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Jiri Slaby <jirislaby@kernel.org>
Tested-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Christopher Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -37,6 +37,7 @@
 #include <linux/page_owner.h>
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
+#include <linux/compat.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -601,6 +602,9 @@ static unsigned long __thp_get_unmapped_
 	loff_t off_align = round_up(off, size);
 	unsigned long len_pad, ret;
 
+	if (IS_ENABLED(CONFIG_32BIT) || in_compat_syscall())
+		return 0;
+
 	if (off_end <= off_align || (off_end - off_align) < size)
 		return 0;
 


