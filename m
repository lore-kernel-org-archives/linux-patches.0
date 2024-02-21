Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BDE46B9B;
	Wed, 21 Feb 2024 13:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521530; cv=none; b=eKe1bG66Z1U7cdEusdcGvH4JHtYQxK/Tv2HlG8QQhqzRz0+2/vHm8l6CuBA5oXxSohyzfSfbyGJ9ENiL7ijpbhBdAJGo5xffqxgT56ENUAhFZhG2sGLhA22BWPJ025mJISbjnOhjCYkOGaG7UObK949ZGlHrJWGBIKwpvaBCKLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521530; c=relaxed/simple;
	bh=TOJGKluDssXYLbKhv9OpByf8usuHH59xEKeiBdilv8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZ1SWm7VSnMXC+eKH5b5BLN2imdME2pi/PbTZou0GhEtJJzXk0OUK1iT99lryA5X4al4pYJQrtwUg/2jAulEH8ddi+rfsWgRDw3iyk/6JeCYvo9IhaodtukItTNG3Ah5kYr+KzhS06V5kIecuwIJeSjVlAphgKXVDiQyHx6IR1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QR8OIvtI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QR8OIvtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8915C433C7;
	Wed, 21 Feb 2024 13:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521530;
	bh=TOJGKluDssXYLbKhv9OpByf8usuHH59xEKeiBdilv8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QR8OIvtINjDOnLN0/GXFzi4X/S7WLPhJuivsibI074Z0RtSORF1/ryqDT1nbIBD5A
	 rwIQew0IL2hinigouoCSVx10HeRQp5qwnfVa8hvAP1CHAw4e9mNRF07bCuQwYkJLxw
	 3lmjg41etpP4I0Ho8afirBdn3WsQ8QX70tsBNI6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 4.19 135/202] ixgbe: Fix an error handling path in ixgbe_read_iosf_sb_reg_x550()
Date: Wed, 21 Feb 2024 14:07:16 +0100
Message-ID: <20240221125936.070007641@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit bbc404d20d1b46d89b461918bc44587620eda200 ]

All error handling paths, except this one, go to 'out' where
release_swfw_sync() is called.
This call balances the acquire_swfw_sync() call done at the beginning of
the function.

Branch to the error handling path in order to correctly release some
resources in case of error.

Fixes: ae14a1d8e104 ("ixgbe: Fix IOSF SB access issues")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
index 2e52478f77b6..7b1471226fd8 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
@@ -717,7 +717,8 @@ static s32 ixgbe_read_iosf_sb_reg_x550(struct ixgbe_hw *hw, u32 reg_addr,
 		error = (command & IXGBE_SB_IOSF_CTRL_CMPL_ERR_MASK) >>
 			 IXGBE_SB_IOSF_CTRL_CMPL_ERR_SHIFT;
 		hw_dbg(hw, "Failed to read, error %x\n", error);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	if (!ret)
-- 
2.43.0



