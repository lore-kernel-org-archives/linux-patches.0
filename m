Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FBF299920;
	Sat, 12 Sep 2026 12:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217175; cv=none; b=la5t2ndQ92KRs3sDT7fiG2ez2vxeioGR3Cz6fHKFGWO0gYly2Wm5truuCdlcscAGOXxRWoWlVl3Inc+ApLFEYq1VQ+3HulA1dKKSOo9KEv4aHPqIjL4/ZUIE8ar2Ofcd1yKcZa46+wYmlLiOGGOT0DkIN/pF/Loq+YrTFwO73Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217175; c=relaxed/simple;
	bh=kvozZwCTU253J4gITgnzvDo856bCyLssKDkBL664XDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MUdmX9rwgZQdluutprViTt+ZHR0CgUh29AZGR09jW13GkBqOuL2tDLsxErdY07yLetEbDry7FsZKSZyx0C6G5Wupnk8f8okD4/FS13xgvDudzbfDZ+zSbJlj8TYyc/GlJJV1D9cSyuh5Uc9K8X7+a1gcPMKdPbpKE70vOJom+dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibv6Tv8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibv6Tv8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1233F1F000FF;
	Sat, 12 Sep 2026 12:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217174;
	bh=6zlfhLt18FCSyAYPCOpRnVfBHu4sqFsdHqslhuj668E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibv6Tv8/Of9SwUcBcfSJroQU8+y3wyFQE3XsPgKXiRwWUP4BTd7ZmxRx4LsvUdZ+u
	 xkH3iRErxy6mGhBhdNkVkLS46xGSSPx9B3aiMudBat111Z8QOJ7x5Jt28wPWafMNod
	 rTBGwe+pkOlcDLCqSTKMx2ub3I7pLk5cCs9yJ7/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0833/1376] perf machine: Dont abort guest map creation on first inaccessible dir
Date: Sat, 12 Sep 2026 08:54:19 +0200
Message-ID: <20260912065626.112136603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit b687e1a418fb819ef83c362d84c216a6a841e3b0 ]

machines__create_guest_kernel_maps() jumps to the failure label when one
guest directory's kallsyms file fails access(), skipping all remaining
valid guest directories.  An inaccessible directory is not fatal — other
guests may still be reachable.

Replace 'goto failure' with 'continue' so the loop processes all
directories, and remove the now-unreferenced failure label.

Fixes: a1645ce12adb ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ea89e7499032a..073ab47bd5678 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1223,14 +1223,12 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 			snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
 				 symbol_conf.guestmount,
 				 namelist[i]->d_name);
-			ret = access(path, R_OK);
-			if (ret) {
+			if (access(path, R_OK)) {
 				pr_debug("Can't access file %s\n", path);
-				goto failure;
+				continue;
 			}
 			machines__create_kernel_maps(machines, pid);
 		}
-failure:
 		free(namelist);
 	}
 
-- 
2.53.0



