Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EAB217723;
	Thu, 30 Jul 2026 15:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424776; cv=none; b=VdmnfCnV+yicEH6O/LCJ/1QuTxVKH3noONWaGJRXNZvJsL+JxMaQX9P/pY2dwYR58UAzLFBlCa1lF64WFyMl6c4DmoyyS6J0OcvsIVNEz8tqWkiqajyEXUJZdTU8Hwn6oNTNNhziOcZRFyCfcFZi3Ac1QNVmu52C1Wof5HWs4zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424776; c=relaxed/simple;
	bh=EnTUNUFWtId09YNMT5A+eeaif4xH9reKGy9Wr0AHeb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzt+FDPpUVdLQcknfhB/qwGOhSJZREOxqHA3gEBe2WK8cehXUW1q8mTJjJJQbJy876XCJoMTboDU0aEJTKYj8v4JzAsLEStP0QHMKRnnyixmf3SxJdpiJ7ztLqsbYR6GQ5GBpaIKhcCeTzjAVmZZi96VrDAmvduUftU1AE5PPWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knc7t4Oo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knc7t4Oo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589281F000E9;
	Thu, 30 Jul 2026 15:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424774;
	bh=4dwi7GAGSzlk6YdS2x9iLFP9M3wgCwisDjB23kxdZSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=knc7t4Ooirdm1nCTovPVyZKpbl/cR1ZkQ8uRd6zmsmNPKIjYjXZHx0QpNvCMbmkHZ
	 hbruwYKWDm2K+GzEn9A5DQzzT5vcGh8BdrZ3yL48uP6YXwIN5Z/eQ7V0DBS7lp0U83
	 UbJ132ssMe2e1r+lf0I13zW61Ecrf2ZjHLCO7rOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 513/675] ceph: fix writeback_count leak in write_folio_nounlock()
Date: Thu, 30 Jul 2026 16:14:03 +0200
Message-ID: <20260730141456.033643534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit cbf59617cd715219e84c50d106a3d0e1e8ba054e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -785,6 +785,9 @@ static int write_folio_nounlock(struct f
 				    ceph_wbc.truncate_size, true);
 	if (IS_ERR(req)) {
 		folio_redirty_for_writepage(wbc, folio);
+		if (atomic_long_dec_return(&fsc->writeback_count) <
+				CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
+			fsc->write_congested = false;
 		return PTR_ERR(req);
 	}
 
@@ -804,6 +807,9 @@ static int write_folio_nounlock(struct f
 			folio_redirty_for_writepage(wbc, folio);
 			folio_end_writeback(folio);
 			ceph_osdc_put_request(req);
+			if (atomic_long_dec_return(&fsc->writeback_count) <
+					CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
+				fsc->write_congested = false;
 			return PTR_ERR(bounce_page);
 		}
 	}
@@ -838,6 +844,9 @@ static int write_folio_nounlock(struct f
 			      ceph_vinop(inode), folio);
 			folio_redirty_for_writepage(wbc, folio);
 			folio_end_writeback(folio);
+			if (atomic_long_dec_return(&fsc->writeback_count) <
+					CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
+				fsc->write_congested = false;
 			return err;
 		}
 		if (err == -EBLOCKLISTED)


