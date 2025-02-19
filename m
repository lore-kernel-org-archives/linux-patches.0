Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23AE1CAA93;
	Wed, 19 Feb 2025 09:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957407; cv=none; b=I+7ON/OiBdpwXK8aJNs0qIg5YwdoRPl9mYKWLC8DWqMZzKEhCrViKwNRbZbXR9xLPAuY/dGUplWTxkOdhPYM28Htw4DK0AhuIoEv34PtFfO3TMiKvlA+eC0jMyXmgSDXAbHHD3h/BVj+znxjBZ046BwIFcjhevNL5pwyCAz/9tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957407; c=relaxed/simple;
	bh=8/pYyoP1XpZoJAV/9/mpPKOTrLaHHE01X+f0khalOAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2egetdBZzD0HAfUYiF9Un4S3h7l9JeAY7esrPrRTGH1FBIbbM0IkRQbh1JQWOUW2EzVzRekFDnepigSuu9ObckzQevgvI/RgVOMLc8HQ+7HkHgIt9cNmN+0GFgD5HwWxwpmYwJPpiPxLdiMjbjgknP24duLSTN/gOR9GqKeQRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJqKGFXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJqKGFXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B360C4CED1;
	Wed, 19 Feb 2025 09:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957407;
	bh=8/pYyoP1XpZoJAV/9/mpPKOTrLaHHE01X+f0khalOAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJqKGFXqC4oU118rbOgBdSdcvbMKtPLE6792lU7bSvUcn/w2DEmu5sJnh9MpJvlI4
	 I69HCqrLAWviQILWTNVGeexUmckgZ1zWJ3RZo0JAA+plStTw/7YrC6twcX+yrW/Awm
	 RfvQ7KWULTq2IvBJaTHMiyffUku71KmJg4XtdWME=
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
Subject: [PATCH 6.1 488/578] rtla/timerlat_hist: Abort event processing on second signal
Date: Wed, 19 Feb 2025 09:28:12 +0100
Message-ID: <20250219082712.196422660@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 83cc7ef3d36b3..b7a7dcd68b570 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -786,6 +786,14 @@ static int stop_tracing;
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



