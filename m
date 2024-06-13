Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2634142903;
	Thu, 13 Jun 2024 12:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282322; cv=none; b=CofHJwPdUh3wZqc9IVw5CTXRq7MQAhAmvbYURDIJnvzL18TWcvIdJ928X9UsyqlB96OWDZQmRrB4Lamgmgvi1Mg+rVkyXO2nNyKrQcHN6vbin8OcXNFWLMYpJEE31JzgrvpFppEHK0qKiVhiG45IynxRA5dEbHjDGywewo3YskQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282322; c=relaxed/simple;
	bh=Zs7upTfSJS1B7h3B0TrFXdS5Vr3Q6oS8XPfsMfmZ3kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ON/loqn/i3UUkDojw0yl0FS7Xb8i03zkNdOb3fG1swjsxDtvch2IXi1pIPDigYTjgNZ9lwiFcW6+Ra/BC8t5wX8zQKKxtZZSeYmn8HX3JNdYL55a98ZyxLzZidn//3BcDyI+xvB1ybrO9rP+XD8TCQqDqRbmmvzaOQREtpyGhz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFj6oQY6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFj6oQY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F83CC2BBFC;
	Thu, 13 Jun 2024 12:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282321;
	bh=Zs7upTfSJS1B7h3B0TrFXdS5Vr3Q6oS8XPfsMfmZ3kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFj6oQY6rIYsa6KSvXhfyB7Xw6kNGkdz72BKO4VcZVttS/cz0sgmB0P8hhuUCM5xI
	 XpZAcjmo9Xk1Zpwt7RJ+tdOROa0naWgQ4TxrBU/2irzyQMYsemuVhD+CfKI1rVBa7b
	 5gP831N2qFt0Cm/uF8QrhQuJ2nI0DoHM+QReto7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 237/402] perf daemon: Fix file leak in daemon_session__control
Date: Thu, 13 Jun 2024 13:33:14 +0200
Message-ID: <20240613113311.387793190@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

[ Upstream commit 09541603462c399c7408d50295db99b4b8042eaa ]

The open() function returns -1 on error.

The 'control' and 'ack' file descriptors are both initialized with
open() and further validated with 'if' statement.

'if (!control)' would evaluate to 'true' if returned value on error were
'0' but it is actually '-1'.

Fixes: edcaa47958c7438b ("perf daemon: Add 'ping' command")
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240510003424.2016914-1-samasth.norway.ananda@oracle.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-daemon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-daemon.c b/tools/perf/builtin-daemon.c
index 61929f63a0474..361fbee36b35c 100644
--- a/tools/perf/builtin-daemon.c
+++ b/tools/perf/builtin-daemon.c
@@ -523,7 +523,7 @@ static int daemon_session__control(struct daemon_session *session,
 		  session->base, SESSION_CONTROL);
 
 	control = open(control_path, O_WRONLY|O_NONBLOCK);
-	if (!control)
+	if (control < 0)
 		return -1;
 
 	if (do_ack) {
@@ -532,7 +532,7 @@ static int daemon_session__control(struct daemon_session *session,
 			  session->base, SESSION_ACK);
 
 		ack = open(ack_path, O_RDONLY, O_NONBLOCK);
-		if (!ack) {
+		if (ack < 0) {
 			close(control);
 			return -1;
 		}
-- 
2.43.0



