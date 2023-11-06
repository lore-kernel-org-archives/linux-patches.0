Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E7E210F9
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9LKSYtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E59AC433C8;
	Mon,  6 Nov 2023 13:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276371;
	bh=JbOhGG0L+nOujUWVMF9FT48n5SkBbTxOktCeoHIIITM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9LKSYtDz6CJqBYbiXFCU+Rq9TmNpg2BkKxzit0/CgqZPTJvHG6T0KMcqzx7oWAVU
	 YJ5opTxtvotCopm1RlDQMkHkMPok5P1FUVtEuJcFXvIj/WwhFtXESk0RIsUzEqLCxs
	 NSQOgQqtfHzXJiocyUq5FLq/Qq4ojx2gKovZMqEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 20/62] efi: fix memory leak in krealloc failure handling
Date: Mon,  6 Nov 2023 14:03:26 +0100
Message-ID: <20231106130302.548256565@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
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

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit 0d3ad1917996839a5042d18f04e41915cfa1b74a ]

In the previous code, there was a memory leak issue where the
previously allocated memory was not freed upon a failed krealloc
operation. This patch addresses the problem by releasing the old memory
before setting the pointer to NULL in case of a krealloc failure. This
ensures that memory is properly managed and avoids potential memory
leaks.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index b43e5e6ddaf6e..b7c0e8cc0764f 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -245,9 +245,13 @@ static __init int efivar_ssdt_load(void)
 		if (status == EFI_NOT_FOUND) {
 			break;
 		} else if (status == EFI_BUFFER_TOO_SMALL) {
-			name = krealloc(name, name_size, GFP_KERNEL);
-			if (!name)
+			efi_char16_t *name_tmp =
+				krealloc(name, name_size, GFP_KERNEL);
+			if (!name_tmp) {
+				kfree(name);
 				return -ENOMEM;
+			}
+			name = name_tmp;
 			continue;
 		}
 
-- 
2.42.0



