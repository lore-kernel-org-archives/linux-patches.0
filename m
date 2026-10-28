Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217074;
	b=M6HhL+hyYr130O6N/YouLCn5lzRkBEYFot5nmHo3turNT2P868lbIE3f3iVHiWq1Do4/
	 nRqYlwLbWxXla/AMzmX5VVuJIOdH9y4bi0xjFGuB8MNVizwBw2NBMntcp4X5vSJTygTqW
	 id744O/NH5C5rle8knK3SsYgozhYFTl3LXLiqvZLmfr69aqx9Vwb0kzQ+R4sqVlokRl5O
	 g76Ee4jqM4+KB5vqogP3qofdnAetAxLv2vXL7ldUboMY602mxVpnSoMbubSENCjFMre0o
	 MyHzQZtoh8Pf8fjo7XtZJ/gPVjJ34eA7U9l9ziA/QHujLONOC88GOT1mbXPcEe4Edng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gVzwXwbrqST5aunlwSDNjjOJq1YfAs+2Ah2x21H5Ols=;
	b=LQYplGbCWmw40j36MHmWYVi0isJ+N1zM/Caylk/FlH6C4riTXaEC4NDRsi2XWp98EX+L
	 WpW5VcdTOV4eSfJ9z2ZSmC7dMV1ZlKwAxpH41kbbFxxmaAFaRR5c7PeXn0PRsLY/PeVgF
	 MbX0G/I6ATOZBmLXTdMEdr9bdNNiqGjtg6CrGK1ysJbA6mn3fqxYuZpBITB/VpKJzqZgi
	 K7qeDYEuGT6jTAMgrYiQECnE9F6Ta9NZHHYWrJs35OIRAmxHZFSXJThkivhlyLIC0inOi
	 XOnV/8E2v1cVERspeUoRuP710wywa7F86Bp2b5qPTjFTNvKFs4E16XlFC3II1X+mKgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ieEgd8o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E010606A31A;
	Wed, 28 Oct 2026 19:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ieEgd8o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9869C1F01825;
	Wed, 28 Oct 2026 19:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217074;
	bh=gVzwXwbrqST5aunlwSDNjjOJq1YfAs+2Ah2x21H5Ols=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ieEgd8o89RcWMAtqjCRMRWr6kLMY/TZaHmdKA+R4zzOfkls8edk+HcN9g6iukqav
	 wSwihb4Kb+mQF0QUvmV+hzBWKs/nUUArDmNkLyKh+SAlRsEQl6ZHVVWsKrsX9HaZHU
	 L623898gCrZmc2jx2w+XWupyDtfCSEKyOJGZ/Gfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dingisoul <dingiso.kernel@gmail.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1777/1887] scsi: st: Fix use-after-free race between st_remove() and st_open()
Date: Wed, 28 Oct 2026 18:04:33 +0100
Message-ID: <20261028170539.889687335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurence Oberman <loberman@redhat.com>

commit 71caf7f84bd62a4bf91cc95abd2de690afb8d15f upstream.

st_remove() drops the probe reference on the scsi_tape with kref_put()
and only afterwards removes its index from st_index_idr. If that was the
last reference, scsi_tape_release() frees the structure while it is
still published in the idr.

scsi_tape_get(), called from st_open(), looks up the tape in
st_index_idr and takes a reference under st_ref_mutex and
st_index_lock. remove_cdevs() does not wait for opens that are already
past chrdev_open(), so an open that is blocked on st_ref_mutex while
st_remove() holds it can take the mutex as soon as st_remove() drops it,
find the freed tpnt in the idr and call kref_get() on it:

  BUG: KASAN: slab-use-after-free in st_open
  Write of size 4 ...
   st_open (drivers/scsi/st.c:254 drivers/scsi/st.c:1291)
   chrdev_open
  ...
  Freed by task ...:
   kfree
   st_remove (drivers/scsi/st.c:4512)

Remove the index from the idr before dropping the reference, all under
st_ref_mutex. A concurrent scsi_tape_get() now either runs first and
holds a valid reference that keeps the tape alive, or runs afterwards
and finds nothing, so st_open() fails with -ENXIO.

This restores the ordering st_remove() had before the conversion to
st_index_idr, where the tape was unpublished from scsi_tapes[] before
the final kref_put().

Fixes: 6c648d95a6af ("[SCSI] st: get rid of scsi_tapes array")
Cc: stable@vger.kernel.org
Reported-by: Dingisoul <dingiso.kernel@gmail.com>
Closes: https://lore.kernel.org/linux-scsi/20261007211520.1428497-1-dingiso.kernel@gmail.com/
Tested-by: Dingisoul <dingiso.kernel@gmail.com>
Signed-off-by: Laurence Oberman <loberman@redhat.com>
Link: https://patch.msgid.link/20261013202548.249628-1-loberman@redhat.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ loberman: st_remove() still returns int in 6.1; context adjusted ]
Signed-off-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 8f406eabef63f..2ad1703240e43 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4440,11 +4440,11 @@ static int st_remove(struct device *dev)
 	remove_cdevs(tpnt);
 
 	mutex_lock(&st_ref_mutex);
-	kref_put(&tpnt->kref, scsi_tape_release);
-	mutex_unlock(&st_ref_mutex);
 	spin_lock(&st_index_lock);
 	idr_remove(&st_index_idr, index);
 	spin_unlock(&st_index_lock);
+	kref_put(&tpnt->kref, scsi_tape_release);
+	mutex_unlock(&st_ref_mutex);
 	return 0;
 }
 
-- 
2.53.0



