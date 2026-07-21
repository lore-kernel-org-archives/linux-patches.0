Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B9E224B05;
	Tue, 21 Jul 2026 22:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673968; cv=none; b=pb7guEKsggShi9laZjUopJjh2sjy1TiDGRMim29e5kOIB0LJ3RU1YMh04oKP2CfyWptYWkoBFXp1IAQt19znWLlMd/vKvYl2ySNlvapcW6qQL6y7a8Fu/GSaLyFyXlCYyoech537xlRgV1EXTyST4yZnj2PFPQtJuIUVlZQpW5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673968; c=relaxed/simple;
	bh=KDGtqshRR9RAfh7GpkrVzwOGlCb51iO+OCClxgQvG54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDWChck756oNkb9HdqoyfKxUTDlNSAoxVNkkDDq9ajNEn70MTOlr04YE/ucwuyjt3QMjwo0ygXibHyU3NVTe+qj7P/294bnU8kBNNKQePEVmY3E4A8SZ6WFToAfJSyXcS29ccYvvjz1Ky+dWATx/Xk5RgFRb2rLI8mHQnDjQV7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EIPUvUEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIPUvUEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9CE1F000E9;
	Tue, 21 Jul 2026 22:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673967;
	bh=kTRShvg0qNLDiB4GB0kbVww/oph6Z9dcXTRUTLh8l3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EIPUvUEreX5r3AX+Of4i2lOllt5yN540eOpLIvo4PnlHjSMkElYUQdvOCHLAhEelY
	 qK3zod1CN6uAvW2RF99otwYDsZsqURB7t26VI1QrrIu0GV0nJ8CeAbEKz1kLHt/J/6
	 zp9I/Ao3VC44axLibBM6NF5TVNjlrL2eDtywDhUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 320/699] perf bpf: Add NULL check for btf__type_by_id() in synthesize_bpf_prog_name()
Date: Tue, 21 Jul 2026 17:21:19 +0200
Message-ID: <20260721152402.911686126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 903b0526dcf86d030c5970b4b0a67f9c227368e2 ]

synthesize_bpf_prog_name() calls btf__type_by_id() and immediately
dereferences the result via t->name_off without checking for NULL.
btf__type_by_id() returns NULL when the type_id is invalid or out
of range.  When processing perf.data files, finfo->type_id comes from
untrusted input, so an invalid ID causes a NULL pointer dereference.

Fix by checking t for NULL before dereferencing.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: fc462ac75b36daaa ("perf bpf: Extract logic to create program names from perf_event__synthesize_one_bpf_prog()")
Cc: Song Liu <songliubraving@fb.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index 67295ca1d14b86..386afcefbc30dd 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -136,7 +136,8 @@ static int synthesize_bpf_prog_name(char *buf, int size,
 	if (btf) {
 		finfo = func_infos + sub_id * info->func_info_rec_size;
 		t = btf__type_by_id(btf, finfo->type_id);
-		short_name = btf__name_by_offset(btf, t->name_off);
+		if (t)
+			short_name = btf__name_by_offset(btf, t->name_off);
 	} else if (sub_id == 0 && sub_prog_cnt == 1) {
 		/* no subprog */
 		if (info->name[0])
-- 
2.53.0



