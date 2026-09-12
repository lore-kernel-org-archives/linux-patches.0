Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C332A362120;
	Sat, 12 Sep 2026 10:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209476; cv=none; b=CGiOClH6ct72BAd8UvfQCNtU97b0cZIKaQ/NSUhKNKnCzmNBgpd0UAtUqXQpJJ+oFzBqb2irsOD7Omxa/i+AJaxCpABJzMSFYAl8rq3D4UYXXhjsG1vjzt8PXJcReaSIVa1h9+D1ac1w77so4t3kfUUXLRTMNVRJyLOJ/qpvSow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209476; c=relaxed/simple;
	bh=xWbqI8gPt7FOAwEq0tcovhmq/1rlWN40IHO/C7VMfno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5tcYPM3Sj9m2DPTL8OO14OMfBKSFSjvcyDgM5gGsx5IUwVsXASC6lqxN/05KGH3aZejDEyeSLeO4HIx4dRxS0ER6NX7Y4GFULf18CbK51xZhtnArAqgAG7F1M/+2hu1/oDyOvQ1Jflm70SF055V+DgACgLdpiY2TdsywCMjdF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxp2soMS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxp2soMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7C91F0089A;
	Sat, 12 Sep 2026 10:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209473;
	bh=uYG386BWVpmVb3xHJglKW5TaERZS1BU6qC+gd0q8BM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxp2soMSTIWN6ATakzBuC3PQWmwqyfEr1qUyP6NHyAXehYmz9/GwfJKn4e1vdQN5L
	 IbNqeHzejYHHwNe+lvqiNrt4f2vU2qCQD4M58ptn6b0v3zTqThMQjhyrXeR/3bAWRr
	 O4bVSiohpWtQXSvmMMQQc8/n/v5cHYpIJpWlH8KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0785/1518] perf machine: Free scandir entries in guest kernel map creation
Date: Sat, 12 Sep 2026 08:49:14 +0200
Message-ID: <20260912065641.195140909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit f53bf58dcd11e1cb088d3b91a035fef77062094b ]

machines__create_guest_kernel_maps() calls scandir() which allocates
both the namelist array and each individual dirent entry.  The code
frees the namelist array but not the individual entries, leaking memory
proportional to the number of directories under guestmount.

Free each namelist[i] after it is no longer needed.

Fixes: a1645ce12adb ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 7489bc84a3d39..5deeb41753717 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1235,6 +1235,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 		for (i = 0; i < items; i++) {
 			if (!isdigit(namelist[i]->d_name[0])) {
 				/* Filter out . and .. */
+				free(namelist[i]);
 				continue;
 			}
 			errno = 0;
@@ -1244,6 +1245,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 			    (errno == ERANGE)) {
 				pr_debug("invalid directory (%s). Skipping.\n",
 					 namelist[i]->d_name);
+				free(namelist[i]);
 				continue;
 			}
 			snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
@@ -1251,9 +1253,11 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 				 namelist[i]->d_name);
 			if (access(path, R_OK)) {
 				pr_debug("Can't access file %s\n", path);
+				free(namelist[i]);
 				continue;
 			}
 			machines__create_kernel_maps(machines, pid);
+			free(namelist[i]);
 		}
 		free(namelist);
 	}
-- 
2.53.0



