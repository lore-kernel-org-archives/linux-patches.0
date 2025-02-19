Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06321DE3AE;
	Wed, 19 Feb 2025 08:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955544; cv=none; b=ZFE7s8SuTRH62hYR8N5nVr+AZ4/gl7IOWX9iOONHXJaAAg6q/z9rEOXaxoT9Hh46EUsFCYf/xJ4Pc2qkaRa0J0wKwY7TQdmOuchajIAWZO1/UR7ta5vJQ1YoAkNhx9SISIxccS4toYXLVLfT3Q51wPX2nhk5+1sKnnrS7VPEt8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955544; c=relaxed/simple;
	bh=8CQnFZwSMdELtx9GyLT49YeJ/K4lYEHL1H80JrLqHqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4tCfnPbbyB1l3Qqt1Rp4GcyTF1kGPmustS5XLt7vRjIBcmGO24tAGjZF3UZG2rjYEh+Tjaz4ql2I9zDoFzqsOmaROt9Aa2GnURiZqwNj9aHbyFL8vDP97HVf/y54FKK/h9uxnZuBYv6edOjtCCWsP3LT1i4amAYgjTylUYki9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkQE0z1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkQE0z1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1160C4CED1;
	Wed, 19 Feb 2025 08:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955544;
	bh=8CQnFZwSMdELtx9GyLT49YeJ/K4lYEHL1H80JrLqHqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkQE0z1zqU5Kc1sA5/dlIURRG2MlSpEZSA23lGQJZDIJrXFf/h6XUNHDVdDggZu3D
	 pI2d/Istncd848qMrQrvU3QlAlwdaRrn+thQft6EVTJeFHbGNvTSCKYhHY7Qk0dWon
	 5eud6KY1rdqNmepg8QVpZaLkn4Qc1PjcGrHTvJDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/152] rtla/timerlat_hist: Abort event processing on second signal
Date: Wed, 19 Feb 2025 09:27:32 +0100
Message-ID: <20250219082551.588362572@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit d6899e560366e10141189697502bc5521940c588 ]

If either SIGINT is received twice, or after a SIGALRM (that is, after
timerlat was supposed to stop), abort processing events currently left
in the tracefs buffer and exit immediately.

This allows the user to exit rtla without waiting for processing all
events, should that take longer than wanted, at the cost of not
processing all samples.

Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Cc: Gabriele Monaco <gmonaco@redhat.com>
Link: https://lore.kernel.org/20250116144931.649593-5-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/timerlat_hist.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/tracing/rtla/src/timerlat_hist.c b/tools/tracing/rtla/src/timerlat_hist.c
index 1525e88c6cf96..a985e57954820 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -952,6 +952,14 @@ static int stop_tracing;
 static struct trace_instance *hist_inst = NULL;
 static void stop_hist(int sig)
 {
+	if (stop_tracing) {
+		/*
+		 * Stop requested twice in a row; abort event processing and
+		 * exit immediately
+		 */
+		tracefs_iterate_stop(hist_inst->inst);
+		return;
+	}
 	stop_tracing = 1;
 	if (hist_inst)
 		trace_instance_stop(hist_inst);
-- 
2.39.5



