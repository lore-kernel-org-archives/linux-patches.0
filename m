Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828998;
	b=JsKXYrJjHP1tf1gT9MjX2dER4gwl6SEPV9Vj/KvaPKuzRMdxbErdMfI2VD7+y+8sJePg
	 Q7mpblBMNReiTDo4ZHScoa1/7palnPhPNmXzvk65ff5x4EOAgjthyDAgLvJx0utEXK1Ss
	 5vy/FFeGqldFuiA8Y2grG+TiWG6eVDX3sWiBA9z9HMf3Ue5ZS+Y1/xfThvDvC03Jymljc
	 TxTKsljtk/Eoc+0R/12tVwRltfzlL0PI7B3LFTAkS/rUdDV7FQ3IAe2Jom8yda2uNjI41
	 L42DDkS5mL9IA7Ip4tU3bK4ga9MJ9UiX4QDtYo4eq78GGa9ittUKRYwCMPrYvrlommQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DpP9Mz4ooe+mOgfCIB0JuF7rJ/Q56krdq0HtGjijs14=;
	b=PSIJBRxFLWgNVoXN2DryWiktqaeYsw//wkMhOa5qcymMoKMuDBA4jSlnZSyX4gBjSW1Q
	 ZUETDpSfFF7jW1FleIcJ+zCC5yHd1BMVvroyNAhiVmC/SOUPat3dl5L/UDo/0kqm0rkBM
	 Kb5t2nAkG7v101yKec41SbUHR4MIVhpoPU2yznqn3QQlRmq3pq3o5VM7b950ju8yvSzAG
	 6vZWjw3c6Cexte5DIbESPxQzOsGyFQxcZZCV/iS5mjLX8tgVhBjSkpNPhVLTN8slo+GYC
	 TGRlGiEsM6MRZ+As6aWImMKT+NVet2yL2meLdqo52vEzb31e0qKDvlLA3apxW6M8gSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hKity900;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95883607F2A2;
	Wed,  4 Nov 2026 21:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hKity900
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB271F00A15;
	Wed,  4 Nov 2026 21:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828998;
	bh=DpP9Mz4ooe+mOgfCIB0JuF7rJ/Q56krdq0HtGjijs14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKity900lqxJoqeyX+2E2UZnQtlHSlGL6iMof32EUZybcKrVRnSbqrYOMTTsoHItz
	 a226yLY1kBLUkD5hQ0H/OxOugi0Je6cVty6Kdze+wwLEUc4t4uPHRbasWyQmJUSSQP
	 uAdrahLDaaUk8rrdXDCa87KqCK5h5kWEQ1yRdxUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.3 378/547] smb: client: dont resurrect an exiting tcon from cached dir workers
Date: Wed,  4 Nov 2026 16:09:22 -0500
Message-ID: <20261104211049.038905861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit d58e7b40908a8a57755811d5b37af1df3380278f upstream.

cfids_laundromat_worker() bumps tcon->tc_count for every expired open
cfid and queues cached_dir_offload_close() without checking whether the
tcon is already being torn down.  Racing with the final cifs_put_tcon(),
the tcon comes back from zero and gets torn down twice:

  T1                                  T2
  cifs_put_tcon()
   --tc_count == 0, TID_EXITING
   tconInfoFree()
    free_cached_dirs()
     cancel_delayed_work_sync()       cfids_laundromat_worker()
                                       ++tc_count == 1
                                       queue_work(serverclose_wq)
    kfree(tcon->origin_fullpath)
    kfree(tcon)
                                      cached_dir_offload_close()
                                       close_cached_dir()  [UAF]
                                       cifs_put_tcon()
                                        tconInfoFree()     [double free]

cached_dir_lease_break() also bumps tc_count without tc_lock, racing with
the laundromat's locked update.

Take the tcon reference through a helper that refuses once the tcon is
TID_EXITING or its refcount has dropped to zero.  Queued put_work and
close_work then always hold a tcon reference, so tconInfoFree() can't
run before they finish and free_cached_dirs() doesn't need to flush any
workqueue.  If the laundromat can't get a reference, put the cfid back on
the dying list for free_cached_dirs() to free; its handle goes away with
the tree connection.

The lease break path finds the tcon on ses->tcon_list under
cifs_tcp_ses_lock, so it can't see TID_EXITING, but it now takes tc_lock.

Fixes: 3fa640d035e5 ("smb: During unmount, ensure all cached dir instances drop their dentry")
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -649,6 +649,17 @@ void invalidate_all_cached_dirs(struct c
 		flush_delayed_work(&cfids->laundromat_work);
 }
 
+static bool cached_dir_get_tcon(struct cifs_tcon *tcon,
+				enum smb3_tcon_ref_trace trace)
+{
+	guard(spinlock)(&tcon->tc_lock);
+	if (tcon->status == TID_EXITING || tcon->tc_count <= 0)
+		return false;
+	++tcon->tc_count;
+	trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count, trace);
+	return true;
+}
+
 static void
 cached_dir_offload_close(struct work_struct *work)
 {
@@ -693,6 +704,9 @@ bool cached_dir_lease_break(struct cifs_
 		    !memcmp(lease_key,
 			    cfid->fid.lease_key,
 			    SMB2_LEASE_KEY_SIZE)) {
+			if (!cached_dir_get_tcon(tcon,
+						 netfs_trace_tcon_ref_get_cached_lease_break))
+				break;
 			cfid->has_lease = false;
 			cfid->time = 0;
 			/*
@@ -703,9 +717,6 @@ bool cached_dir_lease_break(struct cifs_
 			cfid->on_list = false;
 			cfids->num_entries--;
 
-			++tcon->tc_count;
-			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
-					    netfs_trace_tcon_ref_get_cached_lease_break);
 			queue_work(cfid_put_wq, &cfid->put_work);
 			spin_unlock(&cfids->cfid_list_lock);
 			return true;
@@ -813,12 +824,13 @@ static void cfids_laundromat_worker(stru
 		cfid->dentry = NULL;
 
 		if (cfid->is_open) {
-			spin_lock(&cfid->tcon->tc_lock);
-			++cfid->tcon->tc_count;
-			trace_smb3_tcon_ref(cfid->tcon->debug_id, cfid->tcon->tc_count,
-					    netfs_trace_tcon_ref_get_cached_laundromat);
-			spin_unlock(&cfid->tcon->tc_lock);
-			queue_work(serverclose_wq, &cfid->close_work);
+			if (cached_dir_get_tcon(cfid->tcon,
+						netfs_trace_tcon_ref_get_cached_laundromat)) {
+				queue_work(serverclose_wq, &cfid->close_work);
+				continue;
+			}
+			scoped_guard(spinlock, &cfids->cfid_list_lock)
+				list_add_tail(&cfid->entry, &cfids->dying);
 		} else
 			/*
 			 * Drop the ref-count from above, either the lease-ref (if there


