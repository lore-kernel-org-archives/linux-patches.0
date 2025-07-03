Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B63F23AB86;
	Thu,  3 Jul 2025 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555113; cv=none; b=s73BUvqAfZsevGQO/+KZ3Pd8NXER6glrPX4UMYLHTmG84QAvGa/91gzoUAYjI8LJ6DWOp7R0hmQdXwMA8mDGfrw4j9Fuo4uB8IywCDQywDVh9kJkNHvEdsaLmUFvsCy9jh8QuPm6QuXQrMQy0mypim2+lhDoGvPPsMaRbp63jaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555113; c=relaxed/simple;
	bh=vly1ByKcexcVFZ5TE+prqGIL3Nwp2vQ8lo8dCt5Q3Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVY5PQXDFnCTXvN1/JDYGrFL5iEgcOkJRMtVxjziUSdZxbZEDSYcaBswBKwVskJBeBfwLAScQtsa/BVny5X+bWQh1U6+eJReA4Oe+9QpH/Q4AfIuqrnR13KlsNFdJOhWS8LlCS44/U9rEPrtjKW9Fh7I18h55H+ytbNlK1xFNJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFELMcOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFELMcOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8E4C4CEE3;
	Thu,  3 Jul 2025 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555113;
	bh=vly1ByKcexcVFZ5TE+prqGIL3Nwp2vQ8lo8dCt5Q3Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFELMcOQzFIs+7WEg+vdigvpKntt9FQnM5U23ypQ4pBpn4AxZ2cbatrD+khWRuzN8
	 LYLrLHPz4Cg1oiwQfHCqN7qMNXX0Twuv6I82xfTXwfZcDgoISRYlyHoCePQ/AgzaXG
	 sWrA5+B+oJ42VuoKpH7thpJxaps4dRo/IbqarXS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Robert Pang <robertpang@google.com>,
	Coly Li <colyli@kernel.org>,
	"Ching-Chun (Jim) Huang" <jserv@ccns.ncku.edu.tw>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 179/263] bcache: remove unnecessary select MIN_HEAP
Date: Thu,  3 Jul 2025 16:41:39 +0200
Message-ID: <20250703144011.522664477@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

From: Kuan-Wei Chiu <visitorckw@gmail.com>

commit 95b2e31e1752494d477c5da89d6789f769b0d67b upstream.

After reverting the transition to the generic min heap library, bcache no
longer depends on MIN_HEAP.  The select entry can be removed to reduce
code size and shrink the kernel's attack surface.

This change effectively reverts the bcache-related part of commit
92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap API
functions").

This is part of a series of changes to address a performance regression
caused by the use of the generic min_heap implementation.

As reported by Robert, bcache now suffers from latency spikes, with P100
(max) latency increasing from 600 ms to 2.4 seconds every 5 minutes.
These regressions degrade bcache's effectiveness as a low-latency cache
layer and lead to frequent timeouts and application stalls in production
environments.

Link: https://lore.kernel.org/lkml/CAJhEC05+0S69z+3+FB2Cd0hD+pCRyWTKLEOsc8BOmH73p1m+KQ@mail.gmail.com
Link: https://lkml.kernel.org/r/20250614202353.1632957-4-visitorckw@gmail.com
Fixes: 866898efbb25 ("bcache: remove heap-related macros and switch to generic min_heap")
Fixes: 92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap API functions")
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reported-by: Robert Pang <robertpang@google.com>
Closes: https://lore.kernel.org/linux-bcache/CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com
Acked-by: Coly Li <colyli@kernel.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -5,7 +5,6 @@ config BCACHE
 	select BLOCK_HOLDER_DEPRECATED if SYSFS
 	select CRC64
 	select CLOSURES
-	select MIN_HEAP
 	help
 	Allows a block device to be used as cache for other devices; uses
 	a btree for indexing and the layout is optimized for SSDs.


