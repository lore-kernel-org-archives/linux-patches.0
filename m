Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9BA4F7971;
	Tue, 21 Jul 2026 17:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656277; cv=none; b=VKBW/A1CE9TmINXtwrfY4Cd0hQRLx1s5BqW5KoztAq6eUdA/52QVzt2sH99xXKia898EHM+wunhb1Ni3HDLVEN3oKp/MzXOzXElDP5coeXfP5FR5KUus4h60sHzPVUQC3pPfJCntCtD0i5IwmouhavCg3cW7VE4mqZ6fRm1FoqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656277; c=relaxed/simple;
	bh=m0QnFr/tAEjPifvopfEYb8AnKowitBPDun9sRzaK4lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDfCd8QXEffamx26Wb7HX9PzpB757vkoGeUb+4s3usoLCmaSUcKEkHAwi1HBuz/1vmlNjq9TJFmpMf1v0zmz9iH1Jy88Wb6At457wmvIl1aGBj0Wbzg4ss6HIgc5t8QKcH0WNc0n7geEnsUpo9QUpH2znC4pNgPGKco7L1yp/9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIai+4G7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIai+4G7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2271F000E9;
	Tue, 21 Jul 2026 17:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656276;
	bh=nflj2bOt0H6wXM/xIzX0lkzdw4HKVNHgGqychZGVufs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wIai+4G7a0TgmlvH+nd+ABXST/lvyzBmpVureKq9CwojYjg/dsaWRcqKgOqebu3sZ
	 EHfJftwAHeAgL2u/b6XZdMDgNNYcpFUR9nt42Lp93Txbh4I7IILF1T2rKv95yiSQd9
	 dD+IZc42Vu3EoTkycQb36bCIGcvlvvQDMV68j6N0=
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
Subject: [PATCH 6.18 0324/1611] bpftool: Use libbpf error code for flow dissector query
Date: Tue, 21 Jul 2026 17:07:20 +0200
Message-ID: <20260721152522.377638516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 1a06b0b5eef350..f669716a588b4a 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -603,14 +603,14 @@ static int query_flow_dissector(struct bpf_attach_info *attach_info)
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



