Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A6038655A;
	Sat, 12 Sep 2026 13:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219234; cv=none; b=uiwc6m57rXviwkxx4sLj21x2lAYVHspDZCr4ka4Ko19oDbrnBx6szZDLH66vMHjCkcG/qBvevG/+EyPHwMGXVD6sT5AMuMjq6XxdiUUMLRdtjJn7HeGrtL6fMNDNAG3Y7+/fvKP4KoIlWxMscGs9hh3DtQRajz1z7PJIHAIW2ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219234; c=relaxed/simple;
	bh=Ogz3ScI70QxsmbEy7PGa7VDFlNRXC1bn7RnfliyZhMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7Vjhs6voXEH4ki17nCNU4x2+hRidian47+XhFw7T5DHWud5kybC3IJAou6iF+x+9TykFIyzoImosJ96BLZnWmpw6gKyjk/LpF43wKpO3zxdiWt4Fyhqo9HZDBIiVM6dGbI154pSZKd1ts+pcq9bCnKEL/Noh8oJKd3cJfCdoIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2UzdMD/6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2UzdMD/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5FC1F000FF;
	Sat, 12 Sep 2026 13:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219232;
	bh=lb1TCzUOCHNQShyh3Lp6i6JEQTn5RBBozoJPQtOE11Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2UzdMD/69yzVSKyi2PfuOooP6OA9u/UCG3Pxjf09ArIbmZ8E+kEe9moVzdK3HUej0
	 ki3U/6EEFoF+sjRjd7UYjh6yorjHCE3uGsvlFrFKBSR4luNKeZ5APNxoft17vdWoyA
	 YARQQ1EMC1RQT+hwifwIgQP6B+ZlyhbpZXhgibEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1310/1376] ceph: revalidate ki_pos for O_APPEND writes after cap acquisition
Date: Sat, 12 Sep 2026 09:02:16 +0200
Message-ID: <20260912065636.729900165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Xiubo Li <xiubo.li@clyso.com>

[ Upstream commit d2a8d446a09c74c8ddfe108b50dd791c889983fc ]

For O_APPEND writes, ki_pos is set to the current EOF via
generic_write_checks() after fetching i_size from the MDS.  However,
ceph_get_caps() may need to wait for Fwx exclusive caps if the write
extends the file (endoff > i_max_size).  While waiting for Fwx, the
previous Fwx holder (another client) may have already extended the
file.  When the MDS grants us Fwx, the cap grant message updates the
local i_size, but ki_pos remains at the old EOF, causing the append
write to land at a stale offset and overwrite data from the other
client.

Fix by re-reading i_size_read(inode) after ceph_get_caps() returns.
At this point we hold Fwx exclusive caps, no other client can modify
the file, and i_size reflects the true EOF from the MDS cap grant.
No extra MDS round-trip is needed.  Only adjust ki_pos when the EOF
has actually changed.

After adjusting ki_pos forward, the write range [pos, pos+count) may
now exceed the i_max_size that was validated by ceph_get_caps() for
the old range.  Re-check against i_max_size and truncate the write
if necessary to stay within the MDS-granted limit.

Link: https://tracker.ceph.com/issues/7333
Fixes: 8e4473bb50a1 ("ceph: do not execute direct write in parallel if O_APPEND is specified")
Signed-off-by: Xiubo Li <xiubo.li@clyso.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/file.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d86c1285fb020..e70f3e433c846 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2411,6 +2411,54 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (err < 0)
 		goto out;
 
+	/*
+	 * For O_APPEND writes we may have waited for Fwx exclusive caps
+	 * while the previous Fwx holder (another client) extended the
+	 * file.  i_size has been updated via the cap grant message from
+	 * the MDS, but ki_pos is still the old EOF.  Re-read i_size here
+	 * (no extra MDS round-trip needed) and adjust ki_pos to the true
+	 * EOF.  Since we hold Fwx, no other client can change the file.
+	 */
+	if (iocb->ki_flags & IOCB_APPEND) {
+		loff_t cur_eof = i_size_read(inode);
+
+		if (cur_eof != pos) {
+			doutc(cl,
+			      "%p %llx.%llx O_APPEND: pos adjusted %lld -> %lld\n",
+			      inode, ceph_vinop(inode), pos, cur_eof);
+			iocb->ki_pos = cur_eof;
+			pos = cur_eof;
+			if (pos >= limit) {
+				err = -EFBIG;
+				goto out_caps;
+			}
+			iov_iter_truncate(from, limit - pos);
+			count = iov_iter_count(from);
+
+			/*
+			 * ceph_get_caps() validated the old endoff
+			 * against i_max_size; adjusting ki_pos forward
+			 * may have shifted the write range beyond the
+			 * granted max_size.  Re-check and truncate if
+			 * necessary.
+			 */
+			spin_lock(&ci->i_ceph_lock);
+			if (pos + count > (loff_t)ci->i_max_size) {
+				loff_t max_size = ci->i_max_size;
+
+				spin_unlock(&ci->i_ceph_lock);
+				if (pos >= max_size) {
+					err = -EFBIG;
+					goto out_caps;
+				}
+				iov_iter_truncate(from, max_size - pos);
+				count = iov_iter_count(from);
+			} else {
+				spin_unlock(&ci->i_ceph_lock);
+			}
+		}
+	}
+
 	err = file_update_time(file);
 	if (err)
 		goto out_caps;
-- 
2.53.0



