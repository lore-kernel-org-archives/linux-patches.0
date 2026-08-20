Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAEF415B60;
	Thu, 20 Aug 2026 17:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787246999; cv=none; b=f21efkz5qHvHZ5hiTiLGbxONRGDAYHa+NtmsseosJvWtw86Af2y5mePvmHsdmyp+799hi/wuu8yBDWO6dODhsWNV0R3+tnQ0FzXqNbi75vL96ABZLQB4RAMsEYHQ9GsEejIk5X7WPKAO6dWqej3IWFGf0gxJLRBZaqm5JiWdi20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787246999; c=relaxed/simple;
	bh=gJQ7Zt6KazqRfhGfk+kEnqiKN07KsD4N5xUiPjySmlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qts201P5JJb7JgblIa4VBtvs160t2/81Prl+ZvGtuq15fpDr+8HECix4xNjynv+34w8/uGVzaALBfNASX7bzTa30gEULAPSjLRi6bqlGEzZELSQ66K/pjR6Ywo29svs0eppb0RSpltpSAFVe/TMT2ByC+lfvn9XbLT9ebuk6syo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hy+QUD4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hy+QUD4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053051F000E9;
	Thu, 20 Aug 2026 17:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787246998;
	bh=S1rrw6KQBTsuIEMOwr+9FyLEjueJ+kPXcLfPk6xZXA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hy+QUD4fKjUzDz+RzHK5E7vsY8H0Hso4Lj3czvRA98wA68ype5K2kOVY2QgYZm+eE
	 i6FzygMBK0oJVqlQDRuRnLRlAjlkCbgGw0ovEssG/phe7ZqOd1eyL12DpGUvJZuuLY
	 ulP+/BdDjfrKXmXA2pDXpbSazGQuEpVGTIIaDls4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/220] ceph: fix writeback_count leak in write_folio_nounlock()
Date: Thu, 20 Aug 2026 16:55:05 +0200
Message-ID: <20260820145226.931731273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit cbf59617cd715219e84c50d106a3d0e1e8ba054e ]

write_folio_nounlock() increments fsc->writeback_count to track
in-flight writeback operations. On several error paths where the
function returns early (folio lookup failure, snapshot context
allocation failure, and writepages submission failure), the function
returns without calling atomic_long_dec_return() to decrement the
counter.

Each leaked increment keeps the counter above zero, which can prevent
the filesystem from cleanly unmounting or suspending writes.

Add atomic_long_dec_return() calls on all error paths that currently
return without decrementing the counter.

Cc: stable@vger.kernel.org
Fixes: d55207717ded ("ceph: add encryption support to writepage and writepages")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -746,6 +746,9 @@ static int write_folio_nounlock(struct f
 				    ceph_wbc.truncate_size, true);
 	if (IS_ERR(req)) {
 		folio_redirty_for_writepage(wbc, folio);
+		if (atomic_long_dec_return(&fsc->writeback_count) <
+				CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
+			fsc->write_congested = false;
 		return PTR_ERR(req);
 	}
 
@@ -765,6 +768,9 @@ static int write_folio_nounlock(struct f
 			folio_redirty_for_writepage(wbc, folio);
 			folio_end_writeback(folio);
 			ceph_osdc_put_request(req);
+			if (atomic_long_dec_return(&fsc->writeback_count) <
+					CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
+				fsc->write_congested = false;
 			return PTR_ERR(bounce_page);
 		}
 	}
@@ -799,6 +805,9 @@ static int write_folio_nounlock(struct f
 			      ceph_vinop(inode), folio);
 			folio_redirty_for_writepage(wbc, folio);
 			folio_end_writeback(folio);
+			if (atomic_long_dec_return(&fsc->writeback_count) <
+					CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
+				fsc->write_congested = false;
 			return err;
 		}
 		if (err == -EBLOCKLISTED)


