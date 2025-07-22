Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78E92EA498;
	Tue, 22 Jul 2025 13:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192246; cv=none; b=MejfatYegP/7hOq2mHUtRqn7636X9iVHV9pZoXzODkqeuGikdb8GUf6X22c9KNewSCUT10i+fNvz0S0XZZ8il/7tw2DcqI7dI+QK8jylVxojAUIE54JjyEFKH9xF/DUCzFR4b/Ywt8/3qHBuO7NuG3a12xBlHwpRS8QO/Ll7jb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192246; c=relaxed/simple;
	bh=y4tZxu4lmuF5dL+STKmGsfV2e4bpoIMPmaMXf41ZcsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5iKYbRw/eRVPnIDb5bZmFEYExb+G0UXsUUBj+b13vg3r79qY2KiXn4FHWuTVUaspRvbhGGoa4vcjwjRmyjiYCNWGJrMBDmubL1XL+REolI/z5nhp5JN56N/W1ne8CqUOr6DNXNMSw0dUG2G2BlnMi+npWF5BuW0FzwlPNnXUYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gl4M99j5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gl4M99j5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281CEC4CEEB;
	Tue, 22 Jul 2025 13:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192246;
	bh=y4tZxu4lmuF5dL+STKmGsfV2e4bpoIMPmaMXf41ZcsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gl4M99j5gyf8K6f+k0D4os0lJaykn40xahpkP7o42JuqX4kp7MubCRsP27Zm7aNxJ
	 /hAVGMqTm813xa1sMpQnfJN1w7q0uO3k54qx02gfVezY/CCd2qINic/240JbIixOUn
	 KPijfgLCv1yafluQlxxYnToCbBuRE7MrRjU4J/NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 44/79] net: emaclite: Fix missing pointer increment in aligned_read()
Date: Tue, 22 Jul 2025 15:44:40 +0200
Message-ID: <20250722134329.998333681@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 7727ec1523d7973defa1dff8f9c0aad288d04008 ]

Add missing post-increment operators for byte pointers in the
loop that copies remaining bytes in xemaclite_aligned_read().
Without the increment, the same byte was written repeatedly
to the destination.
This update aligns with xemaclite_aligned_write()

Fixes: bb81b2ddfa19 ("net: add Xilinx emac lite device driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250710173849.2381003-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index ad2c30d9a4824..fb0e42ddb3adb 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -285,7 +285,7 @@ static void xemaclite_aligned_read(u32 *src_ptr, u8 *dest_ptr,
 
 		/* Read the remaining data */
 		for (; length > 0; length--)
-			*to_u8_ptr = *from_u8_ptr;
+			*to_u8_ptr++ = *from_u8_ptr++;
 	}
 }
 
-- 
2.39.5



