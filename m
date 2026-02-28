Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56B1313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301034; cv=none; b=HrU6lS/BqJbDUDJ/v0LoEOYPaamhqo52DHfmDJYrS7ahWSQVJEqX6QfsBSnzgABl10fDBhB48AwvSZ3iFyJ0qi7d1oyEwqg9Vd7QT/BLAu/60MeRyz1kNFJCvl8F4Q7QBoKX69v9em/bJ0HOWGIE0P2m0aZsL08LuhmJLQfkv0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301034; c=relaxed/simple;
	bh=In2dEzgRQhkET1JyDUBYmQbxdy3S2uzNqXaE3eNgILw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jyv5ZSmJft9PYpLwhjhgW3Irk0neVy79Z8zcN81nlJ8DHZm8vBQdZuVuSNFgWyBInoX/wmB/TE8iZ4HmTq/9WXIMe3olbGhi9+6+Qhp4qpkF6EYGodVVY7dcO1oKt1GmzjNaqgUbhgvTJcqwBpnJbvFOxN0O+nILA02JHtYT8G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U5bfkuv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U5bfkuv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78C0C19423;
	Sat, 28 Feb 2026 17:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301034;
	bh=In2dEzgRQhkET1JyDUBYmQbxdy3S2uzNqXaE3eNgILw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5bfkuv+SaSk6mglwuLmShdtS9+AH+aGG7c1XjORHO4nAiA7CGHf8Bd09XEXdwYm1
	 hI5La/n+jqdIQ9q6yQvzM1+DNjRspsP96m+qhOqcd+Rr//HLjr/D66oneImSI8guf6
	 byrUX5gRHihQl8bo2rKEH1Mbt96hVPF9XgqgUy9q+ndKW+LNJCuwR4l8WLYrURwlGG
	 Gtz2aQf1uOq/9IfA7lwIMCoCf5aRn6s9Dr7LqhpW8VmcWWG9kqwMTBry+qQOltMGU/
	 ibJromw6TtH0Kv0ZJbsLOxpjxW+w0VLuSVaBhn6vl2NaDBvw061qlrUp13ADIlWH3E
	 Ztu2GM2nL4egQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nicolas Schier <nsc@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 172/752] virt: vbox: uapi: Mark inner unions in packed structs as packed
Date: Sat, 28 Feb 2026 12:38:03 -0500
Message-ID: <20260228174750.1542406-172-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit c25d01e1c4f2d43f47af87c00e223f5ca7c71792 ]

The unpacked unions within a packed struct generates alignment warnings
on clang for 32-bit ARM:

./usr/include/linux/vbox_vmmdev_types.h:239:4: error: field u within 'struct vmmdev_hgcm_function_parameter32'
  is less aligned than 'union (unnamed union at ./usr/include/linux/vbox_vmmdev_types.h:223:2)'
  and is usually due to 'struct vmmdev_hgcm_function_parameter32' being packed,
  which can lead to unaligned accesses [-Werror,-Wunaligned-access]
     239 |         } u;
         |           ^

./usr/include/linux/vbox_vmmdev_types.h:254:6: error: field u within
  'struct vmmdev_hgcm_function_parameter64::(anonymous union)::(unnamed at ./usr/include/linux/vbox_vmmdev_types.h:249:3)'
  is less aligned than 'union (unnamed union at ./usr/include/linux/vbox_vmmdev_types.h:251:4)' and is usually due to
  'struct vmmdev_hgcm_function_parameter64::(anonymous union)::(unnamed at ./usr/include/linux/vbox_vmmdev_types.h:249:3)'
  being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]

With the recent changes to compile-test the UAPI headers in more cases,
these warning in combination with CONFIG_WERROR breaks the build.

Fix the warnings.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512140314.DzDxpIVn-lkp@intel.com/
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/linux-kbuild/20260110-uapi-test-disable-headers-arm-clang-unaligned-access-v1-1-b7b0fa541daa@kernel.org/
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/linux-kbuild/29b2e736-d462-45b7-a0a9-85f8d8a3de56@app.fastmail.com/
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Nicolas Schier <nsc@kernel.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260115-kbuild-alignment-vbox-v1-2-076aed1623ff@linutronix.de
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/vbox_vmmdev_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/vbox_vmmdev_types.h b/include/uapi/linux/vbox_vmmdev_types.h
index 6073858d52a2e..11f3627c3729b 100644
--- a/include/uapi/linux/vbox_vmmdev_types.h
+++ b/include/uapi/linux/vbox_vmmdev_types.h
@@ -236,7 +236,7 @@ struct vmmdev_hgcm_function_parameter32 {
 			/** Relative to the request header. */
 			__u32 offset;
 		} page_list;
-	} u;
+	} __packed u;
 } __packed;
 VMMDEV_ASSERT_SIZE(vmmdev_hgcm_function_parameter32, 4 + 8);
 
@@ -251,7 +251,7 @@ struct vmmdev_hgcm_function_parameter64 {
 			union {
 				__u64 phys_addr;
 				__u64 linear_addr;
-			} u;
+			} __packed u;
 		} __packed pointer;
 		struct {
 			/** Size of the buffer described by the page list. */
-- 
2.51.0

