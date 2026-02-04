Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971E01E520C;
	Wed,  4 Feb 2026 15:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218017; cv=none; b=jawUXIi7ZRZP7twGdjfF/8RMWH1bEG5WZX/SWz1YOZ6XFLqlcUrAYXj0kTtiAFlORoQU4s5yDUtajodNL8Xx3BeW/7x3/lBNqL7tnHu2Qqid5YfGrFG6C3K/nP2ftiuyplWzHKhPdOfBOhJppfd6+BbKblM1ryZb50mo5UWQInM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218017; c=relaxed/simple;
	bh=MePvG+Y2haXsgEMh/99ZKY56FrL3iDCNXhsUSRy0blY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AljcDUDhTSsQmLtKqWELTKYo9IleYDnE1x3Cc4MDxb3RuJXFIkqv3vQfJFVmXLSyVGxUl25E177KH93bcAWs1jnCL1Mb/s9z1RYvWJvO77EtaAv9/Bau+wMudxlL/GS4ds6sd5W7juJEwMPTJzpBTgrKVNXd+b7lgU8cwNMWwrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CY+M6oup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CY+M6oup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D75C116C6;
	Wed,  4 Feb 2026 15:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218017;
	bh=MePvG+Y2haXsgEMh/99ZKY56FrL3iDCNXhsUSRy0blY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CY+M6oupHfR/eQpvtdbnw/GQKiqaaILVQqmOcvDiEksl+VDIENrXYIIYln6BakoUB
	 DIVdefsIwZZi+K7oC3w/bvr6Wzrkx6JK2iTA4M5WGUjf254/tXTFmUu959vICM/H/v
	 Ehloo8aQQljwsjURn2q6xYh8eoHYGtjofG5Xi+hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	chongjiapeng <jiapeng.chong@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 187/280] mm/damon/sysfs-scheme: cleanup access_pattern subdirs on scheme dir setup failure
Date: Wed,  4 Feb 2026 15:39:21 +0100
Message-ID: <20260204143916.340652433@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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
 mm/damon/sysfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -856,7 +856,7 @@ static int damon_sysfs_scheme_add_dirs(s
 		return err;
 	err = damon_sysfs_scheme_set_quotas(scheme);
 	if (err)
-		goto put_access_pattern_out;
+		goto rmdir_put_access_pattern_out;
 	err = damon_sysfs_scheme_set_watermarks(scheme);
 	if (err)
 		goto rmdir_put_quotas_access_pattern_out;
@@ -872,7 +872,8 @@ rmdir_put_quotas_access_pattern_out:
 	damon_sysfs_quotas_rm_dirs(scheme->quotas);
 	kobject_put(&scheme->quotas->kobj);
 	scheme->quotas = NULL;
-put_access_pattern_out:
+rmdir_put_access_pattern_out:
+	damon_sysfs_access_pattern_rm_dirs(scheme->access_pattern);
 	kobject_put(&scheme->access_pattern->kobj);
 	scheme->access_pattern = NULL;
 	return err;


