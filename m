Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E851494DC;
	Tue, 25 Jun 2024 09:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308722; cv=none; b=UQVX1VvJgyWLXVzcuArHZUGYS/RWEa/LiWBWli6oq/7OHdkmrXQbpPOAh80majFhsQr7ROmfJ9MkHBWHxVa+yFsYQCikac8nQNTuFuB4rbLEId/hV0mG1m35PcdrOg74mjfiLXBh/HKrQtCI3X5j/3ddGEVtfjLvhqip7Y1eix0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308722; c=relaxed/simple;
	bh=bmMA6mQSkVPytjQaWjTgKSDavQfnSQaxQPHCgvSw2wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ln7VB4ir3N3mdWVcBR43WH8+KR7Uh0jK58OT+VahrL1ZpIUHVD64d9xduQM9B/+cK38kfOo3vwVSR2PG+dO2nsFTKLkiWbgxHwG3icYWfcFBHwJnh0CdlWp4uh7OHV9gJ/5ot2o7GmNuzNgDmhiqZnUoQJag41vBUsMxe27M0/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jB4zpDwq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jB4zpDwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34337C32781;
	Tue, 25 Jun 2024 09:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308721;
	bh=bmMA6mQSkVPytjQaWjTgKSDavQfnSQaxQPHCgvSw2wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jB4zpDwqwaCzWe7p95vCBET7Qp9QvoTrSgWv0kPpV2ujAjnItW93J0T47ae1YdsBM
	 Vy4EkBd39VQE8iYxH1h3AV4GvzaWyeiC4KGzpalXIshiHkfpmVsr9n0A6z6NC3rMN9
	 e1cYnGShpFZyK2oCNE6NGdQb+W4AMZ7yM04XF32E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Chuck Lever III <chuck.lever@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 217/250] gcov: add support for GCC 14
Date: Tue, 25 Jun 2024 11:32:55 +0200
Message-ID: <20240625085556.382393993@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Oberparleiter <oberpar@linux.ibm.com>

commit c1558bc57b8e5b4da5d821537cd30e2e660861d8 upstream.

Using gcov on kernels compiled with GCC 14 results in truncated 16-byte
long .gcda files with no usable data.  To fix this, update GCOV_COUNTERS
to match the value defined by GCC 14.

Tested with GCC versions 14.1.0 and 13.2.0.

Link: https://lkml.kernel.org/r/20240610092743.1609845-1-oberpar@linux.ibm.com
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reported-by: Allison Henderson <allison.henderson@oracle.com>
Reported-by: Chuck Lever III <chuck.lever@oracle.com>
Tested-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/gcov/gcc_4_7.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -18,7 +18,9 @@
 #include <linux/mm.h>
 #include "gcov.h"
 
-#if (__GNUC__ >= 10)
+#if (__GNUC__ >= 14)
+#define GCOV_COUNTERS			9
+#elif (__GNUC__ >= 10)
 #define GCOV_COUNTERS			8
 #elif (__GNUC__ >= 7)
 #define GCOV_COUNTERS			9


