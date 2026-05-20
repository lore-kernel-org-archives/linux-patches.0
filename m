Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D3633A9CF;
	Wed, 20 May 2026 16:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295527; cv=none; b=oTOn2pEasWpekAgYvGrhA4Tt7uU9ORwvdstMc9Jy4rRsIjvO/YQl+Pg6gaNugy6xp66474oMZfaULRzcNBry7Iy5x8BEWAAYhv2y3ySSDczgblBZ0S4UHVjb9KEgGtekCrOtYZ2u8PXGuwAbkWMyPFgrvxK2mGw0iea5vK4PFFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295527; c=relaxed/simple;
	bh=rTyT9Vb5zQ/AGAaKbAMYaV7pLx+OOrdes+4AW4du4wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6FNq7FK8l+0vX0/rCCGc3Cf7wp1oG5Qw5oPX7sZna8SDmvvD5ZezlKd1wMwBhsPA8529CO9QhRraCsaS1B1jj2Uspi8ZswpVEz3z3JmpvhKzw7GtTQGUX8C0TWPFL4UiUhAacuseq0ZUvT0KfQ5X+ZJkwWvtwyEu1AuClB4BD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3ykFLo/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3ykFLo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348701F000E9;
	Wed, 20 May 2026 16:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295526;
	bh=MAVa9Gj9eaN4D9TLIu6YXFCJwUK1L/uNFqdS8+cSHx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S3ykFLo/7r4RHCr6v+EiTQIiHSfjaKfxhOH2N3DscyUsaJE8clfVwyCcfnn2AKvwh
	 koGes6jwDC5Seos1mDzTDThgidh1jw+RQzcCXbW0sjLfgF4ehoJMs6dTu2wx7DLcIQ
	 XCGZW2Ci7qco8BBFiXEMwbPTufNw09cpsTxukxko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0453/1146] rtla: Use str_has_prefix() for prefix checks
Date: Wed, 20 May 2026 18:11:43 +0200
Message-ID: <20260520162158.452078806@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit 265905df83a4c1e78c1a912e1699d7c81d9540e6 ]

The code currently uses strncmp() combined with strlen() to check if a
string starts with a specific prefix. This pattern is verbose and prone
to errors if the length does not match the prefix string.

Replace this pattern with the str_has_prefix() helper function in both
trace.c and utils.c. This improves code readability and safety by
handling the prefix length calculation automatically.

In addition, remove the unused retval variable from
trace_event_save_hist() in trace.c to clean up the function and
silence potential compiler warnings.

Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Link: https://lore.kernel.org/r/20260309195040.1019085-12-wander@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Stable-dep-of: 4bf4ef5292b9 ("rtla/trace: Fix write loop in trace_event_save_hist()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/trace.c | 5 ++---
 tools/tracing/rtla/src/utils.c | 3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/tracing/rtla/src/trace.c b/tools/tracing/rtla/src/trace.c
index 073ec1b567798..d5a6a7351d40f 100644
--- a/tools/tracing/rtla/src/trace.c
+++ b/tools/tracing/rtla/src/trace.c
@@ -358,7 +358,7 @@ static void trace_event_disable_filter(struct trace_instance *instance,
 static void trace_event_save_hist(struct trace_instance *instance,
 				  struct trace_events *tevent)
 {
-	int retval, index, out_fd;
+	int index, out_fd;
 	mode_t mode = 0644;
 	char path[1024];
 	char *hist;
@@ -372,8 +372,7 @@ static void trace_event_save_hist(struct trace_instance *instance,
 		return;
 
 	/* is this a hist: trigger? */
-	retval = strncmp(tevent->trigger, "hist:", strlen("hist:"));
-	if (retval)
+	if (!str_has_prefix(tevent->trigger, "hist:"))
 		return;
 
 	snprintf(path, 1024, "%s_%s_hist.txt", tevent->system, tevent->event);
diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
index fb067220566a4..22d2182c729e5 100644
--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -316,8 +316,7 @@ static int procfs_is_workload_pid(const char *comm_prefix, struct dirent *proc_e
 		return 0;
 
 	buffer[MAX_PATH-1] = '\0';
-	retval = strncmp(comm_prefix, buffer, strlen(comm_prefix));
-	if (retval)
+	if (!str_has_prefix(buffer, comm_prefix))
 		return 0;
 
 	/* comm already have \n */
-- 
2.53.0



