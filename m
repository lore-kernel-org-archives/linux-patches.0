Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3516546EF96;
	Tue, 21 Jul 2026 19:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660547; cv=none; b=MWvI2eQsmmgcGq9zjRWjMojI0hcJ1MerSZkwK7Kt+gYDfeXBS4QWA1ZM1ukepqZawtH1G+2XPL658di2Hfhq+RK2q+vE8ZL1LD5nrpWd/YFKyVUak/2oYXE1AVgM048UmfMnV+uKpU9sYR0vDx1WLKAz+gW5ZbEoUGLYRt76UJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660547; c=relaxed/simple;
	bh=3KDZzxow/ZareIAHsJU3pQ052F7JfRPnnNVNZNXwgAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+xcviwVDZGgomiLI3rGPCUlgwPSJFffiHDk5FoMxKsq9aMEtSYdvpTCF3ao+/320I461AEtJQVmXWKjJv2kMG7fFc+aPeTU6LtdH8WvKpkEE0vpoDQaqrIKwg2WhMD3FDjYaUL2gnvE4cXtTFHChP+6Y8+PMWmtV/DKUPXu84w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+9WSJOv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+9WSJOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F001F000E9;
	Tue, 21 Jul 2026 19:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660544;
	bh=IxjdcsJhxvNxtfgevcT3mat7qfwmIMs5mI+NxLUbMSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e+9WSJOvm9/wTiO9rmAN/8kjFjiRlH1HkJceQPQjdQK+IOm0ejyOGo1J89xzLEq84
	 7IomHC7c/XmEm0ddkiGfJweZ19e6vurGmHVEEO/MwfQs7/pUBiVT7bU3XbkxoHKjWi
	 CKQ3d5GrkHZGyRKwsXreoA4+pZeXHf6DKEkZg/SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1021/2077] perf bpf: Add NULL check for btf__type_by_id() in synthesize_bpf_prog_name()
Date: Tue, 21 Jul 2026 17:11:34 +0200
Message-ID: <20260721152616.903964754@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2c09842469f1f2..fe01551dc3e6cc 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -146,7 +146,8 @@ static int synthesize_bpf_prog_name(char *buf, int size,
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



