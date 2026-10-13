Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2984F7CCA;
	Tue, 13 Oct 2026 12:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894316; cv=none; b=OtRppotE2pPq38uI10BPalUJtAivl7WAEqAQnKercexDhjDR957ZCWLa5/7nj3Cnk2iD8EOZr0SdFAMg/IF3HJl2IH1LSkUNyai88yV/b78DrT74dvvdlO53c5a3K2ZmRCXCuiCzvBMctZhiOjC80gxMVKQ16xUvZmUZgRrLi4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894316; c=relaxed/simple;
	bh=L9p0gEkSCUI0v81lx/cL3+zs/eihxOPu7g5BWIA8DhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqTbn8k1xjBHz6HZUa2lVMaE+T64c/AC7VHxywl9dWUJQ3exrEak1tLQDBvIGRF2SmPQAD72Ulbjzcx2wE6JhOVJ3WfmK6YUA3cyTXrTSAPnobLaVA+SFD1XRusDziG61KA3c4qXsN9KPaaX4g00tpOAcCuqCLdLczEv+mgQASo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEOg2kDv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEOg2kDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365921F000FF;
	Tue, 13 Oct 2026 12:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894314;
	bh=g1EwsYlawYRmNZ/dMQ/XGB1Ruey4+3OPeYHEASwbK4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qEOg2kDvA5f64nkKKj9fYADeRIInXJQmktNsiiEFtQ8vH+MbtU2QtzxeIHLWpH2Va
	 GP+BeYkV/7VqzhplRMETUBQ4bzB7plYgHDWWNK80xvsIQs4RYeoqHRza6AiPxt/eS4
	 Gb2jQ5uGJHZq/vLJkO9QdTI52aSuNaVOK3sCo40A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 518/621] ring-buffer: Add checking nr_subbufs to persistent ring buffer validation
Date: Tue, 13 Oct 2026 13:38:33 +0200
Message-ID: <20261013112933.116376153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 6c001a62c34f13fe1c6a24304c289b387d9e697d ]

Sashiko reported that the code was using meta->nr_subbufs without making
sure that it matched the nr_pages + 1 on data that was assuming the two
were the same.

Add a check to the persistent ring buffer validation code to make sure
that the saved nr_subbufs matches what we expect.

Link: https://patch.msgid.link/20260903132728.7fb27d34@gandalf.local.home
Fixes: f5b95f1fa2ef3 ("ring-buffer: Validate the persistent meta data subbuf array")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260901164836.D962D1F000E9@smtp.kernel.org/
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index eed5c45b86ae6..c6d3730eb6f3a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1854,6 +1854,11 @@ static bool rb_cpu_meta_valid(struct ring_buffer_cpu_meta *meta, int cpu,
 		return false;
 	}
 
+	if (meta->nr_subbufs != nr_pages + 1) {
+		pr_info("Ring buffer boot meta [%d] invalid nr_subbufs\n", cpu);
+		return false;
+	}
+
 	buffers_start = meta->first_buffer;
 	buffers_end = meta->first_buffer + (subbuf_size * meta->nr_subbufs);
 
-- 
2.53.0



