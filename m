Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209FB3563D4;
	Fri, 24 Apr 2026 13:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038084; cv=none; b=sLcnS/OGuQ1R2813JKNbUbdHDluZd3VHD2fOBYoiYL8G3UaU9Gw6X8ljHDkQyREWnVf/ClKtRXP0JSDGKef39UDKi2mAyMzpbYA9RiDXgUsjlc5KHI9dUnfGDn1KrHXW6MxwzF5B/HQKyxSKmAvr01/5XQl/BS3Iy1lZYVKIuBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038084; c=relaxed/simple;
	bh=aCPPCWEY6VPZP8ernkiEIARkUiYqormcO6d/E9gYadQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjfF6HC3zQMYA5KpNQjEePRQ4JLxlaJBjNFlXhfheePOMXmnehLtuxh4nCOt5WGGhwKmuBqmynjrWg1/bLiDiPIAf3hajbE4slf9dflKggL8HDDB+VAkQCFmjqsThzJbvmVoKQqtxMegWB+FhcDtyY2mrPPNBKG5rMQs0FE8rrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SW20rBiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SW20rBiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAE3C19425;
	Fri, 24 Apr 2026 13:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038084;
	bh=aCPPCWEY6VPZP8ernkiEIARkUiYqormcO6d/E9gYadQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SW20rBiG3zvW7r5neyGjZhWmRho6LQqpBFPb+uTU95aT8H9W7iskgH0Uq08Aaogxm
	 Cu8tuKEzvoRTgz7fatZ7PZDmx4mU5jLAwajffhGhHitE/daO9XO2T6feuUcBSsVb44
	 6N1BKlHSizFNpFQraQKgD5T+wC/Om07NHskLhdkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"linux-crypto@vger.kernel.org, kunit-dev@googlegroups.com, Eric Biggers" <ebiggers@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 18/55] lib/crc: tests: Add CRC_ENABLE_ALL_FOR_KUNIT
Date: Fri, 24 Apr 2026 15:30:57 +0200
Message-ID: <20260424132433.903655345@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit cdf22aeaad8430905c3aa3b3d0f2686c65395c22 upstream.

Now that crc_kunit uses the standard "depends on" pattern, enabling the
full set of CRC tests is a bit difficult, mainly due to CRC7 being
rarely used.  Add a kconfig option to make it easier.  It is visible
only when KUNIT, so hopefully the extra prompt won't be too annoying.

Link: https://lore.kernel.org/r/20260306033557.250499-3-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crc/Kconfig |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/lib/crc/Kconfig
+++ b/lib/crc/Kconfig
@@ -107,6 +107,20 @@ config CRC_KUNIT_TEST
 	  This is intended to help people writing architecture-specific
 	  optimized versions.  If unsure, say N.
 
+config CRC_ENABLE_ALL_FOR_KUNIT
+	tristate "Enable all CRC functions for KUnit test"
+	depends on KUNIT
+	select CRC7
+	select CRC16
+	select CRC_T10DIF
+	select CRC32
+	select CRC64
+	help
+	  Enable all CRC functions that have test code in CRC_KUNIT_TEST.
+
+	  Enable this only if you'd like the CRC KUnit test suite to test all
+	  the CRC variants, even ones that wouldn't otherwise need to be built.
+
 config CRC_BENCHMARK
 	bool "Benchmark for the CRC functions"
 	depends on CRC_KUNIT_TEST


