Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB28E6A024;
	Tue, 23 Jan 2024 02:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975447; cv=none; b=ezf/536xM3qfEb/i1/CXCfAeE6hyq4e485Uk63WREXSwfVTEMG23zVTg6oWoy9pStExqW019QnMEg1N7pgcByBVCYhrKit6cCvf176kn67GlMNlqmXw2RiikUDHvZOiBMML6FegtmKtvAA6BePCxna5qBj3+y6XxfKFzuIK0BQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975447; c=relaxed/simple;
	bh=tg2LH/Vo6NVw2R8btikxTL25eXkPvnWDzAMfWHtuhfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouDAUn86qCX3SzhU/p6pcAa1vcnQ5lnNRN81Tp2Vrfub2wVmHHz8jC42vxcTfQNU9kpAT9AnwX06gA9//DbyfcTu8ldqQUdAO5Qzn/aHa1MddVQxPEn/DPNNU2sET9RCBOCpw8kz9zOlQRQGTInPlC8hwxIaai67ilR9M/g9om0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7SLZOCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7SLZOCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1A6C433F1;
	Tue, 23 Jan 2024 02:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975447;
	bh=tg2LH/Vo6NVw2R8btikxTL25eXkPvnWDzAMfWHtuhfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7SLZOCGysSL/e8ttbriJqqEBGOCnRD+ajaCktSJZ3J3wWTbrFxlJxqtUWlFCTJar
	 zeZxQDfWuRdOsJoA1KrQYmAfWlRFWKbG0i7s3Uw0Oqdoc6vrWN+PSUhNq82QnDw+bU
	 25nfJHs0XtIj6UoGKfsyNI0o9eaRYX3nXJYzk9js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 386/583] ceph: select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
Date: Mon, 22 Jan 2024 15:57:17 -0800
Message-ID: <20240122235823.807209578@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit 9c896d6bc3dfef86659a6a1fb25ccdea5dbef6a3 upstream.

The kconfig options for filesystems that support FS_ENCRYPTION are
supposed to select FS_ENCRYPTION_ALGS.  This is needed to ensure that
required crypto algorithms get enabled as loadable modules or builtin as
is appropriate for the set of enabled filesystems.  Do this for CEPH_FS
so that there aren't any missing algorithms if someone happens to have
CEPH_FS as their only enabled filesystem that supports encryption.

Cc: stable@vger.kernel.org
Fixes: f061feda6c54 ("ceph: add fscrypt ioctls and ceph.fscrypt.auth vxattr")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index 94df854147d3..7249d70e1a43 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -7,6 +7,7 @@ config CEPH_FS
 	select CRYPTO_AES
 	select CRYPTO
 	select NETFS_SUPPORT
+	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
 	default n
 	help
 	  Choose Y or M here to include support for mounting the
-- 
2.43.0



