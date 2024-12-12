Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC1A2210E3;
	Thu, 12 Dec 2024 15:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018587; cv=none; b=Z04s7i8hJAxgceIKoz2XJGv934ziqI8HMPgOQPXhP3G0LE6wzdmsqdfE7cRoFy/p1XHXtIAFbjXisokFfJzAJfwyFd1fm5DeAYjBGSqmQYYKc97dPyqHOtZ/xSUsKNTUA4/M5MWsrV5emzIE02z7nFCgH0Z99XSwrJJlrRCsl18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018587; c=relaxed/simple;
	bh=ftuH3ab+NfiP/e6tHtuovDz/53B9oE9GYshOClt8P/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJPMwvlEq9szLZ4LUbhtrya3SZQL74xmA/MGJ2J/ZhWcQVekAOloyibCuOdSr1en2FQ+ME/LDq7iyuEj/TvV7mWy9qDI1/o2cU4qcyyU9uIBiwrakkPwvxGzmHwGSwAjK/I5KEcbW4azcztz7StnNMdGiBoaRogUpXQCTniKv/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WcSdVv+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcSdVv+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0975EC4CECE;
	Thu, 12 Dec 2024 15:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018587;
	bh=ftuH3ab+NfiP/e6tHtuovDz/53B9oE9GYshOClt8P/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcSdVv+LHXjdGByy9s6LjWH8/ZeM5TBfLbe19PiaLyx+4JUb12VvJHW4aT80VpjEU
	 qVHAvtyo2x2IH7M830ejoNLr5gxyhunUxEyFeEP32owlmzsaVupLaZchTaeayPNJah
	 9s3AINUMYn6XlvAhlXucl8g6JY9GcwstfJTQTHdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 334/356] tracing/eprobe: Fix to release eprobe when failed to add dyn_event
Date: Thu, 12 Dec 2024 16:00:53 +0100
Message-ID: <20241212144257.754929153@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 31bb977670bdf..f1f12ce5efb0a 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -966,6 +966,11 @@ static int __trace_eprobe_create(int argc, const char *argv[])
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



