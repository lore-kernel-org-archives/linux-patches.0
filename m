Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773602701A0;
	Wed, 23 Apr 2025 14:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419811; cv=none; b=aq0CSdYQWLe6qYVV5VVqCVDSi4S5G/2OFFM0RMWzFaV6oJwH0CW4lKCoRLzIZab7lvnoJa3Rzg2jf+RDxyZ8aD/wV0vVv6DsWdLekUr8GJZt3nY0nb4DzcQ0j7mN8lwbHLAGvVrKajjnbje2cRNxjYrDjUABq1lqpPSFCyggP/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419811; c=relaxed/simple;
	bh=tuJqUfAJglmQgkA9cr3BT2H8+8IHd6+WmPmGAAkIyow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OeZiEFz30m1pkqfmk8+suxodOgQw6EyUY2T7QSL1eefr5jdYsBUY3IyIddvceo+5VTfiL4aTA8nWd5PN3moS99NNXuQLucOreZE3BjO/z8b1mVrXV/kNFLA4/L+rwdH/QkxBLhrOzkoyBvlX2SE25Zg+Qik2CMUtfAilqY70O0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqkLeurr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqkLeurr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97417C4CEE2;
	Wed, 23 Apr 2025 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419810;
	bh=tuJqUfAJglmQgkA9cr3BT2H8+8IHd6+WmPmGAAkIyow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqkLeurr8oNsRSmSQabT9ahdem91xWR9bvpILxcsb8rpzlYKpgThfJ5eI0G0e50xx
	 ubj5HO9Rza0qMZNw/gk+OgH2fr5tIo/Ka8lvF2ftjhLmVDQ/55qOt4Gv8Ubewl6PcA
	 b5ceFSw5PstHHY52cPuMdbSp8pqtnFiI1JpHlLy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 030/241] mlxbf-bootctl: use sysfs_emit_at() in secure_boot_fuse_state_show()
Date: Wed, 23 Apr 2025 16:41:34 +0200
Message-ID: <20250423142621.750909398@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit b129005ddfc0e6daf04a6d3b928a9e474f9b3918 ]

A warning is seen when running the latest kernel on a BlueField SOC:
[251.512704] ------------[ cut here ]------------
[251.512711] invalid sysfs_emit: buf:0000000003aa32ae
[251.512720] WARNING: CPU: 1 PID: 705264 at fs/sysfs/file.c:767 sysfs_emit+0xac/0xc8

The warning is triggered because the mlxbf-bootctl driver invokes
"sysfs_emit()" with a buffer pointer that is not aligned to the
start of the page. The driver should instead use "sysfs_emit_at()"
to support non-zero offsets into the destination buffer.

Fixes: 9886f575de5a ("platform/mellanox: mlxbf-bootctl: use sysfs_emit() instead of sprintf()")
Signed-off-by: David Thompson <davthompson@nvidia.com>
Link: https://lore.kernel.org/r/20250407132558.2418719-1-davthompson@nvidia.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-bootctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/mellanox/mlxbf-bootctl.c b/drivers/platform/mellanox/mlxbf-bootctl.c
index 9cae07348d5eb..49d4394e9f8a3 100644
--- a/drivers/platform/mellanox/mlxbf-bootctl.c
+++ b/drivers/platform/mellanox/mlxbf-bootctl.c
@@ -332,9 +332,9 @@ static ssize_t secure_boot_fuse_state_show(struct device *dev,
 			else
 				status = valid ? "Invalid" : "Free";
 		}
-		buf_len += sysfs_emit(buf + buf_len, "%d:%s ", key, status);
+		buf_len += sysfs_emit_at(buf, buf_len, "%d:%s ", key, status);
 	}
-	buf_len += sysfs_emit(buf + buf_len, "\n");
+	buf_len += sysfs_emit_at(buf, buf_len, "\n");
 
 	return buf_len;
 }
-- 
2.39.5



