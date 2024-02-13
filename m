Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D513A93C;
	Tue, 13 Feb 2024 17:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845872; cv=none; b=PShE0B/4Doyl+NHZuVaMn2rNecMhCnHhJZ4ulLYBPp4cU8HL7yug9R5/INnG3wbNPzJqQUZlEUMUlQhaBblwqaDsOy01iU7fNEzmx6HqE7/oqawe051qP0YYVTTdZfRo+3HwQG0NslHXE1nP5e8umILO8nbln72ndbd6pigNBTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845872; c=relaxed/simple;
	bh=l++1Cg9qxu/BNTxov1Tf+tvnDXkR7/eEctAJB8kY0iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bh3d6JHWq8MB3F99StUuwwOb8YYn3PRyfSfPHMVyYEZUp7AJ3GIObe48uOUnh4NLTGveSbOrC66bZlT9XsnmEjndjQfm/MP7N48TnzcTKSFd+L0WRnQ2GeqGQcFyA1NUSXU908qNQprPZP7pimVCcik1CBR16Ke5fwZiHM+iDyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jm9EG7Pt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jm9EG7Pt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9881C433B1;
	Tue, 13 Feb 2024 17:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845872;
	bh=l++1Cg9qxu/BNTxov1Tf+tvnDXkR7/eEctAJB8kY0iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jm9EG7PthG5GOwdDAkK6yynoxCg7m++D8woTIeefCKeV5BfVNDzDXlZIkhjjdAVEB
	 fh4OKlhuANIvmVycFjx+VbQqqKXDeq/qNWfHPWcY/Pla/iSnPw77ycYLgr2xbCibt0
	 XNIxZuAUea/KNijds4kDD9Xw/28R/kPjn8Bvp1/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Eric Biggers <ebiggers@google.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 081/124] ceph: always set initial i_blkbits to CEPH_FSCRYPT_BLOCK_SHIFT
Date: Tue, 13 Feb 2024 18:21:43 +0100
Message-ID: <20240213171856.101684882@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit bbb20ea993f46743f7429092ddc52f1a5c5428ef ]

The fscrypt code will use i_blkbits to setup ci_data_unit_bits when
allocating the new inode, but ceph will initiate i_blkbits ater when
filling the inode, which is too late. Since ci_data_unit_bits will only
be used by the fscrypt framework so initiating i_blkbits with
CEPH_FSCRYPT_BLOCK_SHIFT is safe.

Link: https://tracker.ceph.com/issues/64035
Fixes: 5b1188847180 ("fscrypt: support crypto data unit size less than filesystem block size")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 0679240f06db..7d41c3e03476 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -78,6 +78,8 @@ struct inode *ceph_new_inode(struct inode *dir, struct dentry *dentry,
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
+	inode->i_blkbits = CEPH_FSCRYPT_BLOCK_SHIFT;
+
 	if (!S_ISLNK(*mode)) {
 		err = ceph_pre_init_acls(dir, mode, as_ctx);
 		if (err < 0)
-- 
2.43.0



