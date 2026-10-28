Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209469;
	b=exbNeF5TvbFUlJV/nAeNLYBiORyQVKdc39cMNP2MIho09W12d2R5MzhohhfXTDZ4JVOV
	 qInQWgk/eWbFqDKs3Gi5TuEVzFScCF4qIBdFRBXNsXK+TDyXKOho5ptvWiAW60JAy4Nkf
	 gndi5YxYwN1cqyUTjrYSxLXGtOl6zP4VYZYbUDp7jFTAPRjg1NALx3WJcvziToC/3DEEq
	 GvDY77nYCjuR2Sg6h/LfWVVSWWMpuL9z2Pritn5BdV9YNT3/hlVtcDfp8qeJL36lXMYWm
	 aOLoGzaEV+C4bTgym8Rd+8nEP6oBRheG8avo2K/P48MVE90uMQQ2+X6K4YeGcHpmejA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rS81XLq+3D3u1x54JpLVF9bW4TF1Rhve7XwDjPi7A1c=;
	b=Kn4QjqTX8j/0xAfrIwqu6dQXUpKW1kKfXOq/Vy9Ia6+nwSZNoJ3j57sNdCrEM43ln+5p
	 sHeOOeN8iSeSvsazE0L27GYfXSc0Q9H5fJ7OQP2ZImq7wnLkCimxR7iHgVnGiFUu56ePH
	 iUGEWucPjs38GoLWCmPEjCtTeCHtnQpbfU5/c7xbQ8VqNY3RMc+Xs+o3+K0Xdk8rQl2OY
	 srNAkAfA/rRtyrPc1ZEMPkxPBeZaAV6Wmwx9TaY62PlWsiy8nrA8aLSzjjDjKms27WMpU
	 oD/tXhQ1ZbyND8wKXHu+12EVYUuxmGmFhd9+58KO9mHFHOBrBNLKRuwDN4YuxIZ9pMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t8q13QrH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD67606A31A;
	Wed, 28 Oct 2026 17:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t8q13QrH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE421F01825;
	Wed, 28 Oct 2026 17:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209469;
	bh=rS81XLq+3D3u1x54JpLVF9bW4TF1Rhve7XwDjPi7A1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t8q13QrHOAPUqKuOgji3u/h6VeFBfcRkl3m02I5XYKfaxqmKO94a9jYJeGtCTLbxP
	 CRHk5T+UtD/MPkdfnvHCJFDmBrQvhNTI02atZXPu72vdcgUktli0dRl+AdrQH+lqQ3
	 uM3Ymx9W66rZqOgu/yBeRmD0sYXj0Z/8QIvki6aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dingisoul <dingiso.kernel@gmail.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 483/516] scsi: st: Fix use-after-free race between st_remove() and st_open()
Date: Wed, 28 Oct 2026 18:00:35 +0100
Message-ID: <20261028170014.920587022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ loberman: st_remove() still returns int in 5.10; context adjusted ]
Signed-off-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index ad1092d0c44ab..566dec22b5326 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4493,11 +4493,11 @@ static int st_remove(struct device *dev)
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



