Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7A61C862F;
	Tue, 30 Sep 2025 15:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245833; cv=none; b=cq4BTdlUNO6X3duulObN3SrMagKqduNv0YyCsZAuRpolTpnnoBcu2dafVdiojKUvZIXSu9YWoBlc9fkxZ3p4jC9BlAK/+d/Z7aftuZGpEWSSfmhT/0AAhkGyS+pLA+2/s9HMPlvLC4F7OSh09w7Mj+tKnF6s3O3sjRE2ZvZXg/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245833; c=relaxed/simple;
	bh=Y+K+uA26GlygSCenG32BIuqNlOxOu7X7YaymhEJdIBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uB/1YhqRJEmUzaYb0TTo9AmNujwAB/H8oBw+PxOFLSuZ5fwwvL942v673yAdEZVNeQLwjGTFB+RKZUKYd0o6VRNjSSWQbjiObfpQWs8DSb9nImgFyTPEDEWMLm7mG2m+NxWqCkeLSNmVE+VdLShwb5ZbbbDhwoZwJAjvFrP8Psk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrQw90Qz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrQw90Qz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516F5C4CEF0;
	Tue, 30 Sep 2025 15:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245832;
	bh=Y+K+uA26GlygSCenG32BIuqNlOxOu7X7YaymhEJdIBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrQw90QzXePzrGNGSYnFqD6+SDogUiwiopqJIZbAGpw5jlqeut8imdEcVN4XfE6DG
	 D6aaqcXzQxYFzDQ6XRFpuAoJtUYFCB9xVkjtKYIHDYEeI9c3Rx8IIjNTOxnqT+Xopm
	 hkHyPl1O7tqp86qA73lBzfesyftW8GvqvfcqC/Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 64/91] tracing: dynevent: Add a missing lockdown check on dynevent
Date: Tue, 30 Sep 2025 16:48:03 +0200
Message-ID: <20250930143823.847515785@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 456c32e3c4316654f95f9d49c12cbecfb77d5660 upstream.

Since dynamic_events interface on tracefs is compatible with
kprobe_events and uprobe_events, it should also check the lockdown
status and reject if it is set.

Link: https://lore.kernel.org/all/175824455687.45175.3734166065458520748.stgit@devnote2/

Fixes: 17911ff38aa5 ("tracing: Add locked_down checks to the open calls of files created for tracefs")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_dynevent.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/trace_dynevent.c
+++ b/kernel/trace/trace_dynevent.c
@@ -239,6 +239,10 @@ static int dyn_event_open(struct inode *
 {
 	int ret;
 
+	ret = security_locked_down(LOCKDOWN_TRACEFS);
+	if (ret)
+		return ret;
+
 	ret = tracing_check_open_get_tr(NULL);
 	if (ret)
 		return ret;


