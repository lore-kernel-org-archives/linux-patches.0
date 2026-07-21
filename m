Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B9E40926A;
	Tue, 21 Jul 2026 19:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663150; cv=none; b=BcC2l//Ghg1ht4Ns9IRiNpJwlm/pNa5vNpw27mCO9Q5fJ/phCPRqj1plxZH+hU8S7+WkdeybaTf4Q7+z0nztT+Wvf64GVt8vUye3tzlYGPdQQbYWKEkXyYK1iYICnf2RPiRhRtNxLGQxeIOiaS/c3VvFUAkG3fLgGQH1sz/bDvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663150; c=relaxed/simple;
	bh=hvOlM0yuctITcERkhvjnnaqySxd73jgkgtLF3re20KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUIq3K8GrtSvum4uYZyL0onAVVhTyGTCJIoxdw0LopBHncqnvFPLQlat7R8NVshHdfdtpvXJbweCsprvEscE9hfqzR2zdPECXf29htvLGPbYQVrpJAyoWaKx/nqQeJQ9lK37e01HMGqzmPOpPdxM1EVYuOshsH/wIQWuatBbFl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dL7EqFSc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dL7EqFSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EA51F000E9;
	Tue, 21 Jul 2026 19:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663149;
	bh=7UPLV4f0GikQIthS7PIgbnLLMg+xhZfozbWUg7OOzDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dL7EqFScqprIqG96AJ55LA74VWVseubObTQvcqqDZm8SMRzHR0ZypueP9ldiRTsoq
	 c0J8zeQBzWMqV31nYNV4sIcWN/zidHTs3Pm129naoszVtwpnOsdfuf5QoTZheH5K+1
	 InfgfTX3Cz9OX7H4ZtiOgpSawhCFIaKnu+f2l16o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0714/1276] tracing/events: Fix to check the simple_tsk_fn creation
Date: Tue, 21 Jul 2026 17:19:17 +0200
Message-ID: <20260721152502.072591965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit cda1fbfc5313bb90daa271d45eea4a8d317a8544 ]

Sashiko pointed that this sample code does not correctly handle the
failure of thread creation because kthread_run() can return -errno.

Check the simple_tsk_fn is correctly initialized (created) or not.

Link: https://lore.kernel.org/all/178165817322.269421.3992299509400184196.stgit@devnote2/

Link: https://sashiko.dev/#/patchset/178092865666.163648.10457567771536160909.stgit%40devnote2

Fixes: 9cfe06f8cd5c ("tracing/events: add trace-events-sample")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/trace_events/trace-events-sample.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/samples/trace_events/trace-events-sample.c b/samples/trace_events/trace-events-sample.c
index ecc7db237f2eff..0b7a6efdb247a8 100644
--- a/samples/trace_events/trace-events-sample.c
+++ b/samples/trace_events/trace-events-sample.c
@@ -107,6 +107,10 @@ int foo_bar_reg(void)
 	 * for consistency sake, we still take the thread_mutex.
 	 */
 	simple_tsk_fn = kthread_run(simple_thread_fn, NULL, "event-sample-fn");
+	if (IS_ERR_OR_NULL(simple_tsk_fn)) {
+		pr_err("Failed to create simple_thread_fn\n");
+		simple_tsk_fn = NULL;
+	}
  out:
 	mutex_unlock(&thread_mutex);
 	return 0;
-- 
2.53.0



