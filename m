Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3913BA243;
	Mon, 23 Mar 2026 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282355; cv=none; b=PQnMmxr9P7Va31cEYUknIwmsrUm5+26sXQ/KvNVJVCtlOiZou3k67JabxkFwd9+SuxkeMjRag8g3O8NrFD9xoLF5OCJRB+C2b4jJDAtziCbw5vN1eznMMhwdNrqL5rzvmREzliAh+A/WK7YoBseIkCz5gwpA/+eb34xhkfBHrRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282355; c=relaxed/simple;
	bh=nQvBCQtABAz4Mzx7OtQeDjBuZHy1V4H0hgZeoNPlSXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bua+6jQsFt5NM12JoL3srcxx/fl6zz4oRQHESFHZYjoZB33fxIkH1BbI0AtzerIg74+PO4yZMyXQUHwlIhOLXvqjF8s2xnNrP/Xy5M1FRq5Nz0gv3d0OK/QQeyDt+VXAKjm09g1vmfvjSHTzi5mwaCFi5RoGnfE3wplmV6JXhOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQZfe4Gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQZfe4Gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03AEC4CEF7;
	Mon, 23 Mar 2026 16:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282355;
	bh=nQvBCQtABAz4Mzx7OtQeDjBuZHy1V4H0hgZeoNPlSXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQZfe4GcpwY0K3/7BmZ0f8+jIfd78YTmv8BHmFJOdY1TWzfEWXAYlbl7Y4cTW3nlf
	 FdsKaZs96EStTtkg6ZOfPaa3D0Pm4cjk/T5YwvLnTwU4yY4REmG01G7X5GT/Qkgmxc
	 f2ai21PH/GD0Rslbts80lU9OI630ZajBBJmnrkXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thomson <dt@linux-mail.net>,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/481] xen/acpi-processor: fix _CST detection using undersized evaluation buffer
Date: Mon, 23 Mar 2026 14:41:47 +0100
Message-ID: <20260323134528.326445670@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: David Thomson <dt@linux-mail.net>

[ Upstream commit 8b57227d59a86fc06d4f09de08f98133680f2cae ]

read_acpi_id() attempts to evaluate _CST using a stack buffer of
sizeof(union acpi_object) (48 bytes), but _CST returns a nested Package
of sub-Packages (one per C-state, each containing a register descriptor,
type, latency, and power) requiring hundreds of bytes. The evaluation
always fails with AE_BUFFER_OVERFLOW.

On modern systems using FFH/MWAIT entry (where pblk is zero), this
causes the function to return before setting the acpi_id_cst_present
bit. In check_acpi_ids(), flags.power is then zero for all Phase 2 CPUs
(physical CPUs beyond dom0's vCPU count), so push_cxx_to_hypervisor() is
never called for them.

On a system with dom0_max_vcpus=2 and 8 physical CPUs, only PCPUs 0-1
receive C-state data. PCPUs 2-7 are stuck in C0/C1 idle, unable to
enter C2/C3. This costs measurable wall power (4W observed on an Intel
Core Ultra 7 265K with Xen 4.20).

The function never uses the _CST return value -- it only needs to know
whether _CST exists. Replace the broken acpi_evaluate_object() call with
acpi_has_method(), which correctly detects _CST presence using
acpi_get_handle() without any buffer allocation. This brings C-state
detection to parity with the P-state path, which already works correctly
for Phase 2 CPUs.

Fixes: 59a568029181 ("xen/acpi-processor: C and P-state driver that uploads said data to hypervisor.")
Signed-off-by: David Thomson <dt@linux-mail.net>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260224093707.19679-1-dt@linux-mail.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xen-acpi-processor.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index 9cb61db67efde..12877f85bb79d 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -379,11 +379,8 @@ read_acpi_id(acpi_handle handle, u32 lvl, void *context, void **rv)
 			 acpi_psd[acpi_id].domain);
 	}
 
-	status = acpi_evaluate_object(handle, "_CST", NULL, &buffer);
-	if (ACPI_FAILURE(status)) {
-		if (!pblk)
-			return AE_OK;
-	}
+	if (!pblk && !acpi_has_method(handle, "_CST"))
+		return AE_OK;
 	/* .. and it has a C-state */
 	__set_bit(acpi_id, acpi_id_cst_present);
 
-- 
2.51.0



