Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C58414A4D2;
	Tue, 20 Feb 2024 21:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464638; cv=none; b=a0TRUSYJXuD0JhtaJqk8Qy2qSNHU/1B94/6BdMZKgJCX4etBRk+RAyYm9lr4J1UwoXSyGT5sf0i1Mprx85BrGtLSXr8x0mVxO/kwbk3enOoPUPwtOKWRbwMLm3m0bjDbCrtvO9nkYAcsBYZ4WchPCzqAebYIbwwtLyJ2cmIKxrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464638; c=relaxed/simple;
	bh=r3oJjUBdTzGPHKTiNybDHQijBlWBgbU9E6xVyqhVh48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8i6ETvpg8OObN/wZCZR3u0Wv40+C1sv1mIYkR9uuH1Si7xALLC44hrKP3hE8YDP2jTTLb5mTCl85t4tjzAj78ijj1fkrYlrDnLfE81c4rMQMpd/rf9QE8/PZzi/wI2D/L7bd19g39W2RQTBvh4/3ttsSarwqMYScZdG5fh1VZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOxKPGJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOxKPGJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5C5C433C7;
	Tue, 20 Feb 2024 21:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464638;
	bh=r3oJjUBdTzGPHKTiNybDHQijBlWBgbU9E6xVyqhVh48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOxKPGJP/YEezFwAGQIwo+W3L92u4TP61LFj1WMVwWEhR3K4H3YsvFHX1HSfxBYYu
	 YIKquFwRXWvBIEDgAPdIljiaeisHg/BPUEYNk4L/PbOUCMgM3CfSAmixZbeMJEql7b
	 G4lC0YFWH0MGK9tLhdUMGlx5hbb4OQI0jbg4uJDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 6.7 088/309] usb: ulpi: Fix debugfs directory leak
Date: Tue, 20 Feb 2024 21:54:07 +0100
Message-ID: <20240220205635.955514837@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@seco.com>

commit 3caf2b2ad7334ef35f55b95f3e1b138c6f77b368 upstream.

The ULPI per-device debugfs root is named after the ulpi device's
parent, but ulpi_unregister_interface tries to remove a debugfs
directory named after the ulpi device itself. This results in the
directory sticking around and preventing subsequent (deferred) probes
from succeeding. Change the directory name to match the ulpi device.

Fixes: bd0a0a024f2a ("usb: ulpi: Add debugfs support")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/20240126223800.2864613-1-sean.anderson@seco.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -301,7 +301,7 @@ static int ulpi_register(struct device *
 		return ret;
 	}
 
-	root = debugfs_create_dir(dev_name(dev), ulpi_root);
+	root = debugfs_create_dir(dev_name(&ulpi->dev), ulpi_root);
 	debugfs_create_file("regs", 0444, root, ulpi, &ulpi_regs_fops);
 
 	dev_dbg(&ulpi->dev, "registered ULPI PHY: vendor %04x, product %04x\n",


