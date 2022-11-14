Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E3B4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3AAC433D6;
	Mon, 14 Nov 2022 12:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430298;
	bh=Di0Af/XdUnQFK+JFCitbilKiah3SPXemstEhZqXURJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UotzoC6XC3/dMrwEq2ST9kRqa/8j/BahRe27eRUzgcLDnSZJ2Pv6ACeBRLsH2XpRQ
	 K6b+2HQIZIe3TuE9G8YDP1TwPNc84tXJVF31c8D1bF5sG637sna6JwhwDdRO9cWefG
	 o9a40Oqlxbg3km9/TbpogtpwYnlcfkxftX3JiNX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 76/95] mm/memremap.c: map FS_DAX device memory as decrypted
Date: Mon, 14 Nov 2022 13:46:10 +0100
Message-Id: <20221114124445.709086725@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pankaj Gupta <pankaj.gupta@amd.com>

commit 867400af90f1f953ff9e10b1b87ecaf9369a7eb8 upstream.

virtio_pmem use devm_memremap_pages() to map the device memory.  By
default this memory is mapped as encrypted with SEV.  Guest reboot changes
the current encryption key and guest no longer properly decrypts the FSDAX
device meta data.

Mark the corresponding device memory region for FSDAX devices (mapped with
memremap_pages) as decrypted to retain the persistent memory property.

Link: https://lkml.kernel.org/r/20221102160728.3184016-1-pankaj.gupta@amd.com
Fixes: b7b3c01b19159 ("mm/memremap_pages: support multiple ranges per invocation")
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memremap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -348,6 +348,7 @@ void *memremap_pages(struct dev_pagemap
 			WARN(1, "File system DAX not supported\n");
 			return ERR_PTR(-EINVAL);
 		}
+		params.pgprot = pgprot_decrypted(params.pgprot);
 		break;
 	case MEMORY_DEVICE_GENERIC:
 		break;


