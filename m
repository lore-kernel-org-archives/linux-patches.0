Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFD71A3BD0;
	Thu, 15 Aug 2024 13:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728908; cv=none; b=e0Wja5s29dkaJTziXMnCqBX/uj9pbjZfGnHMDPS7XUaUMpVShikQWo+NLssyo/im4iRsU/SF3dTeKDn/gIhAVlfUqDV4KMh6bfSqxrrIgm81/uURZJFjlhl8kVhP63AGO3TwyIHXyy/TZ/0BDNSYShX67RDXms1Ov+sS9JlPank=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728908; c=relaxed/simple;
	bh=G1wGaZa8N8LQtzDpo4h/DJitPf9RCOZLXkeldYN3XTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwXEan3zIO93GD+oy0B/0mVHYgV1fcP6Qt65disBMZ1U7RjnIvWBvR6+0vtfwQ4gpuxSd46tGCGQ5bBGFn5crSG4MlckKEEa+s/YfRrPh3katQfdI3IwJXEAXGWhJtPN/vYEJ3mTh86dZSXm81klZfd5hExR4cFI1r+nAwZZAJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GD/JNLJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GD/JNLJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8A5C32786;
	Thu, 15 Aug 2024 13:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728907;
	bh=G1wGaZa8N8LQtzDpo4h/DJitPf9RCOZLXkeldYN3XTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GD/JNLJWkan1RV92/oxaC/JSWP+8rPL4tUvcnpgeu7bC+AWW1aeWQRPB0HKwwUBVJ
	 XHNIySGuekLctZ/deK9VnQsc4BGfbVBMHl5BLwKj6a5q+UIJswUiKVKiCNlFdMp/4f
	 uQTqMcSXMKXtx/IKeZJtDN+dsK5yR3ouDpD2dmn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Peter Zijlstra <peterz@infradead.org>,
	Stephane Eranian <eranian@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vince Weaver <vincent.weaver@maine.edu>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 117/196] perf/x86/intel/pt: Use pointer arithmetics instead in ToPA entry calculation
Date: Thu, 15 Aug 2024 15:23:54 +0200
Message-ID: <20240815131856.553452313@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

[ Upstream commit 539f7c26b41d4ed7d88dd9756de3966ae7ca07b4 ]

Currently, pt_buffer_reset_offsets() calculates the current ToPA entry by
casting pointers to addresses and performing ungainly subtractions and
divisions instead of a simpler pointer arithmetic, which would be perfectly
applicable in that case. Fix that.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: http://lkml.kernel.org/r/20190821124727.73310-4-alexander.shishkin@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Stable-dep-of: ad97196379d0 ("perf/x86/intel/pt: Fix a topa_entry base address calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/pt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index b8a2408383d0c..5dff4548b0875 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1031,8 +1031,7 @@ static void pt_buffer_reset_offsets(struct pt_buffer *buf, unsigned long head)
 	pg = pt_topa_next_entry(buf, pg);
 
 	buf->cur = (struct topa *)((unsigned long)buf->topa_index[pg] & PAGE_MASK);
-	buf->cur_idx = ((unsigned long)buf->topa_index[pg] -
-			(unsigned long)buf->cur) / sizeof(struct topa_entry);
+	buf->cur_idx = buf->topa_index[pg] - TOPA_ENTRY(buf->cur, 0);
 	buf->output_off = head & (pt_buffer_region_size(buf) - 1);
 
 	local64_set(&buf->head, head);
-- 
2.43.0



