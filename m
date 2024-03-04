Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE4F8F58;
	Mon,  4 Mar 2024 21:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588492; cv=none; b=Ry5OsFzeueBrFxyoip1S7WDa9YwR05+FS87mwEnF/zKBfLl9uYHHyezNDjISe3cea15aPBVLNdnUu3Db/1luEpzuBjrSrjI+0ROnVvNmfvA3m/sDpahyKy1cyATt0MWKs8qa2TOnjwDUipceynmXFFr7ZKCNGB+UNdbYcHJj08Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588492; c=relaxed/simple;
	bh=CL4xP+jcV3wo/j8YAqQIdtBg3DWfdUhli5ha4rz5MHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWBHKrI+EOrj0dYpd8Of9R2ygjVmcN44rKL+Pxv5DDO2VwFdxOjyovwTxYNGeTkEs/TZW2PvF871P6lnMq9SipeGOQVw1WB3jSU2Ut7XdGmRaNPfg6iRVaqKPQ45+ooI/N6LOv7Z1pjoA8mBzlXgPteqQu9SSZCpSf6UVG63oqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAm86MOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAm86MOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BA6C433C7;
	Mon,  4 Mar 2024 21:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588492;
	bh=CL4xP+jcV3wo/j8YAqQIdtBg3DWfdUhli5ha4rz5MHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jAm86MOWZObMzpHjO8wrF/v+dz7CkH/1BI74PlcLHCMS7zgcCxeLN30viQTBP0YUu
	 4On/7tQSLWAKPW/5wRGPStoj/ooMh62xQ2wk5PTs2el1Fq6y25978agixKu3PLw7lu
	 eW+t4oVsoxZqm5w2fTk2xzNWEkbSnERuPHBpHJXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Bohac <jbohac@suse.cz>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.6 104/143] x86/e820: Dont reserve SETUP_RNG_SEED in e820
Date: Mon,  4 Mar 2024 21:23:44 +0000
Message-ID: <20240304211553.233094846@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


