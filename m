Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982C12139C9;
	Thu, 12 Dec 2024 17:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023448; cv=none; b=oIMBQnRcfH2rdim7LnbprnDrJeRgyGU/6NKrgLjH0xZwdw6AypZ39CvUlB2KMPl+2oktS5JJ8HZ1C+WZpYHIDJTTSElSDFCK0uK1hlzV9ouaI06AeI9rvRkYPT9IDdXk7kpFCS7o/nOJAC8Gn9oMaN3KUjd7XspV/AS+kug/7WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023448; c=relaxed/simple;
	bh=Ib3Et3x/ijc8A2t8430+bMIcRXqahfOxW1YbLF9bk7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqa9RjadfvA5Vc8AKeZ+k8Xzhv4dSBfXQyEFHzujmlIDma9/F7836xd9HDe7dMxH5dnhIGRodrr4ur+ToPyV6S1xWmEDFfPM19tbnQ6DaFJrzJVSHm6r2hcnKl6oZ5wx3UXwORBwn7ggeptyX1UKuDwGJhST72w+rBZ2goNyYuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQ8zIz2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQ8zIz2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064BCC4CECE;
	Thu, 12 Dec 2024 17:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023448;
	bh=Ib3Et3x/ijc8A2t8430+bMIcRXqahfOxW1YbLF9bk7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qQ8zIz2SP9uUjEgv4FZyZhuOzSKvgI6yY0Q4aFP9aQvhljjTnLOBmrwQscLTNWIJn
	 E6Jyo6D5bYR3QclgpU3Mc6hCuX2QiuX8njU8QtrNEz8LOvvMHAWobRGXRcVAIOh/S/
	 KB5o8YP7IL9yuoAi4tHtZ8mUh6XJAbzwk6NnjlCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 537/565] tracing/eprobe: Fix to release eprobe when failed to add dyn_event
Date: Thu, 12 Dec 2024 16:02:12 +0100
Message-ID: <20241212144333.063161936@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 494b332064c0ce2f7392fa92632bc50191c1b517 ]

Fix eprobe event to unregister event call and release eprobe when it fails
to add dynamic event correctly.

Link: https://lore.kernel.org/all/173289886698.73724.1959899350183686006.stgit@devnote2/

Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_eprobe.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
index 085f056e66f19..6ba95e32df388 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -979,6 +979,11 @@ static int __trace_eprobe_create(int argc, const char *argv[])
 		goto error;
 	}
 	ret = dyn_event_add(&ep->devent, &ep->tp.event->call);
+	if (ret < 0) {
+		trace_probe_unregister_event_call(&ep->tp);
+		mutex_unlock(&event_mutex);
+		goto error;
+	}
 	mutex_unlock(&event_mutex);
 	return ret;
 parse_error:
-- 
2.43.0



