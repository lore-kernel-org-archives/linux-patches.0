Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6B418E778;
	Tue, 10 Sep 2024 10:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964012; cv=none; b=RFuQnIH+I80F4bXrBb0Iaa/2PiYlXxMCfryHWPWPLKYm/iEWSLmvI5xrsTqCa/FS4NB6fZiAX8srgNo4RzBNvDhNw375BNa3wBW8Dv9+rM+VB8TINeBXPuuHVqkst4PvVMQ9QRN0VL9aOkwUsNSceqzgcBWgH+EKba27KtFMloA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964012; c=relaxed/simple;
	bh=OT4Kp4aZYZuz4gBZCmkZGISqHD4vGU3e4QR9tDN4Sqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOa2vv1Rmu3KUfsWaYzEHv3j0NW/y6Q1Vkvt2UrcXi8vLb1s9oYipixYy7OqnCihwpdhRk/yGkA5UtB0ai/DVTt8UEkKs6SfAKc0ptjQXdLbRlupoYh8GChdfwtNK6iZQ62jqWdK5F2umQeJwg5PmFV1xcQ251V0E4kSIUcZU1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDvx1cYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDvx1cYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D4EC4CEC6;
	Tue, 10 Sep 2024 10:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964011;
	bh=OT4Kp4aZYZuz4gBZCmkZGISqHD4vGU3e4QR9tDN4Sqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDvx1cYtexv67KJKENAVhnkc+r/NhP08c4RUSBm1nzg8z+f8RSRqknYwEyISFZe5a
	 x5O9BFhmsi5UXy0e66TfsVluI3Ux/Q5VDTvNJ63hqbKmxCpfqjEFJAji7S//yt2Kel
	 g1GMS3kvFhMyL8u1p/ooI/PbAhaOJ6dfaYfonnCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <ptesarik@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Eric DeVolder <eric_devolder@yahoo.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 038/269] kexec_file: fix elfcorehdr digest exclusion when CONFIG_CRASH_HOTPLUG=y
Date: Tue, 10 Sep 2024 11:30:25 +0200
Message-ID: <20240910092609.614780038@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Petr Tesarik <ptesarik@suse.com>

commit 6dacd79d28842ff01f18b4900d897741aac5999e upstream.

Fix the condition to exclude the elfcorehdr segment from the SHA digest
calculation.

The j iterator is an index into the output sha_regions[] array, not into
the input image->segment[] array.  Once it reaches
image->elfcorehdr_index, all subsequent segments are excluded.  Besides,
if the purgatory segment precedes the elfcorehdr segment, the elfcorehdr
may be wrongly included in the calculation.

Link: https://lkml.kernel.org/r/20240805150750.170739-1-petr.tesarik@suse.com
Fixes: f7cc804a9fd4 ("kexec: exclude elfcorehdr from the segment digest")
Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Eric DeVolder <eric_devolder@yahoo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kexec_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -728,7 +728,7 @@ static int kexec_calculate_store_digests
 
 #ifdef CONFIG_CRASH_HOTPLUG
 		/* Exclude elfcorehdr segment to allow future changes via hotplug */
-		if (j == image->elfcorehdr_index)
+		if (i == image->elfcorehdr_index)
 			continue;
 #endif
 


