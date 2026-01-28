Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F712DE6FC;
	Wed, 28 Jan 2026 15:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614730; cv=none; b=K8y2t5GXKwkE1EVWkHgphpnuZ6xpIinoijkMmw6HqWIxVoSvPq0PksnImjEv4Hnz2fG55uXGtTzlKY5ko4EIdPTlc1Y1Oz4+7V7lVcI0nUG+XjBae4l2zpg7tlLxWoDHXVssgqvb6yJxzFPAH2oDTclkp617nQqntB/RfOrilfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614730; c=relaxed/simple;
	bh=15tPriOdj3X7gpPcubtNl7J2lLa1ObAmrqsN3hFv6VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZA+EmafB0132J6JiyepYl96eC+mKKbmJ2Bv351d4rAilv4xT3L1kKwWUEf0osr7HHWV8hblKWLcBzCIgFNutb1JHaHb4jEAklHRdGypN0jEyNu314zXvmWqrMmytIulbn9V1OIoSmus+W5n7jufBKUFCXmThtEvoEr43FUpw2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvgIdcUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvgIdcUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2FFC2BC9E;
	Wed, 28 Jan 2026 15:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614730;
	bh=15tPriOdj3X7gpPcubtNl7J2lLa1ObAmrqsN3hFv6VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvgIdcUnkeIK7fEZZWyKlrbpKkFf9kCBcqp/inYfJbquYQhWSLMOtBmb4h6mo8bQC
	 Jn2QVfiheH7qsAvBMak/db83UhqMcbq6GafAHmFY7IrB/N6tq4LbbUrXotCYp2VT0N
	 /VTVaOaIyN0uI6jOQ23B63CBQU2QXQ4egmktu7mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	chongjiapeng <jiapeng.chong@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 225/254] mm/damon/sysfs-scheme: cleanup access_pattern subdirs on scheme dir setup failure
Date: Wed, 28 Jan 2026 16:23:21 +0100
Message-ID: <20260128145352.881694537@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 392b3d9d595f34877dd745b470c711e8ebcd225c upstream.

When a DAMOS-scheme DAMON sysfs directory setup fails after setup of
access_pattern/ directory, subdirectories of access_pattern/ directory are
not cleaned up.  As a result, DAMON sysfs interface is nearly broken until
the system reboots, and the memory for the unremoved directory is leaked.

Cleanup the directories under such failures.

Link: https://lkml.kernel.org/r/20251225023043.18579-5-sj@kernel.org
Fixes: 9bbb820a5bd5 ("mm/damon/sysfs: support DAMOS quotas")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: chongjiapeng <jiapeng.chong@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1282,9 +1282,10 @@ static int damon_sysfs_scheme_add_dirs(s
 	err = damon_sysfs_scheme_set_access_pattern(scheme);
 	if (err)
 		return err;
+
 	err = damon_sysfs_scheme_set_quotas(scheme);
 	if (err)
-		goto put_access_pattern_out;
+		goto rmdir_put_access_pattern_out;
 	err = damon_sysfs_scheme_set_watermarks(scheme);
 	if (err)
 		goto put_quotas_access_pattern_out;
@@ -1311,7 +1312,8 @@ put_watermarks_quotas_access_pattern_out
 put_quotas_access_pattern_out:
 	kobject_put(&scheme->quotas->kobj);
 	scheme->quotas = NULL;
-put_access_pattern_out:
+rmdir_put_access_pattern_out:
+	damon_sysfs_access_pattern_rm_dirs(scheme->access_pattern);
 	kobject_put(&scheme->access_pattern->kobj);
 	scheme->access_pattern = NULL;
 	return err;


