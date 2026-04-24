Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FE03563D4;
	Fri, 24 Apr 2026 13:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038225; cv=none; b=NSYhMAQV28G6T2giv3u7pNVmYOsbqU4juxVJE0e5rtbQxMFrtLA76oPqe39qowEoQUYxItG8jeOyG9VKe1v93MkB1/ZZRSKaVQpqKaoH65TaXzjmA1JDPX6fcrZm1WtfPPgZLnczsDo6N/KUtN+D4DEzVVzPvGHjzBt0DJDVhLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038225; c=relaxed/simple;
	bh=6ICwo3dYVBwbPwKHWNuqsx3TizMxnoKeZZaecBVUt1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+/ugDiHkcN+xOlctqb4J9kF3v7I5WhLM5vo5BwEj++Wp5V4bIoUKCcKA5Hrw7lIbjsolDs1ge6TAsJREQlzpzX4wX4zbjBExPn8IDVhsg/NxwNiDO2XdI3aztVgIsi8HK4wMRjR9NpB9ry9YJotq5ijkd8R0/ER31etyNMf214=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROxtj1dI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROxtj1dI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8DCC19425;
	Fri, 24 Apr 2026 13:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038225;
	bh=6ICwo3dYVBwbPwKHWNuqsx3TizMxnoKeZZaecBVUt1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROxtj1dIlwS98eqWC51il/9ieWs+iaPchMLW/GiSKGLXucwuyRmo+o7IQPiBb0z3l
	 5LaOhLkuva9J9JAnYt8dogSlP6IUlsGek3aWcCcS/6dmgWBd1eZrWoi89oO+2ZCM88
	 /qQvCus2HpJkV8x3aLBkxJPV2HwBepsQhbtdPdSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bschubert@ddn.com>,
	Horst Birthelmer <hbirthelmer@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.12 17/35] fuse: Check for large folio with SPLICE_F_MOVE
Date: Fri, 24 Apr 2026 15:31:24 +0200
Message-ID: <20260424132415.293575004@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
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

From: Bernd Schubert <bschubert@ddn.com>

commit 59ba47b6be9cd0146ef9a55c6e32e337e11e7625 upstream.

xfstest generic/074 and generic/075 complain result in kernel
warning messages / page dumps.
This is easily reproducible (on 6.19) with
CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ALWAYS=y
CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ALWAYS=y

This just adds a test for large folios fuse_try_move_folio
with the same page copy fallback, but to avoid the warnings
from fuse_check_folio().

Cc: stable@vger.kernel.org
Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Signed-off-by: Horst Birthelmer <hbirthelmer@ddn.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -871,6 +871,9 @@ static int fuse_try_move_page(struct fus
 	folio_clear_uptodate(newfolio);
 	folio_clear_mappedtodisk(newfolio);
 
+	if (folio_test_large(newfolio))
+		goto out_fallback_unlock;
+
 	if (fuse_check_folio(newfolio) != 0)
 		goto out_fallback_unlock;
 


