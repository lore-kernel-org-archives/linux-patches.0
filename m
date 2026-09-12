Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA85742586B;
	Sat, 12 Sep 2026 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220094; cv=none; b=gcM5HNfUoaMBvpGcZvNs76lB6IyYtHVX4f836Uv7StaGT8IQehaH+3bA6xXZMBzzTAb2gZSYQcmqB1qxh62vBM/5rGbBlZp44oJJ09vlHrIqUK8TVK7Xp3/Fnvu2sEcXq3JZNLohHmGhvuE8Z88pgqASn2VbmFEwM/vAOdqIGVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220094; c=relaxed/simple;
	bh=VpRJFoVj/mlYl4bz3ZCZfwj+DlGtaGicqEwwohRmmYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SiSFLOC6iHf6Ku+Vj1nEOIV2rXNcURGcGlIzuTIBGtvZGUxATR8iJqcNGuee/VpQeFXKy7/lKNvaNhcL3f0FF2GfW5SSY/OZXKVKXbXes0Dc0pvLHtfmsVz4FRv1KBhyknuUW/LQ7/z1q2POlIEYU/fnz6tEboOHOXBa8d4oy4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VQXZsdb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VQXZsdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBC91F000FF;
	Sat, 12 Sep 2026 13:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220093;
	bh=/gQqXRKFU7I0ipllIdC/5L4JjOmfab+8vuMBZImksrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1VQXZsdb6VdWQVFPC44DzqeO63rSMASjUbiOWI3SMvSXmsQmWsz92d6qSWIZ7Q9WE
	 KsA3W0jApSFDxzPv0iI6aPE2FWV9qebZtT/8M3s22IZd5iek06MRPYrSy9Q2X0ZT0y
	 X33txILmmPP12S1Nc494WBu3utMf0XAHH5ELNuA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0106/1424] fbdev: uvesafb: unregister connector callback on init failure
Date: Sat, 12 Sep 2026 08:42:18 +0200
Message-ID: <20260912065609.681723669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit de8db23aa7c337e606fca9faf48b3ba72968597a upstream.

uvesafb_init() registers the v86d connector callback before registering
the platform driver. If platform_driver_register() fails, the function
returns the error directly and leaves the connector callback registered.

The later platform-device failure path already unregisters the callback.
Add the same cleanup before the final return when platform-driver
registration fails.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 8bdb3a2d7df4 ("uvesafb: the driver core")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/uvesafb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1910,6 +1910,8 @@ static int uvesafb_init(void)
 			err = 0;
 		}
 	}
+	if (err)
+		cn_del_callback(&uvesafb_cn_id);
 	return err;
 }
 


