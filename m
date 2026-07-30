Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED5D435AB0;
	Thu, 30 Jul 2026 14:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422993; cv=none; b=YGX5OJ7NKKuwzBPoig4Mo5oXzb87z9zcqeOfxPbwkLNGiTc1Po9FAqM0x9JeHXxA8pwOw/swNfe9RWHEVSfbV5HDDRLF03wEVkHi8IfNvbg66oCNUSQETA0p1uxuDAEIMkZurmPY+yYQpkXLtWzlTMgqxUdgqMKqSTXXfJ0ls6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422993; c=relaxed/simple;
	bh=aK/EU0oLd4Nc0Hsm1DD0c25b5JKUqIACTe77DDAgiJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBc7NEjA1gLeVdn4UmW6tgIewiR8UTCeZ/nuK2v1CH7hnM53HoTwioQ1aNOrphD8ZUcysOY5d7MAFpmXz7g+y286IPoMiZy+1Hhwh6oHILKjn2RdfKqhJVhj0eO66a/afz38vQdd1NXdY2N6R9BUjFsDQtx8odEYmVabU8A1J9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKWxZCs0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKWxZCs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A6B1F00A3D;
	Thu, 30 Jul 2026 14:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422992;
	bh=6TcDBdkqv5SL/kjMAW3wdMnGhro7T76t7Y1Q99jmAJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bKWxZCs0E5JMhhsmW5T7yOl5zhmxociPs84zq+K4ne9Enl2Etnli9vLJ0eO2jyPU7
	 3LKubr0RbkmzoxvbB2cd2R23MDK793NqWKizv8MBPAITPmlT1rqsaby/wyXhTj1s1P
	 0DI9A+NtRGejg7BjP0xp0TDg1EpKeoIbHxkVDiCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.1 628/744] ceph: fix writeback_count leak in write_folio_nounlock()
Date: Thu, 30 Jul 2026 16:15:01 +0200
Message-ID: <20260730141457.623651926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -790,6 +790,9 @@ static int write_folio_nounlock(struct f
 				    ceph_wbc.truncate_size, true);
 	if (IS_ERR(req)) {
 		folio_redirty_for_writepage(wbc, folio);
+		if (atomic_long_dec_return(&fsc->writeback_count) <
+				CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
+			fsc->write_congested = false;
 		return PTR_ERR(req);
 	}
 
@@ -809,6 +812,9 @@ static int write_folio_nounlock(struct f
 			folio_redirty_for_writepage(wbc, folio);
 			folio_end_writeback(folio);
 			ceph_osdc_put_request(req);
+			if (atomic_long_dec_return(&fsc->writeback_count) <
+					CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
+				fsc->write_congested = false;
 			return PTR_ERR(bounce_page);
 		}
 	}
@@ -847,6 +853,9 @@ static int write_folio_nounlock(struct f
 			      ceph_vinop(inode), folio);
 			folio_redirty_for_writepage(wbc, folio);
 			folio_end_writeback(folio);
+			if (atomic_long_dec_return(&fsc->writeback_count) <
+					CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
+				fsc->write_congested = false;
 			return err;
 		}
 		if (err == -EBLOCKLISTED)


