Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8693D29ACDD;
	Thu, 15 Jan 2026 17:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496480; cv=none; b=h5VgG/UjtEWmLuGJ0HALvDFt0vQXJsRjOhwXMVymXk8scTd0aGAt/o6Eh56romENbEEkZze52H5XndNTuNczZRS6ZjRiB2th+0ssGEvS4BDNK1QTBXBN3OUCIMtSzpRQoZdklB7FuEexk4bsy+JS7hyIRTyt/lf3fM+cAbGmkpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496480; c=relaxed/simple;
	bh=pr1bQ4pEij7MjkTRKFQo99aQ6QUECN4sYl33NxMBfSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keJz+eb9UmAEGT50Q/uiopPCQ1FCo0hG0gCZoMxzkg8xHUaUdKCuoCPBnCgTfNJ5yCbfnLuzONZagORf+Zh8OCyg2qFJTv6dtPddYEjFJMchGYHoVUaKfF8m01mH2k/2V/SVTQxnvwTkLNoO4Xs7C+u33xsgWD/oY8lsi18qCzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KiPpP/wY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KiPpP/wY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A820C116D0;
	Thu, 15 Jan 2026 17:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496480;
	bh=pr1bQ4pEij7MjkTRKFQo99aQ6QUECN4sYl33NxMBfSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KiPpP/wYBkXaqTSzRfMv2OqD2WJnCekQrtNj9VTnE0XpN7mUQnzprOILBRpPpG9r/
	 Yt7Z0sjXiN3tPvHJ+k/j2SSY6xxugekKTbjAyqbgsZBzaWWgIcQ/0i2vAhC3T0GPU5
	 rWrw0dv6dAoPSs69lOw1rcuJ2gZfSLTEUewBib/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 6.12 027/119] libceph: make calc_target() set t->paused, not just clear it
Date: Thu, 15 Jan 2026 17:47:22 +0100
Message-ID: <20260115164152.942070458@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Ilya Dryomov <idryomov@gmail.com>

commit c0fe2994f9a9d0a2ec9e42441ea5ba74b6a16176 upstream.

Currently calc_target() clears t->paused if the request shouldn't be
paused anymore, but doesn't ever set t->paused even though it's able to
determine when the request should be paused.  Setting t->paused is left
to __submit_request() which is fine for regular requests but doesn't
work for linger requests -- since __submit_request() doesn't operate
on linger requests, there is nowhere for lreq->t.paused to be set.
One consequence of this is that watches don't get reestablished on
paused -> unpaused transitions in cases where requests have been paused
long enough for the (paused) unwatch request to time out and for the
subsequent (re)watch request to enter the paused state.  On top of the
watch not getting reestablished, rbd_reregister_watch() gets stuck with
rbd_dev->watch_mutex held:

  rbd_register_watch
    __rbd_register_watch
      ceph_osdc_watch
        linger_reg_commit_wait

It's waiting for lreq->reg_commit_wait to be completed, but for that to
happen the respective request needs to end up on need_resend_linger list
and be kicked when requests are unpaused.  There is no chance for that
if the request in question is never marked paused in the first place.

The fact that rbd_dev->watch_mutex remains taken out forever then
prevents the image from getting unmapped -- "rbd unmap" would inevitably
hang in D state on an attempt to grab the mutex.

Cc: stable@vger.kernel.org
Reported-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1611,6 +1611,7 @@ static enum calc_target_result calc_targ
 	struct ceph_pg_pool_info *pi;
 	struct ceph_pg pgid, last_pgid;
 	struct ceph_osds up, acting;
+	bool should_be_paused;
 	bool is_read = t->flags & CEPH_OSD_FLAG_READ;
 	bool is_write = t->flags & CEPH_OSD_FLAG_WRITE;
 	bool force_resend = false;
@@ -1679,10 +1680,16 @@ static enum calc_target_result calc_targ
 				 &last_pgid))
 		force_resend = true;
 
-	if (t->paused && !target_should_be_paused(osdc, t, pi)) {
-		t->paused = false;
+	should_be_paused = target_should_be_paused(osdc, t, pi);
+	if (t->paused && !should_be_paused) {
 		unpaused = true;
 	}
+	if (t->paused != should_be_paused) {
+		dout("%s t %p paused %d -> %d\n", __func__, t, t->paused,
+		     should_be_paused);
+		t->paused = should_be_paused;
+	}
+
 	legacy_change = ceph_pg_compare(&t->pgid, &pgid) ||
 			ceph_osds_changed(&t->acting, &acting,
 					  t->used_replica || any_change);


