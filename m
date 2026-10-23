Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774746;
	b=x4PzvpSKjwcorTNuMRHVNhQOFUoLI5otbM/dtH/nwWWldu4uSrTIlLryv8Z3e+hrne6C
	 GomTvtDG/TLxPnwvQd4OXfvOzjIicYhk9TbhY0RxKNkUrUCEcOrwi6bUR8PwhqKusX7Kr
	 YnIKOwrV/cPIB56ROkYvEazvcPH7RpW7GA/gensBkQumDHssJ9rBw0RTHF9lKD0ZKWocF
	 qp76pwmSLF8hKC3LUq7TmTMbjOM4zbsxtE0Brxn8xZj0Rz8HpY1sF6Xsk9hWtzu1NrAQR
	 5cbimT/MB5IBTjUNrlLCuSOW4M4iBTZWqtKJpXnwDZiXtWaBEI5IrticiTpsYfWgA3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T027lGoTuOL7jKhBMZvzlAuYIVuWSSYdVxbhyh94HkQ=;
	b=rSRfmIrDxOCo+qdNlBuSWczK9GOFsbx95F0MF5dtLbu2QC6XNyweKpw3CIP/XJUvn6zT
	 am8H2lj2sUQPc4kxUoLTgLBNqo21/oFMZeQxRaRa4mNutqdEFqVTeOFS5p62yPt3AvBaa
	 ViAw1pcmetpwS1TCKtlsbhi5G8s9PI4lSOLu/ObN3nWNyvm1qQs94mQAL5rQaZlZ5k6N2
	 D+WcqvQyRRZGAapcB8T5vcv4FFCBKSl9C9GJdhgN/ognOezB+a2D6vsGR6XpaF3xgQX1l
	 OOg1iwC0xJQM1MtTza8s8MUr6NL/lz0RoYwwFBAAA+ynqv4Dy6DAh/bv8tibAm9oPYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rXsvFnjx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BB1606A31B;
	Fri, 23 Oct 2026 16:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rXsvFnjx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EA41F01825;
	Fri, 23 Oct 2026 16:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774745;
	bh=T027lGoTuOL7jKhBMZvzlAuYIVuWSSYdVxbhyh94HkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXsvFnjxblRFrysfkyucowd1u0jjklh7wqN9egRF5HWjlLgxN4fVrgfSwo7oZ+9dJ
	 DsDcUnlmGRAmYWE9VTIngwz8GVXVtiaCt+LsRtcSZt62ahEJLtjRL3eWWligcFocPs
	 dZzKDytgjHfAXwKxRVjvZebjV3YrRQQBCIzkRM/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dingisoul <dingiso.kernel@gmail.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 145/242] scsi: st: Fix use-after-free race between st_remove() and st_open()
Date: Fri, 23 Oct 2026 18:39:47 +0200
Message-ID: <20261023163717.212536187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/st.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4515,11 +4515,11 @@ static void st_remove(struct scsi_device
 	remove_cdevs(tpnt);
 
 	mutex_lock(&st_ref_mutex);
-	kref_put(&tpnt->kref, scsi_tape_release);
-	mutex_unlock(&st_ref_mutex);
 	spin_lock(&st_index_lock);
 	idr_remove(&st_index_idr, index);
 	spin_unlock(&st_index_lock);
+	kref_put(&tpnt->kref, scsi_tape_release);
+	mutex_unlock(&st_ref_mutex);
 }
 
 /**


