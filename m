Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CA626A0ED;
	Tue,  8 Apr 2025 12:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116647; cv=none; b=Tp1T7DowOVTiaBhPZgX6ysQBzIzUc95vYckNHATCxUrFsBKv9NzQvQY0ktk+GhQ29Z05LQ//LvJ+nysztHq/rE38iYkDxmQwX8Xw4mnzS6aZ+MDsCE3A3IgX+r7h9O3k66OCHSpEXm96cXppA/N+MFFdAU2SJDdS+NZ0KeegQ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116647; c=relaxed/simple;
	bh=hoRrW04nBPegKEcZKSq9KuIuj54TE3n8Ul5rietBj1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSg/1DkFsi/qGecBdztI+hsgxPPVlFE2tmYDPMYSdjcEFtc1R8mFq0yosAsRrr7kRS2hiSdVbJUEViQn41JLPnwhr+W57kldKD5obYSBSZZSugIWGN91WSS1MLQBtnGETF9btb12JMV/iXYfwcHZwUWu5TBGUGaWtD4ns6Me24w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTIQ3htE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTIQ3htE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEEDC4CEE7;
	Tue,  8 Apr 2025 12:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116647;
	bh=hoRrW04nBPegKEcZKSq9KuIuj54TE3n8Ul5rietBj1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTIQ3htE47X8BmL3BHCzxVjVKdJztc4qxmQ8FFKd1aQCNhvC2sI5AGgMmbuyOGaNC
	 7Cjn4+CQ6ayGSBGc7rt8hlgaZWP6cXXnR79wsbi3Gwtsh9KUwv3bIYSayB1HyPw4/I
	 stghKE63Aq7XBB33LfqKv0nq81z3DrW6p3Z5jE6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 215/423] perf dso: fix dso__is_kallsyms() check
Date: Tue,  8 Apr 2025 12:49:01 +0200
Message-ID: <20250408104850.738290122@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Brennan <stephen.s.brennan@oracle.com>

[ Upstream commit ebf0b332732dcc64239119e554faa946562b0b93 ]

Kernel modules for which we cannot find a file on-disk will have a
dso->long_name that looks like "[module_name]". Prior to the commit
listed in the fixes, the dso->kernel field would be zero (for user
space), so dso__is_kallsyms() would return false. After the commit,
kernel module DSOs are correctly labeled, but the result is that
dso__is_kallsyms() erroneously returns true for those modules without a
filesystem path.

Later, build_id_cache__add() consults this value of is_kallsyms, and
when true, it copies /proc/kallsyms into the cache. Users with many
kernel modules without a filesystem path (e.g. ksplice or possibly
kernel live patch modules) have reported excessive disk space usage in
the build ID cache directory due to this behavior.

To reproduce the issue, it's enough to build a trivial out-of-tree hello
world kernel module, load it using insmod, and then use:

   perf record -ag -- sleep 1

In the build ID directory, there will be a directory for your module
name containing a kallsyms file.

Fix this up by changing dso__is_kallsyms() to consult the
dso_binary_type enumeration, which is also symmetric to the above checks
for dso__is_vmlinux() and dso__is_kcore(). With this change, kallsyms is
not cached in the build-id cache for out-of-tree modules.

Fixes: 02213cec64bbe ("perf maps: Mark module DSOs with kernel type")
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Link: https://lore.kernel.org/r/20250318230012.2038790-1-stephen.s.brennan@oracle.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index bb8e8f444054d..c0472a41147c3 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -808,7 +808,9 @@ static inline bool dso__is_kcore(const struct dso *dso)
 
 static inline bool dso__is_kallsyms(const struct dso *dso)
 {
-	return RC_CHK_ACCESS(dso)->kernel && RC_CHK_ACCESS(dso)->long_name[0] != '/';
+	enum dso_binary_type bt = dso__binary_type(dso);
+
+	return bt == DSO_BINARY_TYPE__KALLSYMS || bt == DSO_BINARY_TYPE__GUEST_KALLSYMS;
 }
 
 bool dso__is_object_file(const struct dso *dso);
-- 
2.39.5



