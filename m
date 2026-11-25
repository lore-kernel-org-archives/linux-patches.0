Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625968;
	b=thi3tYLKwrtJtVhTeHpLs9Myu9Mu2HbI77I+yLN3JjZf2cjJZ1RnHj/DKePXZP18smPL
	 Do8NnKfiwbGYZGvhF0KPV+XrXr7x7Y9qvF2tqnuZhuDWqqnrrS6mEsuCp7BoZ7ycVeund
	 qA16mVFZqO2UfD3hwFbJLsoQ+dyzE0e459PM4JlJAo4LBOhVqDmILiwa0St46bpy5ZPHO
	 UBYMoi3TrxPE4YFEAkK+mSzjQMb8FmIlcQJ1RIzZ5wj62/UYsy4rTmHpq88RpoYbZ10qu
	 t5mf3XVfs7xoErQkB4h6q8aTcM+uk9EvXSEg38Wg1PtmM5RYwOq3vnmrXXLnrPn0XRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SnPFS6NZ/eClXQSHyN8zgQHklu+YB5lFed451/2TjYw=;
	b=s2pwDbARFsIZlduM3TQKtFZvObyAK4HxqJFtuxKuZABuBlokn0jVeSokr7kw8bzm5wT1
	 hgGVGJ5EqCt3A5M4hECEbTKpBnbSR3aukcJpKa0lqy32FgRiSz5xdjGp7gNlEh+33p6My
	 5I+Ffd07zUj5riJP7Uf3q3J7WuL2QuHMkSI5Dp+I2JVb9pe35ar6FHjMxcPppnxPxP2Oy
	 5WG4ubgI1myBfZIerw37Vsk/JQtnKJQD1bdb5X49SayQSHfNETN3U8M0fjLHAtNDtnFdD
	 9e/uObZfestU/jAIatjteVBzUWhIURJK629mVxk/dzbgPNfJ6/k6VWhvigaZdouo/Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jxQyNnE7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7778D606A31E;
	Wed, 25 Nov 2026 16:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jxQyNnE7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727E01F000C4;
	Wed, 25 Nov 2026 16:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625968;
	bh=SnPFS6NZ/eClXQSHyN8zgQHklu+YB5lFed451/2TjYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxQyNnE7Wc4SDuJXGPhDsfPR/tVM5p8IV3SVQClmxd5ehArparCfvgSMz/MbMNxN+
	 IodHLy/zgBLNVUYLBh7ShVUFWa7WhU8jj4FqoQO9GRMzg8CVwG7WWpPZ8HLcsz8lPh
	 EM9CqJQ1yAY/o3r0vn/nRaQUPZ9dOX4VK2V0gPFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Piscitelli <ooonea@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 687/816] smb: client: flush deferred handles of other names before a hard link open
Date: Wed, 25 Nov 2026 15:37:15 +0100
Message-ID: <20261125143905.083224668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 25912ed3b75dcf5ff623dcb549b925dd0d0948f7 upstream.

Opening a hard link of a file whose other name still holds a deferred,
leased handle fails with EINVAL over SMB3.  The client caches lease keys
per inode, but the server ties a lease to the file name it was granted
under, so reusing the inode's lease key to open a different name of the
same inode is rejected with STATUS_INVALID_PARAMETER (MS-SMB2 3.3.5.9.11).

Commit 262b73ef442e ("smb3 client: fix open hardlink on deferred close
file error") already closes the inode's deferred handles before such an
open so the new name can take a fresh lease, but cifs_get_hardlink_path()
only triggered that flush when a cached handle had the same open flags as
the new open, so a differently accessed name - written then read, say -
slipped through and still failed.

Match on the name instead: flush when a cached handle for another name of
the inode is open, regardless of access mode.

Reported-by: Giuseppe Piscitelli <ooonea@gmail.com>
Closes: https://lore.kernel.org/r/CACmoRBbDZR3eyEM65j73sWMS7A=T89z1QAvCP=+u0WGzZhwW6g@mail.gmail.com
Fixes: 262b73ef442e ("smb3 client: fix open hardlink on deferred close file error")
Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2095,7 +2095,7 @@ cifs_get_hardlink_path(struct cifs_tcon
 	spin_lock(&cinode->open_file_lock);
 
 	list_for_each_entry(open_file, &cinode->openFileList, flist) {
-		if (file->f_flags == open_file->f_flags) {
+		if (open_file->dentry != file_dentry(file)) {
 			rc = -EINVAL;
 			break;
 		}


