Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBB21487CD;
	Thu, 12 Dec 2024 15:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017331; cv=none; b=jYjcys6dHcgC8njrgEz+22XciFX/yV7QN7ZcXahWkCFnu1uMb1iYYQlwhMk8wBgfqACzhtVf9Xbh1+05lBFcttgtSUWzvASQ0Pl2nFVBoEA3c8bXF8W4uxG270JmcBlB6Uy5fC4ig5mChShSJ0v5+RuQcY/9lOMNEPiOMt7pfAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017331; c=relaxed/simple;
	bh=zYevgBt9OduXC7rEltBHWh4Wcwe/1tDrc1Q/h0fc41o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppo+do2MflMofjhvc7NX4nTfTFWa11PuqdPMDEPFa4fqMmhJERnf5Ky686+PCHwClFBTfZ7itYv0xkU0dTR2ongmVeitMpDRtsvV1ou2y4/MuCUgikKiOLFuwjaGKVYRolVP+TvllEfg5fIFojv7hFxzEtTHnIBUelfcsfEaWQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Df1VpRRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Df1VpRRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE33AC4CECE;
	Thu, 12 Dec 2024 15:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017331;
	bh=zYevgBt9OduXC7rEltBHWh4Wcwe/1tDrc1Q/h0fc41o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Df1VpRRESWs6AG2FyKMWUW/o389v0h0Bi/eN/thhjjHlIcLoVkvGNJExQ2krIkQNT
	 dFpwU7Ub4aTswF3c5ZZ3xBefAZEeWk0AH5P+rTk6E3ZKeL5CbpsifyLChzEXtaiL2E
	 qcwyu3bFq5dcCfYhctunBvnjlTCXSvsSpkKOdkp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 449/466] tracing/eprobe: Fix to release eprobe when failed to add dyn_event
Date: Thu, 12 Dec 2024 16:00:18 +0100
Message-ID: <20241212144324.601049369@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ebda68ee9abff..be8be0c1aaf0f 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -963,6 +963,11 @@ static int __trace_eprobe_create(int argc, const char *argv[])
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



