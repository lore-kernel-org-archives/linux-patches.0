Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9C8359A6F;
	Wed, 20 May 2026 17:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298385; cv=none; b=UHhPEXosjF7h3HzsGRe8d5EXKvtgT27gurLJgzO0yzBFhZfnDrfFOBQzfFbvXMbUKqL89vkMmKez+/wfQkAdxn/5xh0hzBox7XutV2cisnA+FyJgwT7q4e+WOufgL1CByx0a7DcNmGXvOCH0fiX6jQNbTnZL1XapShdAAd2NAOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298385; c=relaxed/simple;
	bh=YdDCVFDRrMxGwCK0LHYW/ME6uo0d6/fLxbmbK5Oy/o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WC2jZmB/RqnOmIBq7lh86+GCDSC3/r0s6FniBRZbpVuWk9RRZIwBl30d9qsBonXLJo1ZL08jBQ/YDmA2xkHEflE8ff54oW2sGuQEwyQZMrnzrwaGvO8zcaYyzQdj09RorGOQCoJJ1UlIFBTXJuGbxY2bnNUY+vUG7vXxJLi1gWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHFpjVCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHFpjVCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F72E1F000E9;
	Wed, 20 May 2026 17:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298383;
	bh=1T+uoeduzESvfSaGfCimT1i2IwScA5hHHTbOUbu4A5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VHFpjVCCxZ9mbaXIWQEqbgbyQ+al9o5JLNk5JHfxI1Tot+QWCtMsjexj82oZrJ827
	 JJKLybybfS67oerTqQ5KHjLwZFyCO6iDG1atPd/F5IzyK+/4SYP2HEXWkBGTG/hTR6
	 /hk35ZP3x9XmojFwayWqXYxlCCtAwoPPw4AxCtTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 353/957] rtla/utils: Fix resource leak in set_comm_sched_attr()
Date: Wed, 20 May 2026 18:13:56 +0200
Message-ID: <20260520162142.185829300@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit 5b6dc659ad792c72b3ff1be8039ae2945e030928 ]

The set_comm_sched_attr() function opens the /proc directory via
opendir() but fails to call closedir() on its successful exit path.
If the function iterates through all processes without error, it
returns 0 directly, leaking the DIR stream pointer.

Fix this by refactoring the function to use a single exit path. A
retval variable is introduced to track the success or failure status.
All exit points now jump to a unified out label that calls closedir()
before the function returns, ensuring the resource is always freed.

Fixes: dada03db9bb19 ("rtla: Remove procps-ng dependency")
Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Link: https://lore.kernel.org/r/20260309195040.1019085-18-wander@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/utils.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
index 6b7717fcd142b..bf20077cca742 100644
--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -347,22 +347,23 @@ int set_comm_sched_attr(const char *comm_prefix, struct sched_attr *attr)
 
 		if (strtoi(proc_entry->d_name, &pid)) {
 			err_msg("'%s' is not a valid pid", proc_entry->d_name);
-			goto out_err;
+			retval = 1;
+			goto out;
 		}
 		/* procfs_is_workload_pid confirmed it is a pid */
 		retval = __set_sched_attr(pid, attr);
 		if (retval) {
 			err_msg("Error setting sched attributes for pid:%s\n", proc_entry->d_name);
-			goto out_err;
+			goto out;
 		}
 
 		debug_msg("Set sched attributes for pid:%s\n", proc_entry->d_name);
 	}
-	return 0;
 
-out_err:
+	retval = 0;
+out:
 	closedir(procfs);
-	return 1;
+	return retval;
 }
 
 #define INVALID_VAL	(~0L)
-- 
2.53.0



