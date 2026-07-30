Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62D2421EF8;
	Thu, 30 Jul 2026 14:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422933; cv=none; b=OTIFNJAJcICXE6tZI7uFJxtIixvJA3GMALNiJtQ6q9qjLRpQqen0EOFuxGHto688lHfc/G+fCxsimShCKUfedgDRNiLCzcOGUIzsE92OBBg8wGGeK/Ym5+M6PKScXCQvtrLF23fMoeenbNo08OfU0Q5xRRWCqQeHHLGNy3hG/5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422933; c=relaxed/simple;
	bh=smTxcFmYseT60sImRDxI1n/2IoLNkpgJNAxD1jWUOdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwkVFizyTQ+lGQwDEf8svzhRaoKHSDC2/BlGDv8CTTW4yUA2RNEddlKMx4P5ysRPsMBHX4FwwcaLIsf3UD13QuLr152jcuzq1b/3rrq6mFrfht0p99nD14SX8vrybg2fPg6cVxagYyr/QeEJGCsAI83digHtyad+RtkrrioPvmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cc030ocf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cc030ocf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EC91F00A3D;
	Thu, 30 Jul 2026 14:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422932;
	bh=8A0Fwii/mrsePvjgMy3Xb+X1ts7ETEg7vS/G/f4dIsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cc030ocfvqzV2e/YKo+cM9Lw0e9RIZ7LXfQ4g3/gMnd7o1YlFHJw1A1LbLio3Dy2I
	 p1PPDiLKUtkz2qPasK9TSrjvdqyPMlqmv7eJ08inWYw/0CRZ/PDBzWmaTpRPKAuSw0
	 GgCrPMxJSQVS9GFvlgKig7/bNbJPeJHW9xJKuZxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.1 600/744] tracing/probes: Fix potential underflow in LEN_OR_ZERO macro
Date: Thu, 30 Jul 2026 16:14:33 +0200
Message-ID: <20260730141457.030201946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 8ce20bfba48902e1382187cd1a852f7cf3a1e739 upstream.

In __set_print_fmt(), LEN_OR_ZERO is defined as (len ? len - pos : 0).
If len is non-zero but smaller than pos, len - pos evaluates to a negative
integer. When passed as a size argument to snprintf(), this negative value
is cast to a large unsigned size_t, bypassing buffer size limits.

Ensure len > pos before subtracting to avoid integer underflow.

Link: https://lore.kernel.org/all/178454234934.290363.15247317871499514139.stgit@devnote2/

Fixes: 5bf652aaf46c ("tracing/probes: Integrate duplicate set_print_fmt()")
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -2018,7 +2018,7 @@ int traceprobe_update_arg(struct probe_a
 }
 
 /* When len=0, we just calculate the needed length */
-#define LEN_OR_ZERO (len ? len - pos : 0)
+#define LEN_OR_ZERO (len > pos ? len - pos : 0)
 static int __set_print_fmt(struct trace_probe *tp, char *buf, int len,
 			   enum probe_print_type ptype)
 {


