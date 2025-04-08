Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DB2265630;
	Tue,  8 Apr 2025 12:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116265; cv=none; b=DPTgRJ0lWW2Sk1qBg4AuHNIWXx5AM03FZ/jKrkQqrmfzInejmfT22i5swd9Wuvgeb/q9Mr9a4Xf3g/UaWJ3ciwooWXYxZBjYAyl5MMpZGakE8V60j4KB9oC27znjwC2FILus3++++eFPd2nwUFzeR7kucH2lDi7jFUQY18pyO/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116265; c=relaxed/simple;
	bh=SmZQmjMj5qzuspmHboY6KWYXfkfDTrfpC+gzim+/6hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdkNCE8ax75IQ27Y+y7yZQCh6PstJ3X0oy5eOSTNij8E63kQ1NgwNWgkBfs3IQg3nF6zfHpeEVRuG1ZQF+WduDSm7oRrRgxGGF3paJW4wk3tI3DO4KMDuCUPt/avsaoJmXhdTQFFnFJvYYn3cUuYvZYL9GzFu4I8Xtlc21KPx/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZP0w5OYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZP0w5OYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9162BC4CEE5;
	Tue,  8 Apr 2025 12:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116264;
	bh=SmZQmjMj5qzuspmHboY6KWYXfkfDTrfpC+gzim+/6hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZP0w5OYjS2sHdLgy1eVa5FG3gmg0iWC6/LXpN6RlDh74ZZk22rhD3s43zEftF3RO7
	 1MqSkrTfPMrisePl7h8pfz9GWa+AST2gZwMerk9Uq3CyXsa8CLCCoobBc3H8QzY3bn
	 51l5EN0sZ8pVSrjJWZjVMb3Pd/MW35yJKjrHySAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/423] drm/ssd130x: fix ssd132x encoding
Date: Tue,  8 Apr 2025 12:46:15 +0200
Message-ID: <20250408104846.890171863@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: John Keeping <jkeeping@inmusicbrands.com>

[ Upstream commit 1e14484677c8e87548f5f0d4eb8800e408004404 ]

The ssd132x buffer is encoded one pixel per nibble, with two pixels in
each byte.  When encoding an 8-bit greyscale input, take the top 4-bits
as the value and ensure the two pixels are distinct and do not overwrite
each other.

Fixes: fdd591e00a9c ("drm/ssd130x: Add support for the SSD132x OLED controller family")
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250115110139.1672488-2-jkeeping@inmusicbrands.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index 6f51bcf774e27..7d071a2f7a460 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -880,7 +880,7 @@ static int ssd132x_update_rect(struct ssd130x_device *ssd130x,
 			u8 n1 = buf[i * width + j];
 			u8 n2 = buf[i * width + j + 1];
 
-			data_array[array_idx++] = (n2 << 4) | n1;
+			data_array[array_idx++] = (n2 & 0xf0) | (n1 >> 4);
 		}
 	}
 
-- 
2.39.5



