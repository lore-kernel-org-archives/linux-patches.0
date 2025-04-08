Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC16626F47A;
	Tue,  8 Apr 2025 12:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117108; cv=none; b=AFyjT+4mHrZ3P3+t5fW7nxRiFXjnygdTmgViX9JCL7JVI82x8G/2mssFKHF5UvggNBxwfaecrFEtq4qi+n0+yVcqoVvvaP7qpupW9+dCwenO1u1wt2hJY4Kx1EWUu9uJEFY4k1HO9BnV66dI0WVVKYoVJVvMUHRNP8OsBbLVZ5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117108; c=relaxed/simple;
	bh=g18HDSRfK518+95IS0pJcT4chErZqw6dmAjl3INEXE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lz8VW7q6BWU353Ai3j10AFB6tH3PhVpw5ILajGVwilW7GDnagpJr4X1GT0DLnO/R/OGkp86vnzpZxdfJrPjvyNReXGEyNv5LEcBxtIW5mf0Dpn4xx3QAJITTWSLM3oilQym0qGiMQqm1qAvvHc/E0PmWrWgrryUBIui4I0POLr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7unpNlC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7unpNlC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D271C4CEE7;
	Tue,  8 Apr 2025 12:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117108;
	bh=g18HDSRfK518+95IS0pJcT4chErZqw6dmAjl3INEXE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7unpNlCBnrRSHlm5NyWF1VxkEZwK0bEEJAgRj6wqvFAXzvsjnc1K4dxOcwsunqVH
	 781MKH7/7KwvBoRMqGNK5zTXts0m0ZE20W99quECK4LyBfrCUB7PAY7cHbrV4opnil
	 hoaF1MsjlUE/BZ5D87hVkYQIH0hDF069PchXNB4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c80d8dc0d9fa81a3cd8c@syzkaller.appspotmail.com,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH 6.12 385/423] acpi: nfit: fix narrowing conversion in acpi_nfit_ctl
Date: Tue,  8 Apr 2025 12:51:51 +0200
Message-ID: <20250408104854.853363479@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@mt-integration.ru>

commit 2ff0e408db36c21ed3fa5e3c1e0e687c82cf132f upstream.

Syzkaller has reported a warning in to_nfit_bus_uuid(): "only secondary
bus families can be translated". This warning is emited if the argument
is equal to NVDIMM_BUS_FAMILY_NFIT == 0. Function acpi_nfit_ctl() first
verifies that a user-provided value call_pkg->nd_family of type u64 is
not equal to 0. Then the value is converted to int, and only after that
is compared to NVDIMM_BUS_FAMILY_MAX. This can lead to passing an invalid
argument to acpi_nfit_ctl(), if call_pkg->nd_family is non-zero, while
the lower 32 bits are zero.

Furthermore, it is best to return EINVAL immediately upon seeing the
invalid user input.  The WARNING is insufficient to prevent further
undefined behavior based on other invalid user input.

All checks of the input value should be applied to the original variable
call_pkg->nd_family.

[iweiny: update commit message]

Fixes: 6450ddbd5d8e ("ACPI: NFIT: Define runtime firmware activation commands")
Cc: stable@vger.kernel.org
Reported-by: syzbot+c80d8dc0d9fa81a3cd8c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c80d8dc0d9fa81a3cd8c
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Link: https://patch.msgid.link/20250123163945.251-1-m.masimov@mt-integration.ru
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/nfit/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -485,7 +485,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_desc
 		cmd_mask = nd_desc->cmd_mask;
 		if (cmd == ND_CMD_CALL && call_pkg->nd_family) {
 			family = call_pkg->nd_family;
-			if (family > NVDIMM_BUS_FAMILY_MAX ||
+			if (call_pkg->nd_family > NVDIMM_BUS_FAMILY_MAX ||
 			    !test_bit(family, &nd_desc->bus_family_mask))
 				return -EINVAL;
 			family = array_index_nospec(family,


