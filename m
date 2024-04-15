Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B6D74BE1;
	Mon, 15 Apr 2024 14:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191456; cv=none; b=VGiDkrRTQSLUqiNXXfj4+Xc9DybJnRtws9rQsrJdcwnzzTdvMjTVXCK2/UxzGWLrAAHcHS27hBGAGOBbxuA5xijwx8ifz5FGk0VwFwnd+PRTPdy7mWIIrbtT95oFy3Hkz9+O/Hvm7snvBpK7RSY2IQih27tnaSF632rN8VTqoUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191456; c=relaxed/simple;
	bh=nHXv0hf0igwVz5JpHFYEIbhmkfT2HYJyAFabI2IVgIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbTpOrD+nutvcyeSAHAUiyjd6tuEp+ZXI0Ii9KdviWcEOkS5NxhKAd3sOZeYHl4EFX1xi9NfKR8a88bIak0C+BIjepEnl/A+wgNiGdBcKL7RpapX8fZc58sbmSejsIwTxWK0Hhs0YAhulrWvpuK1GzXKrKLiPD1HJ8Qslg5Umbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuQgnrWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuQgnrWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5E0C113CC;
	Mon, 15 Apr 2024 14:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191456;
	bh=nHXv0hf0igwVz5JpHFYEIbhmkfT2HYJyAFabI2IVgIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuQgnrWMeYBbuDLVyB3ODIVPIXL7wM+J/sCAoF0VHSKKne8SWcOkzhMTz9R2xvKlq
	 PEXBoxtVvnbkQmh9/WdcioMFAQATlsjY6sYznXl7XeYTbBi6MvCycqLl0LqySlFOpr
	 99jMcnrKdGoAQKFHQ5wHjYCYPsWnheROLCrJIfvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.8 149/172] selftests: kselftest: Fix build failure with NOLIBC
Date: Mon, 15 Apr 2024 16:20:48 +0200
Message-ID: <20240415142004.894842166@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 16767502aa990cca2cb7d1372b31d328c4c85b40 upstream.

As Mark explains ksft_min_kernel_version() can't be compiled with nolibc,
it doesn't implement uname().

Fixes: 6d029c25b71f ("selftests/timers/posix_timers: Reimplement check_timer_distribution()")
Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240412123536.GA32444@redhat.com
Closes: https://lore.kernel.org/all/f0523b3a-ea08-4615-b0fb-5b504a2d39df@sirena.org.uk/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kselftest.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -350,6 +350,10 @@ static inline __noreturn __printf(1, 2)
 static inline int ksft_min_kernel_version(unsigned int min_major,
 					  unsigned int min_minor)
 {
+#ifdef NOLIBC
+	ksft_print_msg("NOLIBC: Can't check kernel version: Function not implemented\n");
+	return 0;
+#else
 	unsigned int major, minor;
 	struct utsname info;
 
@@ -357,6 +361,7 @@ static inline int ksft_min_kernel_versio
 		ksft_exit_fail_msg("Can't parse kernel version\n");
 
 	return major > min_major || (major == min_major && minor >= min_minor);
+#endif
 }
 
 #endif /* __KSELFTEST_H */


