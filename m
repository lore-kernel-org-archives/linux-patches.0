Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7340F15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCDDC433D6;
	Mon,  5 Dec 2022 19:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267829;
	bh=WAxraTpmsL1Q0ikHoa4tAU5Pl7RfxGgKHD8w32vFFS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2IgcPGX6kINKexyU2vBL+ulJdMkjace0Af777xNs6vAr7pde/uWS/lYAtuscpO83
	 BgU1sAV7a2sM9gxbMCYhT1NPXxvv3MoeZXUx6YtlI/f8ldWgWSSst4DvqrZGerAaVJ
	 oq7bIUvBXaPV7d4l3q63VSenxU0jF8CydTU4bhSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.14 66/77] efi: random: Properly limit the size of the random seed
Date: Mon,  5 Dec 2022 20:09:57 +0100
Message-Id: <20221205190803.196418876@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Hutchings <ben@decadent.org.uk>

Commit be36f9e7517e ("efi: READ_ONCE rng seed size before munmap")
added a READ_ONCE() and also changed the call to
add_bootloader_randomness() to use the local size variable.  Neither
of these changes was actually needed and this was not backported to
the 4.14 stable branch.

Commit 161a438d730d ("efi: random: reduce seed size to 32 bytes")
reverted the addition of READ_ONCE() and added a limit to the value of
size.  This depends on the earlier commit, because size can now differ
from seed->size, but it was wrongly backported to the 4.14 stable
branch by itself.

Apply the missing change to the add_bootloader_randomness() parameter
(except that here we are still using add_device_randomness()).

Fixes: 700485f70e50 ("efi: random: reduce seed size to 32 bytes")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -541,7 +541,7 @@ int __init efi_config_parse_tables(void
 			seed = early_memremap(efi.rng_seed,
 					      sizeof(*seed) + size);
 			if (seed != NULL) {
-				add_device_randomness(seed->bits, seed->size);
+				add_device_randomness(seed->bits, size);
 				early_memunmap(seed, sizeof(*seed) + size);
 				pr_notice("seeding entropy pool\n");
 			} else {


