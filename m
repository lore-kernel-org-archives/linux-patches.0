Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFA68837;
	Mon, 28 Oct 2024 06:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098268; cv=none; b=mg/RKkWNNtKkJA5Drfyb4WCePrRHdrM3NczZ3YK2W1FudOZv7sQROpGaSaCoa6Nz1e2C3/3clE6NJ4z1nde6HuuLzUQfafyJjiGNVCd2+CBvEKMWgmWVY1OcVVnmSpsjj/ZF/l8lqOhScv+aME7Vbqc0ivhrPckmWADX9LGBfqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098268; c=relaxed/simple;
	bh=zHrtZO3fDefGEo5K3iJtpkZvN37yh/6mtGN59OT5fUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7JyHPAZHIRMIx4zvAi5mGy47qI+d4HV9lxWnhcHccwA8QLILFsu1biSteDL4kB1YKXvUJxOjGHCToysopG/TCQraOV6b0vwhqFy2uYSWIhm6DWMuKgX76iL4ZijsBxuSIfbUXAyX7yAzmX9eAGeX07KN7bOE0F29lk6sH3wmpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+6K4M6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+6K4M6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30544C4CEC3;
	Mon, 28 Oct 2024 06:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098267;
	bh=zHrtZO3fDefGEo5K3iJtpkZvN37yh/6mtGN59OT5fUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+6K4M6T9mVxg/ZlvIyY8WMnV5CoEQc7TEltPjSKHAiB3+wSu1VXU5iNi1BfulN+k
	 LQakzzMPBGX+O4mIkNsXKVOdE6bOusLe+LoltYK2ZGaxFO9ud2QE1zTLGKAV54pcP3
	 9H4ZuAMtAl7Z3V3DSdGKXsa4dpctObaVpgHd2+0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Rashleigh <peter@rashleigh.ca>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 152/261] net: dsa: mv88e6xxx: Fix error when setting port policy on mv88e6393x
Date: Mon, 28 Oct 2024 07:24:54 +0100
Message-ID: <20241028062315.841444592@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Rashleigh <peter@rashleigh.ca>

[ Upstream commit 12bc14949c4a7272b509af0f1022a0deeb215fd8 ]

mv88e6393x_port_set_policy doesn't correctly shift the ptr value when
converting the policy format between the old and new styles, so the
target register ends up with the ptr being written over the data bits.

Shift the pointer to align with the format expected by
mv88e6393x_port_policy_write().

Fixes: 6584b26020fc ("net: dsa: mv88e6xxx: implement .port_set_policy for Amethyst")
Signed-off-by: Peter Rashleigh <peter@rashleigh.ca>
Reviewed-by: Simon Horman <horms@kernel.org>
Message-ID: <20241016040822.3917-1-peter@rashleigh.ca>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/port.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 5394a8cf7bf1d..04053fdc6489a 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1713,6 +1713,7 @@ int mv88e6393x_port_set_policy(struct mv88e6xxx_chip *chip, int port,
 	ptr = shift / 8;
 	shift %= 8;
 	mask >>= ptr * 8;
+	ptr <<= 8;
 
 	err = mv88e6393x_port_policy_read(chip, port, ptr, &reg);
 	if (err)
-- 
2.43.0



