Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856E5215799;
	Thu, 12 Dec 2024 16:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020506; cv=none; b=CQN0uewPadc4s6l7Z2NB+hEUpa+398+kDkfzGjHu+VuNMt8tIqNIqq02QfBmXYIUAlhjtdBLJd0vBfumsefqF6jYE8X858EdTbRlORIq93D1bZbMuUJ9dYZCNa5ZtPMnIGNhSkXKcj+THh35W/u5kHjq9k7DiTipIwh00fRdcLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020506; c=relaxed/simple;
	bh=/Z/RfSY3xci3AlY8xPLWvjCLDD7qAfzmYsE64tZcIgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAn9Riz/HLS9RiToKoDsrcq6O1fATTpbuqHGIS6kkdqzEwUcGMIdq18Aro28lua7d7F/FTW0TVhl18xfxrujBXNi03J1W1WATtv0l55os+MSf/01Y9Fh+bPqqP28qldeh7zRCCiCeOUDXKONdaoOaSrsI4JRIrpMvThIiN4SQms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3dTHTEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3dTHTEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB071C4CECE;
	Thu, 12 Dec 2024 16:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020506;
	bh=/Z/RfSY3xci3AlY8xPLWvjCLDD7qAfzmYsE64tZcIgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3dTHTEjhVcvzXCIDL7oPprLCOt5vNjaw0HN59gouTVVJj+trGtC1leNtHmjMx4Mf
	 VZolvX82pLmPEuPJbeKJz867LHF4H9NdfAQl2iI/ZfOB9bI2OCr3kF3wfd4VA6Ul3O
	 1CwQiA3DXuYWiYFreRt/TIFSMPWmO9HpGDizl8s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Donnelly <pdonnell@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 483/772] ceph: extract entity name from device id
Date: Thu, 12 Dec 2024 15:57:08 +0100
Message-ID: <20241212144409.890088423@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Donnelly <pdonnell@redhat.com>

commit 955710afcb3bb63e21e186451ed5eba85fa14d0b upstream.

Previously, the "name" in the new device syntax "<name>@<fsid>.<fsname>"
was ignored because (presumably) tests were done using mount.ceph which
also passed the entity name using "-o name=foo". If mounting is done
without the mount.ceph helper, the new device id syntax fails to set
the name properly.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/68516
Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/super.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -274,7 +274,9 @@ static int ceph_parse_new_source(const c
 	size_t len;
 	struct ceph_fsid fsid;
 	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
+	struct ceph_options *opts = pctx->copts;
 	struct ceph_mount_options *fsopt = pctx->opts;
+	const char *name_start = dev_name;
 	char *fsid_start, *fs_name_start;
 
 	if (*dev_name_end != '=') {
@@ -285,8 +287,14 @@ static int ceph_parse_new_source(const c
 	fsid_start = strchr(dev_name, '@');
 	if (!fsid_start)
 		return invalfc(fc, "missing cluster fsid");
-	++fsid_start; /* start of cluster fsid */
+	len = fsid_start - name_start;
+	kfree(opts->name);
+	opts->name = kstrndup(name_start, len, GFP_KERNEL);
+	if (!opts->name)
+		return -ENOMEM;
+	dout("using %s entity name", opts->name);
 
+	++fsid_start; /* start of cluster fsid */
 	fs_name_start = strchr(fsid_start, '.');
 	if (!fs_name_start)
 		return invalfc(fc, "missing file system name");


