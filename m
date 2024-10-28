Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AD318EFC8;
	Mon, 28 Oct 2024 06:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097355; cv=none; b=YZu1BYzVT/eqjkz3R4QhNm04mcts5mTI6J9VWxveAHcSmKTIryD+TPnScDDpCF+6Y+bpVgDXM/IlgV4VqOFMf0nZgHhjE3eNu1Bv9iwj39aeYfhOYFr88BZ3WYSNprC5QhHpNgv28cTW813Eivl3QSiYyVY1fEqY/+gDS8SngWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097355; c=relaxed/simple;
	bh=TiqSUCiXMBzRQhrSmmYriJOQ/LhgZ3wFP5QCtFuK5S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TX03knQEE1ohwTSyfDLDedB/s/NX5O536Y9CnCK/hzuW65UFya7o/F4TDduD3uAT+IolSxSH7M6Le/YzMoSnG7K9gvAZEqaIB8vWGiaYwnJyZ51Y0OQwdM9FTk+awP+0LeV07nsvoNxBb3VzyhHmyqeRQ40zL0BzK3Taq5c8zXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGRm8MYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGRm8MYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3653C4CEC3;
	Mon, 28 Oct 2024 06:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097355;
	bh=TiqSUCiXMBzRQhrSmmYriJOQ/LhgZ3wFP5QCtFuK5S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGRm8MYU7G+xTbZG1XeTjEgCQo4ezM8HmC96Ml2rGkBZy2Vbr0Ec/srF+kqhZybBt
	 DI7F8x2Yk1MTNjXHWAJGLoeVB6KxARw7ZG4+r+Xye7vXxPTteEKuIZHi9UhJvMizVN
	 /u48ZzDovy4Q5nkfE41bClt/EcNlCVnj93Zs/IFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Rashleigh <peter@rashleigh.ca>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/137] net: dsa: mv88e6xxx: Fix error when setting port policy on mv88e6393x
Date: Mon, 28 Oct 2024 07:25:30 +0100
Message-ID: <20241028062301.326934664@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f79cf716c541f..553f577c25a6b 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1728,6 +1728,7 @@ int mv88e6393x_port_set_policy(struct mv88e6xxx_chip *chip, int port,
 	ptr = shift / 8;
 	shift %= 8;
 	mask >>= ptr * 8;
+	ptr <<= 8;
 
 	err = mv88e6393x_port_policy_read(chip, port, ptr, &reg);
 	if (err)
-- 
2.43.0



