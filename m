Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F65357D14;
	Tue, 16 Jun 2026 15:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624031; cv=none; b=QTlwksK9gKYlwIIgAYSLLCZ40EdPEU/oLAQ53fsmFoTiRr9xiWrrGwnT15lMYzB2tQOyj/YgNbEzncK5XAUiu20CQk9g0XBv+OPfzqui5jRwJZ7nMbV9xpejK9nFqIdzl34tu6p886V1N9oOf+4rAf7VvO3ZIFu5zCduaerv124=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624031; c=relaxed/simple;
	bh=2fKsGCQLoIqLDE+2m5GwRhSAg52oDpcybwXQd3NHQXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Im86Qltzm/GroLR+ZZ6xZEtoi/FT9ct62oFDUcz6SalQVozHcKRXd/TsIyXn0O9uLy+agf/AFJOGXGZArCrEqmkt2KKsx9ZLHi6VkOGKUDGfpz4zWVB/keHui0OE2d+xWohqQA1dcODUXnyrvmbEc0BdxQIhgRqsFmO4OzUsPE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+NgPyAP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+NgPyAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422571F000E9;
	Tue, 16 Jun 2026 15:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624030;
	bh=069C1Bs+D3RaGRgKMvPEYyDGFQDk7r+LCYWgT2aQ5TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R+NgPyAPQvzdSnq7n0PuiZ0wu50wlc9g1aLsVJPvQSiUxJENQXk4lumyATn33oo9u
	 /t4IpdG6GVd9FWWIqWvOL8fyYimLC/0Qu/GS/EphOxcm5Px8tJ3YJCrkeNUXkvSw8x
	 uHmU0sL6bOPt2CyRpjLFrcrQ1fG3kUXJONboxZy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.0 259/378] accel/ethosu: fix OOB write in ethosu_gem_cmdstream_copy_and_validate()
Date: Tue, 16 Jun 2026 20:28:10 +0530
Message-ID: <20260616145123.738530091@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit c0837b9cf6eabbad8b8cbddaff1a46a6d0a2e29d upstream.

The command stream parsing loop increments the index variable a second
time when a 64-bit command word is encountered (bit 14 set), but does
not re-check the loop bound before writing the second word:

    for (i = 0; i < size / 4; i++) {
        bocmds[i] = cmds[0];
        if (cmd & 0x4000) {
            i++;
            bocmds[i] = cmds[1];   /* unchecked */
        }
    }

The buffer bocmds is backed by a DMA allocation of exactly size bytes
from drm_gem_dma_create(ddev, size), giving valid indices [0, size/4-1].

When i == size/4 - 1 on entry to an iteration and bit 14 of cmds[0] is
set, bocmds[size/4-1] is written in bounds, i is then incremented to
size/4, and bocmds[size/4] writes four bytes past the end of the
allocation.

Userspace controls both the buffer contents and the size argument via
the ioctl, making this a userspace-triggerable heap out-of-bounds write.

Fix by checking the incremented index against the buffer bound before
the second write and returning -EINVAL if the buffer is too small to
contain the extended command.

Fixes: 5a5e9c0228e6 ("accel: Add Arm Ethos-U NPU driver")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260523190843.33977-1-meatuni001@gmail.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ethosu/ethosu_gem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/accel/ethosu/ethosu_gem.c
+++ b/drivers/accel/ethosu/ethosu_gem.c
@@ -387,6 +387,8 @@ static int ethosu_gem_cmdstream_copy_and
 				return -EFAULT;
 
 			i++;
+			if (i >= size / 4)
+				return -EINVAL;
 			bocmds[i] = cmds[1];
 			addr = cmd_to_addr(cmds);
 		}


