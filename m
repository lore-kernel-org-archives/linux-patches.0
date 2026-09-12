Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABBD274B46;
	Sat, 12 Sep 2026 14:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224439; cv=none; b=GNM8WmE1Owm5VWJJQLCGtrHMtHWb61197kw2Ny74w3aVd50IjSXlHUdMKJTSiDWDndUgse5vqSximBM7PD1hnulo+uQW0L5mMxqQIk9emAynveMOAS0lEeh2ceVoW2u7kMQbJ9vMs0VFn9QuEimwo7/Q81pTAFwrSmRNXhNvDzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224439; c=relaxed/simple;
	bh=K2eTeZ6vdc5Ni1pIix2WvR9CTM3AM1RXufHhPWFSPMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f2wOrVIduxQ9H0nE/z73S+LGSYZgqQWjksCkvYkaoaEE2vxD2FvUCNw78nu+gVFVZTYdTkLgtFvC7NYL6mlQYb7SFYMNe+SlOl57tg0rw1qkYkv2eY0GB7nFpRH9hmGvumeop0BWtam47fFnAmJYOFsy5V3tEIC/Nj8AnN+Ntec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XycCq/jC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XycCq/jC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22E21F000FF;
	Sat, 12 Sep 2026 14:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224438;
	bh=BGf3EptJ0Y1NpWZuea+I5AsSHmpsVC0gCXpDwz0gDe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XycCq/jCSljjI82wGqmnU/VbRi+G8CGC8ManBvhxBzJY8+KZEXTb4TB7rNBMrhk5u
	 rtsHKot/cu9UuznPUVVBEGI6s/KS7aDtpXO8RZ1+ddBQoZHvimANC5RY8dNbtEAG0O
	 odSkimEPSnpc3AAC+HWcVL3VTRSnTlG3A9bmhc0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0991/1424] perf machine: Dont abort guest map creation on first inaccessible dir
Date: Sat, 12 Sep 2026 08:57:03 +0200
Message-ID: <20260912065629.508754040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3245c035d96d9..7cc97c3ef2249 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1424,14 +1424,12 @@ int machines__create_guest_kernel_maps(struct machines *machines)
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



