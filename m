Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058889;
	b=4YswRtLWehXgSurQxg6kz8SCfyZvvj7C7FBE+vJcz/ab7numX6rFcPEFGHaxWHMLdgGP
	 Co5630lIi+qP+ruPNyXzb94zGsuTtiacdV0wurzYi305NLH4wJQUFpMrJQ10eyo3a7deo
	 3ci6esrNUU7LpJhifZHfOkKe0Sq44+0KZddxu28VxqcmPFRD74hC6FdLjoGAVymxOjlC6
	 EREnZ/slxuigMQO9ay6UTk0RMBdIwb8lhwW7db5Ql98NBmXCEcw1TrZz/+/DdzS5nruda
	 WVyA2MQ3znGipCX4Ht3tzPlLwU8eaVo7uVVgNC9G41bH+yfeVzBx56bUfHMdEt53LTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=30DA+2CLU43WucWfw19RAU02F+ORD4xr4votlGsT59M=;
	b=N+xou3tS97ODlAri7lKx7tVLbbjbLUTYG9yN5jck6azZczepdaGjfauH+/LhaPA81PRu
	 QU4rcHxQJJzXVvCjAw9wmtRbd2wQ+qkLtgoOItj4FfHbBa9ZdA5MmJhHLS7TpY2jfCJlO
	 3IScUlHRsF9J//ESEepys4n5gqQWPor6IaSp6USTd7ylmAg/dgEVpWlShqLdXXkhspo+o
	 P0OX0OjolPdeGhkHOz1NDYWHiA9RRYP1FI85KcaPsoAlOg9FVaKUqodoW6G8AgymHGBh2
	 xH0aqcuGU/AqcEp0leYKLIzhUq0+v04LkL+fQlU3lOD6zNKVs3XSgHmks4FSvmyDhBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eEj+ucMw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D58606A31C;
	Thu, 19 Nov 2026 03:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eEj+ucMw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DFB1F000C4;
	Thu, 19 Nov 2026 03:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058889;
	bh=30DA+2CLU43WucWfw19RAU02F+ORD4xr4votlGsT59M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eEj+ucMwg+jT5b6pCw1hcxx1oZz5vDRF2gLX9gOateAvTIGrpz3orIaZiv3/vsQr3
	 eY//jjaxFAZAbyLreLy1Yg319G4Zhm8kyMBqh3/XQ4wLmPooOx764r3eRpDsHmXhvd
	 loA6chp2zm+J2+fa8Zx1SnBt+Y1Rk6UjBNjHatWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0620/1848] ovl: do not copy up a dentry that was removed
Date: Wed, 18 Nov 2026 15:44:18 +0100
Message-ID: <20261118145941.260437204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit f635192ad223d2009ee640b63adf5ce3198aa338 ]

A change to a removed file through an open descriptor replaces whatever
has its old name in the upper layer.

Copy up must only create a name in the upper directory, never replace
one. After an unlink, an rmdir or a rename over a lower dentry, a
dentry that an open file keeps alive still has its old parent and name,
but in the upper directory that name is now a whiteout or a new object.
ovl_copy_up_workdir() renames the copy over it, which brings back the
removed object and destroys whatever took its name.

An unprivileged user opened a lower FIFO and unlinked it, root created
a file at that name, and fchmod on the old descriptor replaced the file
of root with the FIFO.

Fix this by looking up the target name of the rename in
ovl_copy_up_workdir() with LOOKUP_EXCL, so that copy up fails with
-EEXIST if the name is taken, as copy up with O_TMPFILE already does
when it links the copy to the name.

Fixes: e9be9d5e76e3 ("overlay filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: use LOOKUP_EXCL instead of relying on d_unhashed()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[ sashal: Adapted start_renaming_dentry()'s LOOKUP_EXCL handling to an explicit d_is_negative() check before ovl_do_rename(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index d1a1b86262798..58a2cbd32fa53 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -626,7 +626,10 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	if (IS_ERR(upper))
 		goto cleanup;
 
-	err = ovl_do_rename(wdir, temp, udir, upper, 0);
+	/* The name may have been taken since lookup, never replace it */
+	err = -EEXIST;
+	if (d_is_negative(upper))
+		err = ovl_do_rename(wdir, temp, udir, upper, 0);
 	dput(upper);
 	if (err)
 		goto cleanup;
-- 
2.53.0



