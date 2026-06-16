Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3C143DA2C;
	Tue, 16 Jun 2026 15:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623127; cv=none; b=WrXgc3cLCxv6Id9C1XO9UHSoj0SWYRnucJfRJ2BMZHy8787vP3dRoJi2pe6X4J3A85ZlT1eXmpsRqc35ZPcQq/6zQ5aS8FYm9bvts5b53ZiKRCFdYzvft5sd6hf43T6zhIUpQYHqUYhrkbY+6BxV7sHg8gfZnFTr/RXwHYpW8wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623127; c=relaxed/simple;
	bh=Ry9OS9HnHFJyFJuJvYHATezQAU0uTi2BLV6qjUkec+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFP52Xo9zQVXprkkeOLdhmsybY4f+PW3yL6F8GtFqJ/GYQg3C9RrvNAiCimNERj0l6SAQ9QOHzAG8NG/zsNd12Al/c41QzLv56mCSkNSxyfI4Z7x9BTF635xdIiGwv5sgZy6piICdtBcOCUKBtdZzGmE6BVXoEpCl8eV4mYi6N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkPnlmt+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkPnlmt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5B41F000E9;
	Tue, 16 Jun 2026 15:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623125;
	bh=k5o+NzBo3tilC4nT9IAlXvueWqRG9qSy316ayS9753g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkPnlmt+O+soZWLGnwj3TJMBorHQE65TsWnjOtpDT3cLRvXAu1E3PSufEX4W2yx/a
	 JO9uObZNDqbMsAD3dDa+2nx9RXV4KMJGLqrL2S8PEv65Oj4SRefmqzZZiewbCR6geH
	 NI7H3W/0LRh6zc6TYBDQ1ABf4yFijg8+ojdOaDJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 092/378] tools/rv: Fix substring match when listing container monitors
Date: Tue, 16 Jun 2026 20:25:23 +0530
Message-ID: <20260616145115.120850680@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit ba0247c5aa3fcb2890a92a97a88c70fe5ce704a6 ]

When listing monitors within a specific container (rv list <container>),
the tool incorrectly matched monitors if the requested container name
was only a prefix of the actual container (e.g., 'rv list sche' would
incorrectly list monitors from 'sched:').

Fix this by ensuring the container name is an exact match and is
immediately followed by the ':' separator.

Fixes: eba321a16fc6 ("tools/rv: Add support for nested monitors")
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/r/20260514152055.229162-3-gmonaco@redhat.com
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/verification/rv/src/in_kernel.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/verification/rv/src/in_kernel.c b/tools/verification/rv/src/in_kernel.c
index 95eac9ab148468..e4f35940374f5a 100644
--- a/tools/verification/rv/src/in_kernel.c
+++ b/tools/verification/rv/src/in_kernel.c
@@ -193,8 +193,12 @@ static int ikm_fill_monitor_definition(char *name, struct monitor *ikm, char *co
 	nested_name = strstr(name, ":");
 	if (nested_name) {
 		/* it belongs in container if it starts with "container:" */
-		if (container && strstr(name, container) != name)
-			return 1;
+		if (container) {
+			int len = strlen(container);
+
+			if (strncmp(name, container, len) || name[len] != ':')
+				return 1;
+		}
 		*nested_name = '/';
 		++nested_name;
 		ikm->nested = 1;
-- 
2.53.0



