Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF73E39FCDC;
	Sat, 12 Sep 2026 08:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201113; cv=none; b=p4m6AKXnUa4jNpVt9TfO0IBOC8HneP1SCBCvp6natZmFG3t5NqWS0577KQsWepRMtKwg4oyE3ABTaUewKNhS8hCsI2kgiYQfLfWo0piM5FijGMq36u3lHy6gAh34MAPx/quYqkuSSaEOXXzIWQ+McLBnDkezRjWuTeGPmIFLYyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201113; c=relaxed/simple;
	bh=/YUUPcUhxDXgl1AkpldtS5IoWIha95QsCU50zMk2YX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHb+mNF766tH3EcSSgCqZN+JYfDvZEIloXY2IAgU1CSXosZbcwWMEN4a3WjUBMj63lXQJWNW1A/YsjPNAhkn1IW9T9pME7ZzO8zg8hxk+txo1Z9G0ax+M9O86xI7WDRWju1l4FCSe6W1vXLYgdpdIP3uMA0HVJZ53HV3c9sPyV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHduPkga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHduPkga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00091F000FF;
	Sat, 12 Sep 2026 08:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201111;
	bh=/h9xLVtvFU/zF9X/keF8mv/TbOL2dh0TqAxbdP3hEOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aHduPkgaibpimF+PTvKLXcbshLlDkGJnm19QMezDVF+nxYa66FlSOsriqPCh5iPQB
	 FmeBFHQ2eCOxwnSBRahHAwS0DT97RdHw+exZNuGdMw3Ybcoy9s7FlME+BFIwTYSH+H
	 sUso3Mw5oxJvDXVtmjbQs14OFR7QSU0wIAa1zJ4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0930/1815] perf machine: Free scandir entries in guest kernel map creation
Date: Sat, 12 Sep 2026 08:44:40 +0200
Message-ID: <20260912065710.778610275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 1700130adedb3..48c4b963e8097 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1256,6 +1256,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 		for (i = 0; i < items; i++) {
 			if (!isdigit(namelist[i]->d_name[0])) {
 				/* Filter out . and .. */
+				free(namelist[i]);
 				continue;
 			}
 			errno = 0;
@@ -1265,6 +1266,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 			    (errno == ERANGE)) {
 				pr_debug("invalid directory (%s). Skipping.\n",
 					 namelist[i]->d_name);
+				free(namelist[i]);
 				continue;
 			}
 			snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
@@ -1272,9 +1274,11 @@ int machines__create_guest_kernel_maps(struct machines *machines)
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



