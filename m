Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364F5389104;
	Wed, 30 Sep 2026 17:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787643; cv=none; b=S23nz1oi8526A/C3pqxU3GQtLUvHHTotxSnTk562w7DnuN9OoQfgl8+diSb8hftoYwlZ5xgVB/2Vp5C+NJR6xK6jlxwuYDefNah5cOVm2xL+L7Y8AMHHm09VK4Ga/rWmNFEVa0oyTeZOTprmk4QSS5u6oWHXvk89xFcJZAlQmaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787643; c=relaxed/simple;
	bh=udPPezCPY1W6iGQ8ZYOgyBW2GffkO4ekkbVCs85wwU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArsnD3rt9QZe8MtLzOmfUkEYmWzhdxL5tfNX8D4hZUr6EnYemwJf6aaLgo+Z3ZAYltxts2T/rnvuV4n5MaSi91xdU+Lm9k/KUvJDnm1UPt4QzhgabSPnpEwoH8g7WDce6H+v1lXQHrUow3rO9T7AaDbekycGcI4xH1SSCLXPARA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEKPQ6Mk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEKPQ6Mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C08E1F000FF;
	Wed, 30 Sep 2026 17:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787641;
	bh=orvAHnYv5EB1+Kt8PZD+igoWBZZw1lpK6un/j39UwEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kEKPQ6Mkz7A/a4Il3NXOZmKFR1GYmjStb0AlMvFisDQkWqPx3wd7yurwtbl1LhAS3
	 /TiQmgNFDXFiI+BavHLKIy21ams4rwc3gZiUP3D6VFjFLATrNupsWZOywUx89lhcoS
	 41U7Z6YU4NOdvjfTwHSHuSFQtz8Z1NicQ8NC2zqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH 7.2 257/457] fprobe: Terminate the fgraph_data list when the reservation is not filled
Date: Wed, 30 Sep 2026 17:26:02 +0200
Message-ID: <20260930152351.592725456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

commit 1d653a183973f5283a3db5a38cd5e195eb152244 upstream.

fprobe_fgraph_entry() reserves shadow stack space for every fprobe with
an exit handler, but only fills it for those whose entry handler returns
0. fgraph_reserve_data() does not clear the area, so fprobe_return()
parses the unused tail as headers left over from an earlier call, and an
exit handler can run twice or despite its entry handler asking to skip
it.

Write a zero word after the last entry to terminate the walk. A zeroed
slot does not decode to a NULL fprobe on the arches that encode the
header into one unsigned long, since arch_decode_fprobe_header_fp() ORs
in FPROBE_HEADER_MSB_PATTERN, so make read_fprobe_header() return NULL
for a zeroed slot.

Link: https://lore.kernel.org/all/20260917212407.384468-1-devnexen@gmail.com/

Fixes: e0a384434ae1 ("tracing: fprobe: do not zero out unused fgraph_data")
Cc: stable@vger.kernel.org
Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -171,6 +171,11 @@ static inline bool write_fprobe_header(u
 static inline void read_fprobe_header(unsigned long *stack,
 					struct fprobe **fp, unsigned int *size_words)
 {
+	if (!*stack) {
+		*fp = NULL;
+		*size_words = 0;
+		return;
+	}
 	*fp = arch_decode_fprobe_header_fp(*stack);
 	*size_words = arch_decode_fprobe_header_size(*stack);
 }
@@ -203,6 +208,12 @@ static inline void read_fprobe_header(un
 {
 	struct __fprobe_header *fph = (struct __fprobe_header *)stack;
 
+	if (!*stack) {
+		*fp = NULL;
+		*size_words = 0;
+		return;
+	}
+
 	*fp = fph->fp;
 	*size_words = fph->size_words;
 }
@@ -642,6 +653,10 @@ static int fprobe_fgraph_entry(struct ft
 		}
 	}
 
+	/* Terminate the list, fgraph_reserve_data() does not clear it. */
+	if (used && used < reserved_words)
+		fgraph_data[used] = 0;
+
 	/* If any exit_handler is set, data must be used. */
 	return used != 0;
 }


