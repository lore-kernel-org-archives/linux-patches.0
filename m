Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E37D188CC1;
	Tue, 10 Sep 2024 09:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961400; cv=none; b=a+HNOBsTAUpsc0ihDvzsbe3HX7fhM74bRAgLkriq0sF30Ml8w5BFJVOs9ODI+0XejHlLESz3MskHXbr6bC1zNJ/Jm9VrRzibnomBr48XHqS94kY0dcoTimV+YNRxb0SE0U7MVi9R2NnY9nLQ21SMFtLACJ2z0kcIkCp+fYEMg2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961400; c=relaxed/simple;
	bh=D9vNFYiW0hRlc+a2pqiicVtkdo/fMer/oTLUFPLRiTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SywTgCm1dhCJILmkWu6XdvTvJpSvMG95TJTTaqAITko14vPO6O/1cBKBT889xz6nCg14m5pFII+DL/11X0XI524eEuw4qW4LkcgtxV2dPFouOynM+m/NGX0YBSooE5yy/Al9BnNj5Y6W26V8gdJt9UuHSJigF18iLUb6uOFK3As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYo1xF2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYo1xF2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A41C4CEC3;
	Tue, 10 Sep 2024 09:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961400;
	bh=D9vNFYiW0hRlc+a2pqiicVtkdo/fMer/oTLUFPLRiTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYo1xF2DATM1SoIQLCR0HPjwmKtr4ssFCMcUJHsuBjO56fPpHFz7X9F7oBJ4MqhMJ
	 pcmHeVYpN4gs8bprMdGVRiuKL5/7QMOJndMB9ZuMyLIu5peiE+hKw9CctaFfjMzgNA
	 YxuLdmS5hLo9Wuh1P7MMbRWGf0RyUgP7fc0NZIhY=
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
Subject: [PATCH 6.10 057/375] kexec_file: fix elfcorehdr digest exclusion when CONFIG_CRASH_HOTPLUG=y
Date: Tue, 10 Sep 2024 11:27:34 +0200
Message-ID: <20240910092624.148346137@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -752,7 +752,7 @@ static int kexec_calculate_store_digests
 
 #ifdef CONFIG_CRASH_HOTPLUG
 		/* Exclude elfcorehdr segment to allow future changes via hotplug */
-		if (j == image->elfcorehdr_index)
+		if (i == image->elfcorehdr_index)
 			continue;
 #endif
 


