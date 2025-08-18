Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C034335BA9;
	Mon, 18 Aug 2025 13:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524484; cv=none; b=sRWFr7AmQIRIUJUYVCn05onQoKkwLh3lPGVJO/wmdCsu+uuy7IoaJRIMVE4kXznrKfKdP+dZNapcPvC9msUAk2qlRZ6RuWnBMhel7ohsIpHlY8UFxAkx1YsIpmNJj+4Q9O3moWWI6BLKHARBknmY1fNkL1R4uz13+RnAq/cqiZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524484; c=relaxed/simple;
	bh=SkVwGIOAIr7m8FlQyYs6X5suepNzUJ94o+kx7z0nuDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+ip2mXYY1GiYM+2Ub1jw8+Hww9V2+MqMuBZWPMBU0w7M8c4pU/8CXnTFdCjurXStdU2PJGBnJzRmz+4pcgGl6YYsl7ArOWT5s7YVLCd6aaU6n4BZAY+9FH2Xl5pgGbXWs50uePRZoSetD6vfCDjPDEcCYCQxp0wsT8rTO+M9/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VovXalm1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VovXalm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92095C116B1;
	Mon, 18 Aug 2025 13:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524484;
	bh=SkVwGIOAIr7m8FlQyYs6X5suepNzUJ94o+kx7z0nuDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VovXalm1fTAzAoxK8DUIjylM+zq1bn4uMxQI/GlqZPcmfSIIq32UK+sJlfnZnv832
	 aNiOnPkwWJtGYH/IxikMOXIEHdr1/5cED8p8pNovgJpqdRtLBlS6kLlqX3LMXQ7JVL
	 80VNZKzqwXJQm6HQE+BWgCOemgmXuNy9HX+XzK8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c2ea94ae47cd7e3881ec@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 486/515] ocfs2: reset folio to NULL when get folio fails
Date: Mon, 18 Aug 2025 14:47:52 +0200
Message-ID: <20250818124517.134425129@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

commit 2ae826799932ff89409f56636ad3c25578fe7cf5 upstream.

The reproducer uses FAULT_INJECTION to make memory allocation fail, which
causes __filemap_get_folio() to fail, when initializing w_folios[i] in
ocfs2_grab_folios_for_write(), it only returns an error code and the value
of w_folios[i] is the error code, which causes
ocfs2_unlock_and_free_folios() to recycle the invalid w_folios[i] when
releasing folios.

Link: https://lkml.kernel.org/r/20250616013140.3602219-1-lizhi.xu@windriver.com
Reported-by: syzbot+c2ea94ae47cd7e3881ec@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c2ea94ae47cd7e3881ec
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/aops.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1071,6 +1071,7 @@ static int ocfs2_grab_folios_for_write(s
 			if (IS_ERR(wc->w_folios[i])) {
 				ret = PTR_ERR(wc->w_folios[i]);
 				mlog_errno(ret);
+				wc->w_folios[i] = NULL;
 				goto out;
 			}
 		}


