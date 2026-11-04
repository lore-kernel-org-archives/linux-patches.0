Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831876;
	b=0FHsCYBu/N3uWwBIxX+5JGH87EdXvW/Spi7mj3XkGpylHPWGy4+JfObM67t3QyrE/FdF
	 Sxef736Nggy4DJV6H/e2Z9068jU16FQEsganH4l/aVUbwaOBewNTbSt/wlrup5+fgP2T3
	 4ieg1RmOAKKTbDsStq3BAPBlatlYGumQhSI+a1AXsdFkP90fnD2J/etyrWeZM+RL6oIZy
	 ICmVjwGBBERra4nmnIYxmxxEudQqmT87F2iHvEoEBzxw6Hut2xXHcSRlH+bwPFOibz2CP
	 4OzYQvd0pIqMO0x6zTPFGyEIL3cgmWoPdf8c/NdZA0DfZgh04ZUptgyKdmffrYuiI7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gJMgFE+cdvNQh2bnLBzGsL2YBrSPqFmb/bZZDoVlf8I=;
	b=5gXN/SM7Zkqsh5QBSwjxQxdrdM4pKZ8KjbU4IbCAF/DNfS0rtkH2kSvimkwt0Bj39c9H
	 Gp+J5DHHFkCbdx5EZicZGFOLxUFeIWMzmm6EP+av7Wiue21Srj2kdUjkLAgokwWJ6gRlV
	 6M0J0wAsreMLe22TKGpsGykWxDY6yliNtnqv5BTvEhIwmwEKpX9/IJR2juvM5QB+9aRlR
	 4pziNoNNnIzsbae4/os207DgGJKW/blOxXKKzPV/xJHqqNXrdK0d+DCxolc3z7hMYbGhU
	 4bdQfYZ/aYmlmT704sPUNz5uf63Mc7xlXI5lJaIhQhSi8+Q8kynXEscjS6neimXHGfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WLgPIOSc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FD4606A326;
	Wed,  4 Nov 2026 22:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WLgPIOSc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F141F000C1;
	Wed,  4 Nov 2026 22:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831875;
	bh=gJMgFE+cdvNQh2bnLBzGsL2YBrSPqFmb/bZZDoVlf8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WLgPIOScAhrS5+Ma1mM20p/dpDEkGxHhf6fu8Mr5Pf01FuLc5V5R4eCUpuXY2GHMi
	 ycembh+mYxvgkpO2GVKPZdWQX9MwUCGDqONslAZBbRaQ395DGtqgJuBi4PVVzPQDp7
	 WZfrJeIDcHl7J3UeD69YM0dOoN+7Ko2RX1VpouyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 0968/1005] ovl: do not copy up a dentry that was removed
Date: Wed,  4 Nov 2026 16:11:41 -0500
Message-ID: <20261104211110.184283767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit f635192ad223d2009ee640b63adf5ce3198aa338 upstream.

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
[backport: no start_renaming_dentry() and LOOKUP_EXCL, fail with -EEXIST if
 the target of ovl_lookup_upper() is positive]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -830,6 +830,13 @@ static int ovl_copy_up_workdir(struct ov
 	if (IS_ERR(upper))
 		goto cleanup;
 
+	/* The name may have been taken since lookup, never replace it */
+	err = -EEXIST;
+	if (d_is_positive(upper)) {
+		dput(upper);
+		goto cleanup;
+	}
+
 	err = ovl_do_rename(ofs, c->workdir, temp, c->destdir, upper, 0);
 	unlock_rename(c->workdir, c->destdir);
 	dput(upper);


