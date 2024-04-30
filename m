Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B878801;
	Tue, 30 Apr 2024 11:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475820; cv=none; b=H+ELSHbVvxYy58d3rDEZ2/APfZt7x6il/Yt6gOuAe82crsWVWY7EkloRtZg2547I3elMAAkbAbvM5dpUlaIllzL/wSDiC/sVZLqtvomwRDxoy0AUtv27FxOpgS6DZj0hBe81Le0ogskyiMuEQc4mROyRy833WMzUL47pwd5MuKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475820; c=relaxed/simple;
	bh=pT4zJmUQICGgDmA3NJ4m1+kLcEsMY/cPMpd2TYnMXt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5Q7DgeiERb9lX4yslii8OC0dQUuMP8HizKnquGVWhv6xUazpKs6SmyzrjmnoGNIAnnNg4Iuv/W/mXrrn0qRsCzSXREyilIqYICQES6OJMRR4ahSHowbI0FaNwYPF93xVpi8c1wWZTJGGYatONVtgsnzA+d9OIbn6fmNt8N3DGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCHzH4wG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCHzH4wG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90662C4AF18;
	Tue, 30 Apr 2024 11:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475820;
	bh=pT4zJmUQICGgDmA3NJ4m1+kLcEsMY/cPMpd2TYnMXt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCHzH4wGOxXASinLcUqDZwZUlXlAhNAMvVGGSsPVbO6t9FHUvxg2rpJKsN+/1Hxfn
	 vWWNRwEEU0oe+o67L23MS2HOmQn+HGN7hfluLkRfYSC6sjhyA4YkiixBp2obBAws4e
	 WZU5sloLv4yink+v7qUxfsrQkZ9fYdJU3SRstv5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/80] HID: intel-ish-hid: ipc: Fix dev_err usage with uninitialized dev->devc
Date: Tue, 30 Apr 2024 12:39:35 +0200
Message-ID: <20240430103043.502582644@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit 92826905ae340b7f2b25759a06c8c60bfc476b9f ]

The variable dev->devc in ish_dev_init was utilized by dev_err before it
was properly assigned. To rectify this, the assignment of dev->devc has
been moved to immediately follow memory allocation.

Without this change "(NULL device *)" is printed for device information.

Fixes: 8ae2f2b0a284 ("HID: intel-ish-hid: ipc: Fix potential use-after-free in work function")
Fixes: ae02e5d40d5f ("HID: intel-ish-hid: ipc layer")
Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ipc/ipc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/intel-ish-hid/ipc/ipc.c b/drivers/hid/intel-ish-hid/ipc/ipc.c
index 6c942dd1abca2..ba45605fc6b52 100644
--- a/drivers/hid/intel-ish-hid/ipc/ipc.c
+++ b/drivers/hid/intel-ish-hid/ipc/ipc.c
@@ -944,6 +944,7 @@ struct ishtp_device *ish_dev_init(struct pci_dev *pdev)
 	if (!dev)
 		return NULL;
 
+	dev->devc = &pdev->dev;
 	ishtp_device_init(dev);
 
 	init_waitqueue_head(&dev->wait_hw_ready);
@@ -979,7 +980,6 @@ struct ishtp_device *ish_dev_init(struct pci_dev *pdev)
 	}
 
 	dev->ops = &ish_hw_ops;
-	dev->devc = &pdev->dev;
 	dev->mtu = IPC_PAYLOAD_SIZE - sizeof(struct ishtp_msg_hdr);
 	return dev;
 }
-- 
2.43.0



