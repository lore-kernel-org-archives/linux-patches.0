Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48924139566;
	Thu, 13 Feb 2025 15:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459689; cv=none; b=IFlVQClc+w31x9xe6PQaPLT6J1QxYdY6Od8wZ0XzVHjeTo7IS36XcZZTC2WnQvFMkLgMrQe5jSI4KdbGfSQ+WLu6SImggr9YF/JSr6BxiuoYI+ihPNOtblEn7BMrWYZkauw8Z1TP3azR6qy/9CPgMJ3DZxmKqP8bfAk3T35b3r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459689; c=relaxed/simple;
	bh=EbhIxQGrLHkQZVwU3NCFRfsq/4Oh1PgVs8OtOpXvdHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVNmgZop+pq5XfUVqDV6KAUgGWAKEnBTgTn9gUY9h0YUQt6A9yby9RaYj9thDrHQ52y+Kb9i5dfhgLiE7Bhj+vFXZhR4Pfpo7kAQzye1pBlmpxpIbOxus8WWkV54FfSu3SkhX6B+qCVPCGloU1EWB5Q1dvGzv8m5BHUn1p4Y0h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbdPf/Os; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbdPf/Os"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE9DC4CED1;
	Thu, 13 Feb 2025 15:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459689;
	bh=EbhIxQGrLHkQZVwU3NCFRfsq/4Oh1PgVs8OtOpXvdHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbdPf/Os/G18G7PMXLdBp4wKgJGwnlx/GQKXPF8UAglboorY8PV3dwcl51GxTaDan
	 LWAxucnrmqhLDQy3a4O6jMryEdKHA6epcPKDzLyV1JEjk8JTvYiKBH6QcjFbPeZc8K
	 w0jvMtRuVx6930wfOtVploQGz3y9POKjVc0u/Uac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aubrey Li <aubrey.li@linux.intel.com>,
	Koba Ko <kobak@nvidia.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shi Liu <aurelianliu@tencent.com>
Subject: [PATCH 6.13 335/443] ACPI: PRM: Remove unnecessary strict handler address checks
Date: Thu, 13 Feb 2025 15:28:20 +0100
Message-ID: <20250213142453.554052333@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aubrey Li <aubrey.li@linux.intel.com>

commit 7f5704b6a143b8eca640cba820968e798d065e91 upstream.

Commit 088984c8d54c ("ACPI: PRM: Find EFI_MEMORY_RUNTIME block for PRM
handler and context") added unnecessary strict handler address checks,
causing the PRM module to fail in translating memory error addresses.

Both static data buffer address and ACPI parameter buffer address may
be NULL if they are not needed, as described in section 4.1.2 PRM Handler
Information Structure of Platform Runtime Mechanism specification [1].

Here are two examples from real hardware:

----PRMT.dsl----

- staic data address is not used
[10Ch 0268   2]                     Revision : 0000
[10Eh 0270   2]                       Length : 002C
[110h 0272  16]                 Handler GUID : F6A58D47-E04F-4F5A-86B8-2A50D4AA109B
[120h 0288   8]              Handler address : 0000000065CE51F4
[128h 0296   8]           Satic Data Address : 0000000000000000
[130h 0304   8]       ACPI Parameter Address : 000000006522A718

- ACPI parameter address is not used
[1B0h 0432   2]                     Revision : 0000
[1B2h 0434   2]                       Length : 002C
[1B4h 0436  16]                 Handler GUID : 657E8AE6-A8FC-4877-BB28-42E7DE1899A5
[1C4h 0452   8]              Handler address : 0000000065C567C8
[1CCh 0460   8]           Satic Data Address : 000000006113FB98
[1D4h 0468   8]       ACPI Parameter Address : 0000000000000000

Fixes: 088984c8d54c ("ACPI: PRM: Find EFI_MEMORY_RUNTIME block for PRM handler and context")
Reported-and-tested-by: Shi Liu <aurelianliu@tencent.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
Link: https://uefi.org/sites/default/files/resources/Platform%20Runtime%20Mechanism%20-%20with%20legal%20notice.pdf # [1]
Reviewed-by: Koba Ko <kobak@nvidia.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://patch.msgid.link/20250126022250.3014210-1-aubrey.li@linux.intel.com
[ rjw: Minor changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/prmt.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/acpi/prmt.c
+++ b/drivers/acpi/prmt.c
@@ -287,9 +287,7 @@ static acpi_status acpi_platformrt_space
 		if (!handler || !module)
 			goto invalid_guid;
 
-		if (!handler->handler_addr ||
-		    !handler->static_data_buffer_addr ||
-		    !handler->acpi_param_buffer_addr) {
+		if (!handler->handler_addr) {
 			buffer->prm_status = PRM_HANDLER_ERROR;
 			return AE_OK;
 		}


