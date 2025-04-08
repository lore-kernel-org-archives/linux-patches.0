Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34AA22257E;
	Tue,  8 Apr 2025 11:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112243; cv=none; b=DLuQWEz0RcyGKpxlICRk2Hs3vTIYC/DkjYiNpx/avRmTafXJ0JprsTGslCU7H8lzuz7FRypIoJIY7ln60UUlcA508646UFg4t9vz7axSXc9/S5Qpc/AJNEjjUVtmLyDyZkYvUR4Y6UzA9V6OW/JHqsJR5vjDnxb/r3BVXKa7/HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112243; c=relaxed/simple;
	bh=CwiJ7eI5HuqgqwamJf9k371SSKbz4nGUJkwR+hG/s/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFCTRakpF6xnjOuumkrRUouZyzDaNIBtiYL7Z4KZXWVG6Y7zgNQb04W03Gm/rCZS8uEWGGvwf9LXFaKI2iSM3Fqo4vYjTxytcKJhCxHl5R+ymfyRxtkjX7RBNsO3pXkr4DJXD+mIOzATTA7a8qtoM7yis9UZkxw2r0HKegWxflM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=og9UqxXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="og9UqxXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B8CC4CEE5;
	Tue,  8 Apr 2025 11:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112242;
	bh=CwiJ7eI5HuqgqwamJf9k371SSKbz4nGUJkwR+hG/s/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=og9UqxXVbvgoa9SrHts0bjz4uCXtHTw5sSdmkfbmhCOprDguxHUseE1uYfSyK50Oq
	 NgB/SNxQbcoQxnn0CrMWqgYh9JpmejnHTn0WuaSsCrxhj7DxaeCrPln3fhqaPsQQy7
	 hirnzCMPrFGIQIh7Mj/Vs9LzQmX3f+sMS+xMEe5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.14 729/731] NFSD: nfsd_unlink() clobbers non-zero status returned from fh_fill_pre_attrs()
Date: Tue,  8 Apr 2025 12:50:26 +0200
Message-ID: <20250408104931.230222891@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit d7d8e3169b56e7696559a2427c922c0d55debcec upstream.

If fh_fill_pre_attrs() returns a non-zero status, the error flow
takes it through out_unlock, which then overwrites the returned
status code with

	err = nfserrno(host_err);

Fixes: a332018a91c4 ("nfsd: handle failure to collect pre/post-op attrs more sanely")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -2011,11 +2011,9 @@ out_nfserr:
 		 * error status.
 		 */
 		err = nfserr_file_open;
-	} else {
-		err = nfserrno(host_err);
 	}
 out:
-	return err;
+	return err != nfs_ok ? err : nfserrno(host_err);
 out_unlock:
 	inode_unlock(dirp);
 	goto out_drop_write;


