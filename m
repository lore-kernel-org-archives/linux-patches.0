Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9B41DED72;
	Wed,  7 May 2025 18:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643512; cv=none; b=CBHisxu1MbTrarE5+iXa8ZlWztM1M4HrcdEvavSzqe5rRtwnEuHwQcVfoFB8nrRymJg+q4ljSzg5ORQWC4sFQlwCs1X8kd1txcoRNm2n5bRKjobOMCu7Le8P1ZdqTf4xeia80Dv3WdaLwzPcDpURwVg7nMb8ibuGvD/Fv7APm8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643512; c=relaxed/simple;
	bh=i1jsN7a/Kn025M5KNTsESoYDDdOcZ2+NJzqJUGKGe3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRKEdtuyMnAsyI0uVrHlHpc4g3mEzN0vgA90N3k5pAlt2b66OLcxr54ntR+VO4DWi7S0Hj9G1UXRAp2M0csmla/ItjJDVnuCJU0vmzvFlGQNTTYq19OQIFoIyx4wujPxJaB2aAgKUDl0rHPEqPYR1yp4r0CiEIF7xk08wMbiQck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBi3jSDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBi3jSDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C097C4CEE9;
	Wed,  7 May 2025 18:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643512;
	bh=i1jsN7a/Kn025M5KNTsESoYDDdOcZ2+NJzqJUGKGe3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBi3jSDda5EbohxZtvmXdhLizWk+YSrdnONfi/qvTc8rReTLyiIkqF34IWr0kPa8N
	 ANTzuBdN9bWywW9I3uLiEPIX2QZkhiikBUnMg8d5icyEimVSSpjffapdWDzBvokd5e
	 1clmlHZvvBCurwl1gf8UOIxhOgCkFOI3xkwDeYBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 29/97] xfs: revert commit 44af6c7e59b12
Date: Wed,  7 May 2025 20:39:04 +0200
Message-ID: <20250507183808.164190538@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 2a009397eb5ae178670cbd7101e9635cf6412b35 ]

In my haste to fix what I thought was a performance problem in the attr
scrub code, I neglected to notice that the xfs_attr_get_ilocked also had
the effect of checking that attributes can actually be looked up through
the attr dabtree.  Fix this.

Fixes: 44af6c7e59b12 ("xfs: don't load local xattr values during scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -159,6 +159,11 @@ xchk_xattr_listent(
 	args.value = xchk_xattr_valuebuf(sx->sc);
 	args.valuelen = valuelen;
 
+	/*
+	 * Get the attr value to ensure that lookup can find this attribute
+	 * through the dabtree indexing and that remote value retrieval also
+	 * works correctly.
+	 */
 	error = xfs_attr_get_ilocked(&args);
 	/* ENODATA means the hash lookup failed and the attr is bad */
 	if (error == -ENODATA)


