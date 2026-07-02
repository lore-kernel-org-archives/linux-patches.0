Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4AE331EB6;
	Thu,  2 Jul 2026 16:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010746; cv=none; b=r91+kNIKRWwnt5ML1xjNegMuYBJ0GSo68ILLw8REvg9UIoAXK0uheoTQTlbo1fiFFfOxATYyiuT8Yt5te1up5CqE4IGM3sP3hR4mF/LfJc/UKrPyxxgftzqz3xxFpPSihKamVvKzFVT++OJZGXSZpolSIhC4iKGHh8xZgeMAQ0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010746; c=relaxed/simple;
	bh=rxr6G4iqn4YfnsvQ2MhCHHmbO8lUEYTLKRhlUMD5Rvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fsa1YJ9p5yS+pYfEi6BFLN0cOdMrNSscB6FGDmjJv68B+l+wLrN9HFmpCy4Vgfm+HnWD981UUnSZZS/zJLjPLuvEBRS8uFlppApJrxcAnnB0xghGuKPFCXklbPenNqFMJwD/rMe6xGOnmis3+841vjqK9U4X3gADurpoBN8P3Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTNlC7Y2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTNlC7Y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C691F00A3A;
	Thu,  2 Jul 2026 16:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010745;
	bh=00hV5jUuBWj9WN5ZHGDc6Dg7KQoKyMtOFDFUDxMCe/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTNlC7Y2aD+FxLt+gIZ+3q2BJoTVs2k6bRJoC/DOP73zjw6pEvlco7cKQA/bH1DwA
	 Jw9S2JTuLUm8Q2girRqxdr4GceD+4nQL+YFcEmvck4VXfD77oiTERMSatcHv9mdji0
	 Yv4TzzmhiHypV2oV7GwNUIURJa3T/TgLIKG/9mzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varun R Mallya <varunrmallya@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/175] bpf: Reject sleepable kprobe_multi programs at attach time
Date: Thu,  2 Jul 2026 18:18:42 +0200
Message-ID: <20260702155116.234259801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Varun R Mallya <varunrmallya@gmail.com>

commit eb7024bfcc5f68ed11ed9dd4891a3073c15f04a8 upstream.

kprobe.multi programs run in atomic/RCU context and cannot sleep.
However, bpf_kprobe_multi_link_attach() did not validate whether the
program being attached had the sleepable flag set, allowing sleepable
helpers such as bpf_copy_from_user() to be invoked from a non-sleepable
context.

This causes a "sleeping function called from invalid context" splat:

  BUG: sleeping function called from invalid context at ./include/linux/uaccess.h:169
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1787, name: sudo
  preempt_count: 1, expected: 0
  RCU nest depth: 2, expected: 0

Fix this by rejecting sleepable programs early in
bpf_kprobe_multi_link_attach(), before any further processing.

Fixes: 0dcac2725406 ("bpf: Add multi kprobe link")
Signed-off-by: Varun R Mallya <varunrmallya@gmail.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20260401191126.440683-1-varunrmallya@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[shung-hsi.yu: sleepable flag was in 'struct bpf_prog_aux' before commit
66c8473135c6 "bpf: move sleepable flag from bpf_prog_aux to bpf_prog"]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index a896b80252ae11..87e7cc2dc5ccd8 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2905,6 +2905,10 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (prog->expected_attach_type != BPF_TRACE_KPROBE_MULTI)
 		return -EINVAL;
 
+	/* kprobe_multi is not allowed to be sleepable. */
+	if (prog->aux->sleepable)
+		return -EINVAL;
+
 	flags = attr->link_create.kprobe_multi.flags;
 	if (flags & ~BPF_F_KPROBE_MULTI_RETURN)
 		return -EINVAL;
-- 
2.53.0



