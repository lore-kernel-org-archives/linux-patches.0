Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CE22580F7;
	Tue, 25 Mar 2025 12:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906166; cv=none; b=UOQ+DJajQuFYvPwbTf8arlVE6JaP/1phqm5TzSztOu0dSOIZhdkt1yR3kokoW/6zNmc63lArJ2/lb5eC1DVA37CR1WFU4nur8CM/S70nVGk2uvAk4mbWoYGzVFgEdOKluQxpYRkQPfqnScjj/EOSYxW+YydxDkzkEzbWwzmecA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906166; c=relaxed/simple;
	bh=DB0/tbY9t2YQ81OYEPJje8svNPAetLFs/epY4Ph+ypQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaV8ZRVJPgjTJ7cIDKZ9WcrJ6PQlh2mUU08giW700iVlN2fk8tU+lLbMtdi3Io22+Pj+/3f1Q9lLeuliazJ9ggqb/IbP85Z2O7Ipsof6tZXcxk5kn7Ezs5VJopFmbgyaKMPIVkOByzS9B/mjuS6xhSRYNk0CZLwH2oxV1898Wy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVTHKEYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVTHKEYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E16C4CEE4;
	Tue, 25 Mar 2025 12:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906166;
	bh=DB0/tbY9t2YQ81OYEPJje8svNPAetLFs/epY4Ph+ypQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVTHKEYBCB6gca/9rhjRTQMh9+9lH16TudGpGUtcPid93eolkfQBG0TzLtordMAeC
	 2Pvtz2jQsFdJAYVTL85EHaxg7lTSLMTKvBWvd2PgKxdCNp5r8yIK3RApdtgpcs6oRQ
	 bJGxLTW3x0TeSIcbz3Wu9AqNS+bqwhXFcbLUjEaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Schneider <ben@bens.haus>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 51/77] efi/libstub: Avoid physical address 0x0 when doing random allocation
Date: Tue, 25 Mar 2025 08:22:46 -0400
Message-ID: <20250325122145.686462514@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit cb16dfed0093217a68c0faa9394fa5823927e04c upstream.

Ben reports spurious EFI zboot failures on a system where physical RAM
starts at 0x0. When doing random memory allocation from the EFI stub on
such a platform, a random seed of 0x0 (which means no entropy source is
available) will result in the allocation to be placed at address 0x0 if
sufficient space is available.

When this allocation is subsequently passed on to the decompression
code, the 0x0 address is mistaken for NULL and the code complains and
gives up.

So avoid address 0x0 when doing random allocation, and set the minimum
address to the minimum alignment.

Cc: <stable@vger.kernel.org>
Reported-by: Ben Schneider <ben@bens.haus>
Tested-by: Ben Schneider <ben@bens.haus>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/randomalloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/firmware/efi/libstub/randomalloc.c
+++ b/drivers/firmware/efi/libstub/randomalloc.c
@@ -75,6 +75,10 @@ efi_status_t efi_random_alloc(unsigned l
 	if (align < EFI_ALLOC_ALIGN)
 		align = EFI_ALLOC_ALIGN;
 
+	/* Avoid address 0x0, as it can be mistaken for NULL */
+	if (alloc_min == 0)
+		alloc_min = align;
+
 	size = round_up(size, EFI_ALLOC_ALIGN);
 
 	/* count the suitable slots in each memory map entry */


