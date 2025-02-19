Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7901C7019;
	Wed, 19 Feb 2025 08:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954084; cv=none; b=WcJ0yl0VRwbCBPoiSgTG7HSBj0RDEsog0wrRkN/+70sMPkmDjfl9AAymt1iT4lOXd4IZsCGVMBVTMZ+G7TfXJe3LsDcVM+wCuIxeSGmxaQc4OLD+BDbspen58a1OGeFsXV38vxqff7RTey0jkwCq+k5LXfUKFp3dCpMzGna7UxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954084; c=relaxed/simple;
	bh=FmUD+TNZB+FlCv5LYvF2oN4n6QOj8+5r2YM5lBCzlkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQw1d5FkNxqkZXjsoNbXb123k94wSsejdgXGcqL8uCy7W+zns2s+YZ4peTyeqi1L102Ue5kBlqwrplda5OVxB23W1ed6Y6CoRn74sqCPs3iGVO8JEPfrjpoJczEVqQ2NPvxGsl/wrHG+EhcOV6UWlMEVzbyW1/T3NZrHmsX+huA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtJKyXbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtJKyXbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC68C4CED1;
	Wed, 19 Feb 2025 08:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954084;
	bh=FmUD+TNZB+FlCv5LYvF2oN4n6QOj8+5r2YM5lBCzlkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FtJKyXbTg4D30h3lRn5Wd/svjLOIb2CneSas+1UUA4C/0fFyny6qX/FBJHtj+SqCo
	 SnyJbt8paKran420zdNZxk1eBe79e5nfICMYF1ax8hhr9IJHYWGmFQEERhpt43tSxq
	 K+lBLAvm3mjLfboqxUbB7Y+JeXRdoZ6ggXXeUwAg=
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
Subject: [PATCH 6.13 091/274] rtla/timerlat_top: Abort event processing on second signal
Date: Wed, 19 Feb 2025 09:25:45 +0100
Message-ID: <20250219082613.186866953@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit 80967b354a76b360943af384c10d807d98bea5c4 ]

If either SIGINT is received twice, or after a SIGALRM (that is, after
timerlat was supposed to stop), abort processing events currently left
in the tracefs buffer and exit immediately.

This allows the user to exit rtla without waiting for processing all
events, should that take longer than wanted, at the cost of not
processing all samples.

Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Cc: Gabriele Monaco <gmonaco@redhat.com>
Link: https://lore.kernel.org/20250116144931.649593-6-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/timerlat_top.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/tracing/rtla/src/timerlat_top.c b/tools/tracing/rtla/src/timerlat_top.c
index 139eb58336c36..f387597d3ac22 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -906,6 +906,14 @@ static int stop_tracing;
 static struct trace_instance *top_inst = NULL;
 static void stop_top(int sig)
 {
+	if (stop_tracing) {
+		/*
+		 * Stop requested twice in a row; abort event processing and
+		 * exit immediately
+		 */
+		tracefs_iterate_stop(top_inst->inst);
+		return;
+	}
 	stop_tracing = 1;
 	if (top_inst)
 		trace_instance_stop(top_inst);
-- 
2.39.5



