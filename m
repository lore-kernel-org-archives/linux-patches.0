Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4199221FF2B;
	Mon, 23 Jun 2025 22:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716510; cv=none; b=aagLZqobXEuE1DJGKZcOtXreyocbW2Lg82rZLWUbmEZnseA0wqv100Hhmt6ikshOPLraD4yRPKwW6kqtYn7IHhKWuvERTVEAo3DE4V13+8Aeu7TxfzAkAnWFvhtChYpcrYs5k7rWH97KQ9/TJ7G8ozt+VlGoWErRgAqJxR2ZE/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716510; c=relaxed/simple;
	bh=11h6b96LvNhv0FYJ7gUkqkYCOVIcL8tUCifJHYjh/Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0T0/hbKzW8r05UTEXCT8BbJrGo2lryi5DC19pq+bprH/OVkZFrpYgdIgNw8mkv8LmQ07DHJOllBc71PH+eM4GUeRAD7vO9smYO9Txg/SVVlH95/Yt8P6sdlnHGO1V4qt2kevkyuaLs25kx6D35Yh2hdT1ceyy3AwFZivJMVNVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyBGtkd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyBGtkd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE44CC4CEEA;
	Mon, 23 Jun 2025 22:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716510;
	bh=11h6b96LvNhv0FYJ7gUkqkYCOVIcL8tUCifJHYjh/Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyBGtkd4tpx/jhQAj0otL4vU91OBN1T2t9aLQQkFVUlGnAW2Y3FHUaWhIyIZVaGY0
	 8Y/83EZ6foC9D5rt+wIDvZvLFv2Bwk1FttyEcJ6qFNh08CWUMReswbIsUQWWhMz/ks
	 THl7fy6z5G9uaN2IgHHLBHDls/oJIMupeb6kk7ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH 6.15 557/592] x86/mm: Disable INVLPGB when PTI is enabled
Date: Mon, 23 Jun 2025 15:08:35 +0200
Message-ID: <20250623130713.691846764@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave.hansen@linux.intel.com>

commit 94a17f2dc90bc7eae36c0f478515d4bd1c23e877 upstream.

PTI uses separate ASIDs (aka. PCIDs) for kernel and user address
spaces. When the kernel needs to flush the user address space, it
just sets a bit in a bitmap and then flushes the entire PCID on
the next switch to userspace.

This bitmap is a single 'unsigned long' which is plenty for all 6
dynamic ASIDs. But, unfortunately, the INVLPGB support brings along a
bunch more user ASIDs, as many as ~2k more. The bitmap can't address
that many.

Fortunately, the bitmap is only needed for PTI and all the CPUs
with INVLPGB are AMD CPUs that aren't vulnerable to Meltdown and
don't need PTI. The only way someone can run into an issue in
practice is by booting with pti=on on a newer AMD CPU.

Disable INVLPGB if PTI is enabled. Avoid overrunning the small
bitmap.

Note: this will be fixed up properly by making the bitmap bigger.
For now, just avoid the mostly theoretical bug.

Fixes: 4afeb0ed1753 ("x86/mm: Enable broadcast TLB invalidation for multi-threaded processes")
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Rik van Riel <riel@surriel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250610222420.E8CBF472%40davehans-spike.ostc.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pti.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -98,6 +98,11 @@ void __init pti_check_boottime_disable(v
 		return;
 
 	setup_force_cpu_cap(X86_FEATURE_PTI);
+
+	if (cpu_feature_enabled(X86_FEATURE_INVLPGB)) {
+		pr_debug("PTI enabled, disabling INVLPGB\n");
+		setup_clear_cpu_cap(X86_FEATURE_INVLPGB);
+	}
 }
 
 static int __init pti_parse_cmdline(char *arg)


