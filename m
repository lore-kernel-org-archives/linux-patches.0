Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6461C2E0400;
	Wed, 28 Jan 2026 15:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614734; cv=none; b=QYeG4tQrE986rTMivrKS3x0ZBkz8mSN5yHX8n7PsDQ49YQhRMwks3mrbPCTPhkHSIf2hq5A6OX/e3rsX0nMZAhp5LdYB5buIERFY4Aw9k1WuOwlOPV240fsRNILMfJbwr3VQf+057WUMXNzlLL+IX1xtDKg0hwJgbMX1AjJDywY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614734; c=relaxed/simple;
	bh=tYFDxsuyl6jwFK56y4fv/bYo4uVbDtT+l0f8wRQ2ZjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFjmXqWX3fHuHTZDPs2WrwvJ7glpNf5lGPBWgXxUKaqt1stIUhkL5GKSk1fXjE5dlr1ZBgS2Ca2ij4DlXH5ENopPGMueMrDhLom8dTFwb3tqsT2Qpi7OWBt1FkmCGzzxHFYq982Kw9LB4uvOuvIHV2suk6x2wnX6IFqF3sbqvFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4DC5kJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4DC5kJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF7FC4CEF1;
	Wed, 28 Jan 2026 15:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614734;
	bh=tYFDxsuyl6jwFK56y4fv/bYo4uVbDtT+l0f8wRQ2ZjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4DC5kJUB7mQSBliNuG4l5vxIXFU8VT9fcWH8bAXdwhMRKO3U46D86h1uDRpfMbPa
	 TnwxF+yvBNEeZYaUyRPOt7HH9YRgnpZvVX73tbDoJMIqhmTs01obCjQU3AyjNWr/Xi
	 8brlAeTp13B0XZk1jrB7bTxBNPloqjOaikbbyUVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	chongjiapeng <jiapeng.chong@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 226/254] mm/damon/sysfs-scheme: cleanup quotas subdirs on scheme dir setup failure
Date: Wed, 28 Jan 2026 16:23:22 +0100
Message-ID: <20260128145352.918155485@linuxfoundation.org>
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

commit dc7e1d75fd8c505096d0cddeca9e2efb2b55aaf9 upstream.

When a DAMOS-scheme DAMON sysfs directory setup fails after setup of
quotas/ directory, subdirectories of quotas/ directory are not cleaned up.
As a result, DAMON sysfs interface is nearly broken until the system
reboots, and the memory for the unremoved directory is leaked.

Cleanup the directories under such failures.

Link: https://lkml.kernel.org/r/20251225023043.18579-4-sj@kernel.org
Fixes: 1b32234ab087 ("mm/damon/sysfs: support DAMOS watermarks")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: chongjiapeng <jiapeng.chong@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1288,7 +1288,7 @@ static int damon_sysfs_scheme_add_dirs(s
 		goto rmdir_put_access_pattern_out;
 	err = damon_sysfs_scheme_set_watermarks(scheme);
 	if (err)
-		goto put_quotas_access_pattern_out;
+		goto rmdir_put_quotas_access_pattern_out;
 	err = damon_sysfs_scheme_set_filters(scheme);
 	if (err)
 		goto put_watermarks_quotas_access_pattern_out;
@@ -1309,7 +1309,8 @@ put_filters_watermarks_quotas_access_pat
 put_watermarks_quotas_access_pattern_out:
 	kobject_put(&scheme->watermarks->kobj);
 	scheme->watermarks = NULL;
-put_quotas_access_pattern_out:
+rmdir_put_quotas_access_pattern_out:
+	damon_sysfs_quotas_rm_dirs(scheme->quotas);
 	kobject_put(&scheme->quotas->kobj);
 	scheme->quotas = NULL;
 rmdir_put_access_pattern_out:


