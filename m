Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC0E208BD
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WliRl7Cf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B52C433C8;
	Mon,  6 Nov 2023 13:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276600;
	bh=iWpPfdkyxx/LXzjzGOFBfjxQuJ2Ubp6hzMUheiQIDoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WliRl7Cfmv0tOkih+TqIzCCQVnZjvNT7s+uPkWu1/MGmbmpjP+OoNKC8OtmACq3ic
	 xJpy9QpnJg8r9M3CQHa3XqCrP29jzyBlPblPZznAe+q8vqYzuLujnnkZx+7MXRybAr
	 D9PRF9gxiaHNLM4CaaW9B/u0ut1vdKsGp7L77Fsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 34/88] x86/efistub: Dont try to print after ExitBootService()
Date: Mon,  6 Nov 2023 14:03:28 +0100
Message-ID: <20231106130307.057627261@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Borisov <nik.borisov@suse.com>

[ Upstream commit ff07186b4d774ac22a5345d30763045af4569416 ]

setup_e820() is executed after UEFI's ExitBootService has been called.
This causes the firmware to throw an exception because the Console IO
protocol is supposed to work only during boot service environment. As
per UEFI 2.9, section 12.1:

 "This protocol is used to handle input and output of text-based
 information intended for the system user during the operation of code
 in the boot services environment."

So drop the diagnostic warning from this function. We might add back a
warning that is issued later when initializing the kernel itself.

Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/x86-stub.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index 146477da2b98c..a5a856a7639e1 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -648,11 +648,8 @@ setup_e820(struct boot_params *params, struct setup_data *e820ext, u32 e820ext_s
 			break;
 
 		case EFI_UNACCEPTED_MEMORY:
-			if (!IS_ENABLED(CONFIG_UNACCEPTED_MEMORY)) {
-				efi_warn_once(
-"The system has unaccepted memory,  but kernel does not support it\nConsider enabling CONFIG_UNACCEPTED_MEMORY\n");
+			if (!IS_ENABLED(CONFIG_UNACCEPTED_MEMORY))
 				continue;
-			}
 			e820_type = E820_TYPE_RAM;
 			process_unaccepted_memory(d->phys_addr,
 						  d->phys_addr + PAGE_SIZE * d->num_pages);
-- 
2.42.0



