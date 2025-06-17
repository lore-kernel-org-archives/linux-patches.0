Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08332356CE;
	Tue, 17 Jun 2025 16:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177395; cv=none; b=AbVt+kp5F+/1k3FuzcwNRl1jc69/aEUeBQe0b3S+nq6vHFGBvThRfgyCTKvcvyAMDAAGfL3o3j57WwOuSo9NbG/Mq0lpA5ZTnxI9iSssxe9gcxsHj4kDsrCwXt55QUDkKKJZx56xMYpbhIj+VlbG4xdJwNVd+TBnVole3TMrYNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177395; c=relaxed/simple;
	bh=v0aGlDPA/C8NvJxPwvPf9Tc3Lw6t7+EVzJz0HJfCssQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vj0g9IEp0YZf5zCSdM+QsFYQerPTkJGM6Cu5a6BkmEIfY5FG7Gz51xcZbfV+BeLKj/Z2vxuW/xzFc2HILxzrGvi1a0/+/HjgHMTDDdsWmywVG1/FDCY56CKrkIbnp/WkcXzn+np9iSy8dFhtze87rsk/q1dILTvwNNDybbIKfmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrM/ije+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrM/ije+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42687C4CEE3;
	Tue, 17 Jun 2025 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177395;
	bh=v0aGlDPA/C8NvJxPwvPf9Tc3Lw6t7+EVzJz0HJfCssQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrM/ije+qkW6SUf8FApm7rivLTLwPiM1+ThZo5brCixnIlwmLVzA8EprOK3chJUEG
	 vILhOOa0VzdSC3hp3Ci7K0+HqNSrzyD7EfSmapBVWM4ZOd2AmM7HlVZN3MDWAfl7Oz
	 iheyHmaIG2CevfK4Qq3/DAhqnOV7AwtYj06U5HjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 337/512] mei: vsc: Cast tx_buf to (__be32 *) when passed to cpu_to_be32_array()
Date: Tue, 17 Jun 2025 17:25:03 +0200
Message-ID: <20250617152433.266414204@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 97ce0fe2b7240d47d9124daa92217e478c21a3ba ]

Commit f88c0c72ffb0 ("mei: vsc: Use struct vsc_tp_packet as vsc-tp tx_buf
and rx_buf type") changed the type of tx_buf from "void *" to "struct
vsc_tp_packet *" and added a cast to (u32 *) when passing it to
cpu_to_be32_array() and the same change was made for rx_buf.

This triggers the type-check warning in sparse:

vsc-tp.c:327:28: sparse: expected restricted __be32 [usertype] *dst
vsc-tp.c:327:28: sparse: got unsigned int [usertype] *

vsc-tp.c:343:42: sparse: expected restricted __be32 const [usertype] *src
vsc-tp.c:343:42: sparse: got unsigned int [usertype] *

Fix this by casting to (__be32 *) instead.

Note actually changing the type of the buffers to "be32 *" is not an option
this buffer does actually contain a "struct vsc_tp_packet" and is used
as such most of the time. vsc_tp_rom_xfer() re-uses the buffers as just
dumb arrays of 32 bit words to talk to the device before the firmware has
booted, to avoid needing to allocate a separate buffer.

Fixes: f88c0c72ffb0 ("mei: vsc: Use struct vsc_tp_packet as vsc-tp tx_buf and rx_buf type")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505071634.kZ0I7Va6-lkp@intel.com/
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://lore.kernel.org/r/20250507090728.115910-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/vsc-tp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/vsc-tp.c b/drivers/misc/mei/vsc-tp.c
index ad7c7f1573191..5e44b518f36c7 100644
--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -324,7 +324,7 @@ int vsc_tp_rom_xfer(struct vsc_tp *tp, const void *obuf, void *ibuf, size_t len)
 	guard(mutex)(&tp->mutex);
 
 	/* rom xfer is big endian */
-	cpu_to_be32_array((u32 *)tp->tx_buf, obuf, words);
+	cpu_to_be32_array((__be32 *)tp->tx_buf, obuf, words);
 
 	ret = read_poll_timeout(gpiod_get_value_cansleep, ret,
 				!ret, VSC_TP_ROM_XFER_POLL_DELAY_US,
@@ -340,7 +340,7 @@ int vsc_tp_rom_xfer(struct vsc_tp *tp, const void *obuf, void *ibuf, size_t len)
 		return ret;
 
 	if (ibuf)
-		be32_to_cpu_array(ibuf, (u32 *)tp->rx_buf, words);
+		be32_to_cpu_array(ibuf, (__be32 *)tp->rx_buf, words);
 
 	return ret;
 }
-- 
2.39.5



