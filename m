Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B161376BDD;
	Wed, 21 Jan 2026 18:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019924; cv=none; b=hhZmG6xLQSeHUk+W5i8i230ENC9PONGTOhSum2ayeQWl6DQXltgXb1GL9TtdNA/27FfMBvSSFrZnXDpFnpUqhT1O5hDnFBJphiRBIaZwZDVFFl2wdrgVxoJJSpx13YvRvgvYuxXge9JdqRqt3JFDpHpbBAYUOenkuJtVt2j/Cek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019924; c=relaxed/simple;
	bh=mvDGC9eLIutqvzGzDiBiPRZ55WZnqC/dxY0jwu3aV2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DC5SKcRIMa+SIAb32prRTw0sYS3KPv6lKXSYZAY1LfNP5R8kRc+A2e3AjAwXW9bmhL17+ZK2QsDuL8g6H1iTXJGVT2I2j158Fjanzr/SVoEt0FYo3Pwo7ZvT3U9+7Bp1fW4ilcFgvma8DMc6EUE8EbRgBVbl+CxmzfqZ4Wd2Wxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcgrPPza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcgrPPza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699CDC4CEF1;
	Wed, 21 Jan 2026 18:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019923;
	bh=mvDGC9eLIutqvzGzDiBiPRZ55WZnqC/dxY0jwu3aV2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcgrPPzaGZ5LNOLrZ82/zTTdQqOohsGEoE2at6RpR3QYGE5dJdX5/bj79BwrMc0Tw
	 IOmQ1qXRceBVaIN7IaoPRUaRcVJrqwPgFmKrKmLuCd2+QRVALw8eSBIf46TkyVGoNn
	 ypP1crx54kL4hv2iokg3sO4fbiB7tac0tT2vPBGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	chongjiapeng <jiapeng.chong@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 127/139] mm/damon/sysfs-scheme: cleanup access_pattern subdirs on scheme dir setup failure
Date: Wed, 21 Jan 2026 19:16:15 +0100
Message-ID: <20260121181416.023355727@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 mm/damon/sysfs-schemes.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1606,7 +1606,7 @@ static int damon_sysfs_scheme_add_dirs(s
 		return err;
 	err = damon_sysfs_scheme_set_quotas(scheme);
 	if (err)
-		goto put_access_pattern_out;
+		goto rmdir_put_access_pattern_out;
 	err = damon_sysfs_scheme_set_watermarks(scheme);
 	if (err)
 		goto rmdir_put_quotas_access_pattern_out;
@@ -1634,7 +1634,8 @@ rmdir_put_quotas_access_pattern_out:
 	damon_sysfs_quotas_rm_dirs(scheme->quotas);
 	kobject_put(&scheme->quotas->kobj);
 	scheme->quotas = NULL;
-put_access_pattern_out:
+rmdir_put_access_pattern_out:
+	damon_sysfs_access_pattern_rm_dirs(scheme->access_pattern);
 	kobject_put(&scheme->access_pattern->kobj);
 	scheme->access_pattern = NULL;
 	return err;


