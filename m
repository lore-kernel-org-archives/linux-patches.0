Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AE826B098;
	Thu, 13 Feb 2025 15:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460728; cv=none; b=J8YfkvOKNMYvaZruy/ciSyuJQlUdUHKwKfUTnlchD0rxWj6NffS5JqL35Y2R4Dxkm5AvnWEhe/oNdqFCTB4AfoF3v79yJERZ7y9v6RGDfUG/NtH3UroKKB1P94FWoTUGCZIUiekEVp6V8AA0AvPjez8wXIjKsy325Qxi7FRrEa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460728; c=relaxed/simple;
	bh=hvmDQ8GRe/D6DqqaZBuxtdnCaxJxRNN3SLbGJRk3mmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xl9jj2hI7WGdDM54k4zZHf/Y3lsiTemqkcW7afwIfZuhBGY00q1BrgowGojlxL+pI6GRoS7JChqK0VkcPHFcR5oflU1JgrBsUUjNm15Gjr7u/H39IyaZwNMoNy/89GAefnrf6ta4BOJmatmkL3yDeIlvtqmiRmAPFIES7PVI2tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBX2gzv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBX2gzv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F69C4CED1;
	Thu, 13 Feb 2025 15:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460728;
	bh=hvmDQ8GRe/D6DqqaZBuxtdnCaxJxRNN3SLbGJRk3mmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBX2gzv5oGHVIbw1pWV2wIIFbObAtXYfs9N316Q9/g0YilXebBOznTPVnNatYpPAQ
	 kszNK3stgeOQupy1BlfbC+UDknBdtJV7e0/c3WJF+hf5ThmO83vwPgSDcV+ntAox9E
	 TnLtp4MqWppWJqPVvj6DtJ0u7jcMO1hf5IgDdn54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aubrey Li <aubrey.li@linux.intel.com>,
	Koba Ko <kobak@nvidia.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shi Liu <aurelianliu@tencent.com>
Subject: [PATCH 6.6 195/273] ACPI: PRM: Remove unnecessary strict handler address checks
Date: Thu, 13 Feb 2025 15:29:27 +0100
Message-ID: <20250213142415.031840218@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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
@@ -263,9 +263,7 @@ static acpi_status acpi_platformrt_space
 		if (!handler || !module)
 			goto invalid_guid;
 
-		if (!handler->handler_addr ||
-		    !handler->static_data_buffer_addr ||
-		    !handler->acpi_param_buffer_addr) {
+		if (!handler->handler_addr) {
 			buffer->prm_status = PRM_HANDLER_ERROR;
 			return AE_OK;
 		}


