Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC1B1F60A;
	Mon,  4 Mar 2024 21:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587928; cv=none; b=E9qOM6SySBnfc/L2HffjSMWeu0BRkWJxrU4CppgJ27VHvKV1EqhDUL1J5c87mCjk53+VIHIhHUSUzhoaG9DYNJz1D7aJvYuGrRMabVOsj2/cL1LWmk+rS9OZUJNiiX5KlJQZc1/C92BzTzYRBMEEePySGncSsmEJk+d9E2TLMHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587928; c=relaxed/simple;
	bh=RsR9Ns1txt4ZyZNU8NMfXfTPsabALy1HqOqcSZRTC54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8LDZy0gULcnjwZ56f1u9f/XVywZlCtEQovgyYsDYHnm7wBNxjfAtfDb5sqOfNZHl8sUY9b+1Pggqpyw6WUbjPBzMKmzwynt5pjI9Yu7YR21C6v4qSsoNljJbEj/iTwTAO2w0WBzpIIhaHgj4IU0BPXcV7N/nbfC8dOwdRW2VGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVxxzPP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVxxzPP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E90C433F1;
	Mon,  4 Mar 2024 21:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587927;
	bh=RsR9Ns1txt4ZyZNU8NMfXfTPsabALy1HqOqcSZRTC54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVxxzPP7TOkT6jjYb9w7/CZFaKxykAg4dkedkQqwAtuJoPLOHJqIEAxSfCZO903nk
	 jFEiJ4qzziwSc1+KhqTeD8biPqCiwap39Pqd8Fr6CmS4mctUGFvp9CKEudhwEjvhVW
	 ivBOD8JV0FVZBZZ6woZnxtThnF98V7RDwYxIVA7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Bohac <jbohac@suse.cz>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.7 119/162] x86/e820: Dont reserve SETUP_RNG_SEED in e820
Date: Mon,  4 Mar 2024 21:23:04 +0000
Message-ID: <20240304211555.561440499@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Bohac <jbohac@suse.cz>

commit 7fd817c906503b6813ea3b41f5fdf4192449a707 upstream.

SETUP_RNG_SEED in setup_data is supplied by kexec and should
not be reserved in the e820 map.

Doing so reserves 16 bytes of RAM when booting with kexec.
(16 bytes because data->len is zeroed by parse_setup_data so only
sizeof(setup_data) is reserved.)

When kexec is used repeatedly, each boot adds two entries in the
kexec-provided e820 map as the 16-byte range splits a larger
range of usable memory. Eventually all of the 128 available entries
get used up. The next split will result in losing usable memory
as the new entries cannot be added to the e820 map.

Fixes: 68b8e9713c8e ("x86/setup: Use rng seeds from setup_data")
Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/ZbmOjKnARGiaYBd5@dwarf.suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/e820.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1017,10 +1017,12 @@ void __init e820__reserve_setup_data(voi
 		e820__range_update(pa_data, sizeof(*data)+data->len, E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
 
 		/*
-		 * SETUP_EFI and SETUP_IMA are supplied by kexec and do not need
-		 * to be reserved.
+		 * SETUP_EFI, SETUP_IMA and SETUP_RNG_SEED are supplied by
+		 * kexec and do not need to be reserved.
 		 */
-		if (data->type != SETUP_EFI && data->type != SETUP_IMA)
+		if (data->type != SETUP_EFI &&
+		    data->type != SETUP_IMA &&
+		    data->type != SETUP_RNG_SEED)
 			e820__range_update_kexec(pa_data,
 						 sizeof(*data) + data->len,
 						 E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);


