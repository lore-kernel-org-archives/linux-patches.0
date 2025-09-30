Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A88F266B65;
	Tue, 30 Sep 2025 15:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244852; cv=none; b=HxOGMtF/M9urK5fJZhhw4tbPaPfWjIhJh2roU1Jlt4Di1KwXqxtQYV8UjMIvO0+kQ2DggWL+vN6x8L3qzK1CP4ZMWidZ/WPCNgHlDN7Is5BN0syeqVicKnqlvr5HFhQ0M7PF5sYwoujiihw4bqgarPoGlvigTg7uzkQYxRgoFJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244852; c=relaxed/simple;
	bh=Rh46yUW3hSmqLdjZD5Ap6sBHwOcnZDlVPUA+NpqIwP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTYBxDVkNBkDCmw+vdWgfyIvBm33SQHswudx8VdYoNQwppmY9RJViYzzv+6MyEhMgpk6in8qdcA27T6Sfk5cFMbJFW/1yx+c5Zz4Kuoz4XqoBYroTFQx66/t7A1CCVKlPq/REs+mKEvnhSpvsoNlnPDmbzEE95xoHH7sI0unyYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXaccJEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXaccJEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0433EC113D0;
	Tue, 30 Sep 2025 15:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244852;
	bh=Rh46yUW3hSmqLdjZD5Ap6sBHwOcnZDlVPUA+NpqIwP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXaccJEalUzcjR4tRylFti+ZsSxXT1dhx9sEpy3PVmCv536D2jT4anW6tW2iB/r6Z
	 POFa1jze4jjXFLUg6yCxVRKRI9aG1+BjLHkdwigIw5LELB9WNorAdOxl9yDyZNAy6m
	 5iu3ci6acFtetvAdiLvKBGe4Q4PgWVZXRZA9lrNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akinobu Mita <akinobu.mita@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 134/143] mm/damon/sysfs: do not ignore callbacks return value in damon_sysfs_damon_call()
Date: Tue, 30 Sep 2025 16:47:38 +0200
Message-ID: <20250930143836.571248708@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akinobu Mita <akinobu.mita@gmail.com>

commit 06195ee967d06ead757f9291bbaf1a0b30fa10b8 upstream.

The callback return value is ignored in damon_sysfs_damon_call(), which
means that it is not possible to detect invalid user input when writing
commands such as 'commit' to
/sys/kernel/mm/damon/admin/kdamonds/<K>/state.  Fix it.

Link: https://lkml.kernel.org/r/20250920132546.5822-1-akinobu.mita@gmail.com
Fixes: f64539dcdb87 ("mm/damon/sysfs: use damon_call() for update_schemes_stats")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1576,12 +1576,14 @@ static int damon_sysfs_damon_call(int (*
 		struct damon_sysfs_kdamond *kdamond)
 {
 	struct damon_call_control call_control = {};
+	int err;
 
 	if (!kdamond->damon_ctx)
 		return -EINVAL;
 	call_control.fn = fn;
 	call_control.data = kdamond;
-	return damon_call(kdamond->damon_ctx, &call_control);
+	err = damon_call(kdamond->damon_ctx, &call_control);
+	return err ? err : call_control.return_code;
 }
 
 struct damon_sysfs_schemes_walk_data {


