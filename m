Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F3528D83F;
	Wed, 23 Apr 2025 15:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421060; cv=none; b=qkVMmjtLN2yAhIWCfJHDk2pPDUxX1fwe6B+Z71DMIG3r8ATs2lzZd/+Fj2FrN5kySgzkSGv4biT/ohjlimw0gtS7Uiyi8nDI3qrIqWI3vSc0gnIVHcUZuu339r5JeMB2gFaH3Fs32Qbc3EAWaFb/wi7FtmRvuSoP+FdCR6c4WLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421060; c=relaxed/simple;
	bh=vYi7b8G8mtqDazpYeVtS62KfVpcLXQLdTZ6o2TXVz+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgxRec66xgKG/RK+uUp5gsrAfpgrVMudVj+HCdAFZIlJoJTLiszVdsXIEtPnx8ejDt+sSS5OwOy4YwKX0Iqnk76pcqWH2GHnZMuiO29EmMoh2ir/8gobHU7aVMDwWI3tBomLr88VbL3vmTcRlozo8D6X9p0FyA/qqLYtR6GOCnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTvlt3Hs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTvlt3Hs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF299C4CEE2;
	Wed, 23 Apr 2025 15:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421060;
	bh=vYi7b8G8mtqDazpYeVtS62KfVpcLXQLdTZ6o2TXVz+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTvlt3HsZ1rT4K9nDTnNNm6ZcMKqsL14YdgAT/RCAMkvvSlp0411iV1rxWSExq26I
	 Sj3aZ3WFOnzVdoE+JkpNN1XTT8ayg0Wzk67C4FFJraxKueEVPUKQ0u9vFjzJEr85+M
	 6gsp4nnPg2yCX0aAqdqrcMhduqrsZwtnGAROwP/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 143/393] media: i2c: ov7251: Introduce 1 ms delay between regulators and en GPIO
Date: Wed, 23 Apr 2025 16:40:39 +0200
Message-ID: <20250423142649.281817720@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 3d391292cdd53984ec1b9a1f6182a62a62751e03 upstream.

Lift the xshutdown (enable) GPIO 1 ms after enabling the regulators, as
required by the sensor's power-up sequence.

Fixes: d30bb512da3d ("media: Add a driver for the ov7251 camera sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov7251.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/i2c/ov7251.c
+++ b/drivers/media/i2c/ov7251.c
@@ -922,6 +922,8 @@ static int ov7251_set_power_on(struct de
 		return ret;
 	}
 
+	usleep_range(1000, 1100);
+
 	gpiod_set_value_cansleep(ov7251->enable_gpio, 1);
 
 	/* wait at least 65536 external clock cycles */


