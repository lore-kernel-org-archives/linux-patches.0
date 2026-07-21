Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F08C367B92;
	Tue, 21 Jul 2026 22:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673718; cv=none; b=i59kH1EkvD+ecRi+57Lu1/Jn/aoiVnLQaSE97rBEWiRMClYuxiPyGTuKh0yNv3Cii4Ta4NyeF+S9BqbJutpwnG/TmHbsrtQ9KwAm1yib8B/0BYu+6cCm1kWIFeTeTVQi8YC2QAt8MuVI2d+q6oJjhLImYqATHuMzKPDX9GkPtDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673718; c=relaxed/simple;
	bh=dLaLUAvyFMcRuP67LyN/jTPYlkUUoHB2SnU36QHkTDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcdgtTI71yPn4NXIu58rRt4jYOcxMUZQ/EMRnmBI7Yt1wK5IDI0R60nRIrD9AUDq13elbj0vwtqGi/vJkIR+XXNyvQBtu900BG+bkQVReLoePPEXZkAGLnX64hN0fMxo6QomTb38pMuPjWiwA0SRDL5HZw/WugAGu+RhczgkCKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cod005dv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cod005dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9410C1F000E9;
	Tue, 21 Jul 2026 22:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673717;
	bh=lUcsKZHG3ArgmprEHIzXEV8qMD88u21BgKdzCI2Nt2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cod005dvTzY/+1MhDQzSozVqO4IafdZPpY5wmIqhIU5Mx2mk1SAlHxBulGQWEjYXB
	 ZLLDU0gpMe/aPpyjb8zihZv0O/BHBoINtDyFcNJmKDkaoHa6wEkjhsm0rN8mvG7dh2
	 3gAOnJeAix/RYkg+pdHL3NHOJOz74b9ha7sHuqjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Woojin Ji <random6.xyz@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Leon Hwang <leon.hwang@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/699] bpftool: Use libbpf error code for flow dissector query
Date: Tue, 21 Jul 2026 17:19:44 +0200
Message-ID: <20260721152400.776212369@linuxfoundation.org>
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

From: Woojin Ji <random6.xyz@gmail.com>

[ Upstream commit 8a7f2bff2165e53595d1e91c160b340f978c0ab7 ]

bpf_prog_query() returns a negative errno on failure.
query_flow_dissector() currently closes the namespace fd and then reads
errno to decide whether -EINVAL means that the running kernel does not
support flow dissector queries.

That errno check controls behavior, not just diagnostics: -EINVAL is
handled as a non-fatal old-kernel case, while any other error makes bpftool
net fail.

The namespace fd is opened read-only, so close() is not expected to
commonly fail in normal use. Still, the BPF_PROG_QUERY error is already
available in err, and reading errno after an intervening close() is
fragile. If close() does change errno, the compatibility branch may be
based on close()'s error instead of the BPF_PROG_QUERY result.

This was reproduced with an LD_PRELOAD fault injector that forced
BPF_PROG_QUERY for BPF_FLOW_DISSECTOR to fail with EINVAL and then
forced close() on the netns fd to fail with EIO. The unpatched bpftool
reported "can't query prog: Input/output error". With this change, the
same injected failure is handled as the intended non-fatal EINVAL
compatibility case.

Use the libbpf-returned error code instead. Keep the existing errno reset
in the non-fatal path to preserve batch mode behavior. The success path
is unchanged.

Fixes: 7f0c57fec80f ("bpftool: show flow_dissector attachment status")
Signed-off-by: Woojin Ji <random6.xyz@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20260603003339.33791-1-random6.xyz@gmail.com

Assisted-by: ChatGPT:gpt-5.5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 7f0421713e1cda..211eeead78bd1c 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -503,14 +503,14 @@ static int query_flow_dissector(struct bpf_attach_info *attach_info)
 			     &attach_flags, prog_ids, &prog_cnt);
 	close(fd);
 	if (err) {
-		if (errno == EINVAL) {
+		if (err == -EINVAL) {
 			/* Older kernel's don't support querying
 			 * flow dissector programs.
 			 */
 			errno = 0;
 			return 0;
 		}
-		p_err("can't query prog: %s", strerror(errno));
+		p_err("can't query prog: %s", strerror(-err));
 		return -1;
 	}
 
-- 
2.53.0



