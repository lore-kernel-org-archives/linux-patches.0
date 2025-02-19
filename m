Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E87A1DF271;
	Wed, 19 Feb 2025 08:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955547; cv=none; b=rsr/a6Eq2W59Al33Bj1Mo9MtBWq/Qnj7qzrMAoen3/azOz+tZRgzolLCouXfpMawG5nOK3JE7bxCp98tK2ICQQZ22x8L7RsfMMjwS4N9yzmDqp+TuyXyh/e8DMSif9R/oJxPAjgtIs0HDm8w1//BuC2XKxJJLbVhilD6tlp9hus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955547; c=relaxed/simple;
	bh=R4gWjaTC/xtvDBWywUW2yjO8zApz3ClO0gfFWPQni28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nD8bYEbQPDauKawMcqj/iLh0KnCRAXpH3GBjJyzKPG49PfYKVLqmp/zkGWGgpwJ0cDDC0QX243CfLsAqMOfggqTfu9QBMyWmDsDu81N4Co1PCxQtC/1Qys484SQzuHiXyC4DTOL/aAM4GdkfCA6IXBQnzx8DwDg/gOqnuxWxkU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjCcDaer; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjCcDaer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4185C4CEE6;
	Wed, 19 Feb 2025 08:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955547;
	bh=R4gWjaTC/xtvDBWywUW2yjO8zApz3ClO0gfFWPQni28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjCcDaerZrzctDrjFToGTeknJRzU31d/Q1Ux407/ucmaqlnvIRDjwo2eKbnQsp2ZD
	 Swhi0+w+RGXsepksSfwQEIjb8eXARDebc69+VGDNSXyevaNxoxzsAomyy54jb0VK9T
	 j/nSFBs/RbZl/jhRjyfm9zt0JoJN42b6/9yUMpBg=
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
Subject: [PATCH 6.6 040/152] rtla/timerlat_top: Abort event processing on second signal
Date: Wed, 19 Feb 2025 09:27:33 +0100
Message-ID: <20250219082551.627893435@linuxfoundation.org>
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
index 5a33789a375e3..1fed4c8d8520f 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -731,6 +731,14 @@ static int stop_tracing;
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



