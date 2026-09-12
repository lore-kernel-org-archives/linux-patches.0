Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B88F4F1;
	Sat, 12 Sep 2026 16:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230547; cv=none; b=pteHRsTIr1Ads/4M7UKKxrpP3MhMq8ISWprkw6MAMpUWoReNsS7oXhCi/Mom5Ctv8Jbc9t3CmHLcOePoelftmKzsvdwqKWGx56YUrPjUQXcNGk87wB6EmUg5yVI1SdKNKdplllrlrnzM49trSimFFI/4Rb1W29IoH0wmLK/Ljp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230547; c=relaxed/simple;
	bh=h7gXL2JdfAbPu596olbY+uTE/CjMokATZMdg6llNayg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLA4swsI8ZNIAquQ5Jb8Ed/TbYiuwQUKmfVyigpDuetz0bPPIV0jYcb/NiriziFR310kIf62llERgF+ppZoEgPkkjK61nL0rkdkAdWhHwMpbR6FElm7HjwW1+/w8cAU5LyfyhJ+tS2k4BJOvLkvZECuCw5QmVI1+N9AbaLRDA3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRJepVtD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRJepVtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E6B1F000FF;
	Sat, 12 Sep 2026 16:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230546;
	bh=K7o1UqInnlAzbDtVnsHdgPv8YQLmKHxng78q7DLNPfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRJepVtD19LVxdwfdZmiHb0BadXe5h0Dv42a/wjbWcUG4s7mZzHc9DjFLHAHJ9cXr
	 7brBhE65Fddz7fnf/yRPncVdZCfarv9ZvPnBzvbAEeUgBNBdSL/X1eYM8SfZiLuN6v
	 FmOYX44IsAVsb3HaUttrJphkL6lFcIIv90QY8DOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0815/1191] perf machine: Free scandir entries in guest kernel map creation
Date: Sat, 12 Sep 2026 08:59:03 +0200
Message-ID: <20260912065606.573041632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e285ad1397490..d4a39b147df64 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1361,6 +1361,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 		for (i = 0; i < items; i++) {
 			if (!isdigit(namelist[i]->d_name[0])) {
 				/* Filter out . and .. */
+				free(namelist[i]);
 				continue;
 			}
 			errno = 0;
@@ -1370,6 +1371,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 			    (errno == ERANGE)) {
 				pr_debug("invalid directory (%s). Skipping.\n",
 					 namelist[i]->d_name);
+				free(namelist[i]);
 				continue;
 			}
 			snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
@@ -1377,9 +1379,11 @@ int machines__create_guest_kernel_maps(struct machines *machines)
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



