Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0E626B0A5;
	Thu, 13 Feb 2025 15:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459917; cv=none; b=XcMCqXIYlu4tke5c+YYZZrfqe9J45OJctwBCRtsNygrhzDJbNKieRlCf9L6/vaAYSrWUBKVDmURCYe45twi3S6rC0oacITx7knHhhIDYb2J7D3K3AshCNx8duv6oNvEQUjmJyEusb1rs74uPYY8kbibRxufc+7MU5HsjuZK9OhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459917; c=relaxed/simple;
	bh=+sGkqxacSEr5Ohu9eaB0lZAyr3MBpdH7KU1CIGDrt74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1oJsIfLZoybAEMI3Xz0vtRMhqZQZAlam4zgIooIm6XgDqTjdhkpEKbAPmXc5D5SCwxYbBYFXYgjGIhSJ99qXVxmlViQETk2xVl9yvGIOA/RtjVXLES2L7zOV5haaa8EmIZ5zVHEEvfoDZqLYgfOiWsHtY+JdZYZ2HipIhWsVrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGPzNpkg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGPzNpkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E33C4CED1;
	Thu, 13 Feb 2025 15:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459917;
	bh=+sGkqxacSEr5Ohu9eaB0lZAyr3MBpdH7KU1CIGDrt74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGPzNpkgJH5Fb4vgbRUDOxaUx+sqcTFRFyIDFhaZwg4jKy/s8rVAzEeF98kLaqirl
	 ax1H06uOEjqLzJLa0DRHElgtX/Rp+8Dw7aRpbJFSeYpA8wUyDU8af5HzM3+k4XsGB6
	 htXarILqlqaAUisr0xZYZrLtBSxR7ExfzDJHIo3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.13 402/443] nfs: Make NFS_FSCACHE select NETFS_SUPPORT instead of depending on it
Date: Thu, 13 Feb 2025 15:29:27 +0100
Message-ID: <20250213142456.119481916@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

commit 90190ba1c3b11687e2c251fda1f5d9893b4bab17 upstream.

Having the NFS_FSCACHE option depend on the NETFS_SUPPORT options makes
selecting NFS_FSCACHE impossible unless another option that additionally
selects NETFS_SUPPORT is already selected.

As a result, for example, being able to reach and select the NFS_FSCACHE
option requires the CEPH_FS or CIFS option to be selected beforehand, which
obviously doesn't make much sense.

Let's correct this by making the NFS_FSCACHE option actually select the
NETFS_SUPPORT option, instead of depending on it.

Fixes: 915cd30cdea8 ("netfs, fscache: Combine fscache with netfs")
Cc: stable@vger.kernel.org
Reported-by: Diederik de Haas <didi.debian@cknow.org>
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -170,7 +170,8 @@ config ROOT_NFS
 
 config NFS_FSCACHE
 	bool "Provide NFS client caching support"
-	depends on NFS_FS=m && NETFS_SUPPORT || NFS_FS=y && NETFS_SUPPORT=y
+	depends on NFS_FS
+	select NETFS_SUPPORT
 	select FSCACHE
 	help
 	  Say Y here if you want NFS data to be cached locally on disc through


